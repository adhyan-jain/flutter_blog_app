import 'package:flutter/material.dart';
import '../models/comment_model.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onDelete;
  const CommentTile({super.key, required this.comment, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(comment.content),
      subtitle: Text(comment.commenterId),
      trailing: onDelete != null ? IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)) : null,
    );
  }
}