import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../models/blog_model.dart';
import '../../models/comment_model.dart';
import '../../services/comment_service.dart';

class CommentScreen extends StatefulWidget {
  final BlogModel blog;
  
  const CommentScreen({Key? key, required this.blog}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _commentController = TextEditingController();
  final _commentService = CommentService();
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final comment = CommentModel(
        commentId: const Uuid().v4(),
        commenterId: currentUser.uid,
        content: _commentController.text.trim(),
        timestamp: DateTime.now(),
      );

      await _commentService.addComment(widget.blog.blogId, comment);
      _commentController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: const Text(
            'Comments',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: Column(
          children: [
            // Blog info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.blog.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${widget.blog.authorName}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Comments list
            Expanded(
              child: StreamBuilder<List<CommentModel>>(
                stream: _commentService.getComments(widget.blog.blogId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final comments = snapshot.data ?? [];

                  if (comments.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No comments yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            'Be the first to comment!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return _buildCommentTile(comment);
                    },
                  );
                },
              ),
            ),
            
            // Add comment
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
                ),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: TextField(
                        controller: _commentController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.deepPurple, Colors.purple],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: _isLoading ? null : _addComment,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentTile(CommentModel comment) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isCommenter = currentUserId == comment.commenterId;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.purple],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.transparent,
                    child: Text(
                      comment.commenterId[0].toUpperCase(),
                      style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.commenterId, // TODO: Get username from user service
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _formatDate(comment.timestamp),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCommenter)
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.red, Color(0xFFD32F2F)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete, size: 16, color: Colors.white),
                      onPressed: () => _showDeleteCommentDialog(comment),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              comment.content,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showDeleteCommentDialog(CommentModel comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _commentService.deleteComment(widget.blog.blogId, comment.commentId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
