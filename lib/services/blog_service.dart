import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blog_model.dart';

class BlogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new blog
  Future<void> createBlog(BlogModel blog) async {
    await _firestore.collection('blogs').doc(blog.blogId).set(blog.toMap());
  }

  // Get all blogs
  Stream<List<BlogModel>> getAllBlogs() {
    return _firestore
        .collection('blogs')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BlogModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Get blogs by user
  Stream<List<BlogModel>> getBlogsByUser(String userId) {
    return _firestore
        .collection('blogs')
        .where('authorId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BlogModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Get blogs by followed users
  Stream<List<BlogModel>> getBlogsByFollowedUsers(List<String> followedUserIds) {
    if (followedUserIds.isEmpty) {
      return Stream.value([]);
    }
    
    return _firestore
        .collection('blogs')
        .where('authorId', whereIn: followedUserIds)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BlogModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Get blog by ID
  Future<BlogModel?> getBlogById(String blogId) async {
    final doc = await _firestore.collection('blogs').doc(blogId).get();
    if (doc.exists) {
      return BlogModel.fromMap(doc.data()!, blogId);
    }
    return null;
  }

  // Update blog
  Future<void> updateBlog(BlogModel blog) async {
    await _firestore.collection('blogs').doc(blog.blogId).update(blog.toMap());
  }

  // Delete blog
  Future<void> deleteBlog(String blogId) async {
    await _firestore.collection('blogs').doc(blogId).delete();
  }

  // Like a blog
  Future<void> likeBlog(String blogId, String userId) async {
    await _firestore.collection('blogs').doc(blogId).update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  // Unlike a blog
  Future<void> unlikeBlog(String blogId, String userId) async {
    await _firestore.collection('blogs').doc(blogId).update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }

  // Check if user liked a blog
  Future<bool> isLiked(String blogId, String userId) async {
    final blog = await getBlogById(blogId);
    return blog?.likes.contains(userId) ?? false;
  }
}