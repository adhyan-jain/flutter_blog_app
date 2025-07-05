import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/blog_model.dart';
import '../services/blog_service.dart';

class BlogProvider with ChangeNotifier {
  BlogService _blogService = BlogService();
  
  BlogService get blogService => _blogService;
  List<BlogModel> _blogs = [];
  List<BlogModel> _followingBlogs = [];
  List<BlogModel> _userBlogs = [];

  List<BlogModel> get blogs => _blogs;
  List<BlogModel> get followingBlogs => _followingBlogs;
  List<BlogModel> get userBlogs => _userBlogs;

  void listenToAllBlogs() {
    _blogService.getAllBlogs().listen((event) {
      _blogs = event;
      notifyListeners();
    });
  }

  void listenToFollowingBlogs(List<String> followedUserIds) {
    _blogService.getBlogsByFollowedUsers(followedUserIds).listen((event) {
      _followingBlogs = event;
      notifyListeners();
    });
  }

  void listenToUserBlogs(String userId) {
    _blogService.getBlogsByUser(userId).listen((event) {
      _userBlogs = event;
      notifyListeners();
    });
  }

  Future<void> createBlog(BlogModel blog) async {
    await _blogService.createBlog(blog);
  }

  Future<void> updateBlog(BlogModel blog) async {
    await _blogService.updateBlog(blog);
  }

  Future<void> deleteBlog(String blogId) async {
    await _blogService.deleteBlog(blogId);
  }

  Future<void> likeBlog(String blogId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      print('Liking blog: $blogId by user: $userId');
      await _blogService.likeBlog(blogId, userId);
      print('Like operation completed');
    }
  }

  Future<void> unlikeBlog(String blogId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      print('Unliking blog: $blogId by user: $userId');
      await _blogService.unlikeBlog(blogId, userId);
      print('Unlike operation completed');
    }
  }

  Future<bool> isLiked(String blogId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      return await _blogService.isLiked(blogId, userId);
    }
    return false;
  }

  void clearBlogs() {
    _blogs = [];
    _followingBlogs = [];
    _userBlogs = [];
    notifyListeners();
  }
}
