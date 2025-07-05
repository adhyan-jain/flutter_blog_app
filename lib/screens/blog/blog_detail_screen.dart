import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/blog_model.dart';
import '../../providers/blog_provider.dart';
import '../comments/comment_screen.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogModel blog;
  
  const BlogDetailScreen({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isAuthor = currentUserId == blog.authorId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          if (isAuthor)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.pushNamed(
                    context,
                    '/edit-blog',
                    arguments: blog,
                  );
                } else if (value == 'delete') {
                  _showDeleteDialog(context);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info
            Row(
              children: [
                CircleAvatar(
                  child: Text(blog.authorName[0].toUpperCase()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        blog.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatDate(blog.timestamp),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              blog.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Content
            Text(
              blog.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            
            // Actions
            Row(
              children: [
                Consumer<BlogProvider>(
                  builder: (context, blogProvider, child) {
                    return FutureBuilder<bool>(
                      future: blogProvider.isLiked(blog.blogId),
                      builder: (context, snapshot) {
                        final isLiked = snapshot.data ?? false;
                        return Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? Colors.red : null,
                              ),
                              onPressed: () {
                                if (isLiked) {
                                  blogProvider.unlikeBlog(blog.blogId);
                                } else {
                                  blogProvider.likeBlog(blog.blogId);
                                }
                              },
                            ),
                            Text('${blog.likes.length}'),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentScreen(blog: blog),
                          ),
                        );
                      },
                    ),
                    const Text('0'), // TODO: Add comment count
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Comments section
            const Text(
              'Comments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // TODO: Add comments list here
            const Center(
              child: Text(
                'No comments yet',
                style: TextStyle(color: Colors.grey),
              ),
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

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Blog'),
        content: const Text('Are you sure you want to delete this blog?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<BlogProvider>(context, listen: false)
                  .deleteBlog(blog.blogId);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}