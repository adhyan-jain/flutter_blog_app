import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a comment to a blog
  Future<void> addComment(String blogId, CommentModel comment) async {
    await _firestore
        .collection('blogs')
        .doc(blogId)
        .collection('comments')
        .doc(comment.commentId)
        .set(comment.toMap());
  }

  // Get comments for a blog
  Stream<List<CommentModel>> getComments(String blogId) {
    return _firestore
        .collection('blogs')
        .doc(blogId)
        .collection('comments')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CommentModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Delete a comment
  Future<void> deleteComment(String blogId, String commentId) async {
    await _firestore
        .collection('blogs')
        .doc(blogId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  // Get comment by ID
  Future<CommentModel?> getCommentById(String blogId, String commentId) async {
    final doc = await _firestore
        .collection('blogs')
        .doc(blogId)
        .collection('comments')
        .doc(commentId)
        .get();
    if (doc.exists) {
      return CommentModel.fromMap(doc.data()!, commentId);
    }
    return null;
  }
}
