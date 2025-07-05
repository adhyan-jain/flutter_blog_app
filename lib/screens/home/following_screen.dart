import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/blog_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/blog_tile.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Consumer2<BlogProvider, UserProvider>(
        builder: (context, blogProvider, userProvider, child) {
          if (userProvider.currentUser == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (userProvider.currentUser!.following.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No followed users',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Follow some users to see their blogs here!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (blogProvider.followingBlogs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.article, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No blogs from followed users',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'The users you follow haven\'t posted anything yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: blogProvider.followingBlogs.length,
            itemBuilder: (context, index) {
              final blog = blogProvider.followingBlogs[index];
              return BlogTile(blog: blog);
            },
          );
        },
      ),
    );
  }
}