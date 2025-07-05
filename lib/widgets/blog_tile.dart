import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/blog_model.dart';
import '../models/comment_model.dart';
import '../providers/blog_provider.dart';
import '../providers/user_provider.dart';
import '../services/comment_service.dart';
import '../screens/blog/blog_detail_screen.dart';

class BlogTile extends StatelessWidget {
  final BlogModel blog;
  const BlogTile({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isAuthor = currentUserId == blog.authorId;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
        padding: const EdgeInsets.all(16),
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
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Text(
                      blog.authorName[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            blog.authorName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (!isAuthor) ...[
                            const SizedBox(width: 8),
                            Consumer<UserProvider>(
                              builder: (context, userProvider, child) {
                                return FutureBuilder<bool>(
                                  future: userProvider.isFollowing(blog.authorId),
                                  builder: (context, snapshot) {
                                    final isFollowing = snapshot.data ?? false;
                                    return GestureDetector(
                                      onTap: () async {
                                        if (isFollowing) {
                                          await userProvider.unfollowUser(blog.authorId);
                                        } else {
                                          await userProvider.followUser(blog.authorId);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: isFollowing 
                                                ? [Colors.grey, Color(0xFF757575)]
                                                : [Colors.deepPurple, Colors.purple],
                                          ),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          isFollowing ? 'Unfollow' : 'Follow',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ],
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
                if (isAuthor)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
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
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Edit', style: TextStyle(color: Colors.blue)),
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
            const SizedBox(height: 12),
            Text(
              blog.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              blog.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
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
                                                          Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isLiked 
                                        ? [Colors.red, Color(0xFFD32F2F)]
                                        : [Colors.grey, Color(0xFF757575)],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              child: IconButton(
                                icon: Icon(
                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (isLiked) {
                                    blogProvider.unlikeBlog(blog.blogId);
                                  } else {
                                    blogProvider.likeBlog(blog.blogId);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Consumer<BlogProvider>(
                              builder: (context, blogProvider, child) {
                                return StreamBuilder<List<BlogModel>>(
                                  stream: blogProvider.blogService.getAllBlogs(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final updatedBlog = snapshot.data!.firstWhere(
                                        (b) => b.blogId == blog.blogId,
                                        orElse: () => blog,
                                      );
                                      return Text(
                                        '${updatedBlog.likes.length}',
                                        style: const TextStyle(color: Colors.white),
                                      );
                                    }
                                    return Text(
                                      '${blog.likes.length}',
                                      style: const TextStyle(color: Colors.white),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 16),
                                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Color(0xFF1976D2)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.comment, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/blog-detail',
                            arguments: blog,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    StreamBuilder<List<CommentModel>>(
                      stream: CommentService().getComments(blog.blogId),
                      builder: (context, snapshot) {
                        int commentCount = 0;
                        if (snapshot.hasData) {
                          commentCount = snapshot.data!.length;
                        }
                        return Text(
                          '$commentCount',
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.purple],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/blog-detail',
                        arguments: blog,
                      );
                    },
                    child: const Text(
                      'Read More',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
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
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
