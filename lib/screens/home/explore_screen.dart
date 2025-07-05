import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/blog_provider.dart';
import '../../widgets/blog_tile.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

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
            'Explore',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<BlogProvider>(
        builder: (context, blogProvider, child) {
          if (blogProvider.blogs.isEmpty) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.article, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No blogs yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      'Be the first to create a blog!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: blogProvider.blogs.length,
            itemBuilder: (context, index) {
              final blog = blogProvider.blogs[index];
              return BlogTile(blog: blog);
            },
          );
        },
      ),
    );
  }
}