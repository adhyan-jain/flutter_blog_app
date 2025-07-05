import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/user_provider.dart';
import '../../providers/blog_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/blog_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider = Provider.of<BlogAuthProvider>(context, listen: false);
              await authProvider.logout();
            },
          ),
        ],
      ),
      body: Consumer2<UserProvider, BlogProvider>(
        builder: (context, userProvider, blogProvider, child) {
          if (userProvider.currentUser == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = userProvider.currentUser!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user.profilePicUrl.isNotEmpty
                              ? CachedNetworkImageProvider(user.profilePicUrl)
                              : null,
                          child: user.profilePicUrl.isEmpty
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.username,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn('Followers', user.followers.length.toString()),
                            _buildStatColumn('Following', user.following.length.toString()),
                            _buildStatColumn('Blogs', blogProvider.userBlogs.length.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // User's Blogs
                const Text(
                  'My Blogs',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                if (blogProvider.userBlogs.isEmpty)
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.article, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No blogs yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        Text(
                          'Create your first blog!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: blogProvider.userBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = blogProvider.userBlogs[index];
                      return BlogTile(blog: blog);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}