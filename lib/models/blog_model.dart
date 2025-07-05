import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String blogId;
  final String authorId;
  final String authorName;
  final String title;
  final String content;
  final DateTime timestamp;
  final List<String> likes;

  BlogModel({
    required this.blogId,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.likes,
  });

  // ✅ Create a BlogModel from Firestore map
  factory BlogModel.fromMap(Map<String, dynamic> map, String blogId) {
    return BlogModel(
      blogId: blogId,
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(map['likes'] ?? []),
    );
  }

  // ✅ Convert BlogModel to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'title': title,
      'content': content,
      'timestamp': timestamp,
      'likes': likes,
    };
  }

  // ✅ For updating fields like title/content in edit screen
  BlogModel copyWith({
    String? blogId,
    String? authorId,
    String? authorName,
    String? title,
    String? content,
    DateTime? timestamp,
    List<String>? likes,
  }) {
    return BlogModel(
      blogId: blogId ?? this.blogId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
    );
  }
}
