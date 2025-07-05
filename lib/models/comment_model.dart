import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String commenterId;
  final String content;
  final DateTime timestamp;

  CommentModel({
    required this.commentId,
    required this.commenterId,
    required this.content,
    required this.timestamp,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map, String commentId) {
    return CommentModel(
      commentId: commentId,
      commenterId: map['commenterId'] ?? '',
      content: map['content'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commenterId': commenterId,
      'content': content,
      'timestamp': timestamp,
    };
  }

  CommentModel copyWith({
    String? commentId,
    String? commenterId,
    String? content,
    DateTime? timestamp,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      commenterId: commenterId ?? this.commenterId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
