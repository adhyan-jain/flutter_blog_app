// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blog_app/main.dart';

void main() {
  testWidgets('BlogApp launches without crashing', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const BlogApp());

    // Verify the root widget exists
    expect(find.byType(BlogApp), findsOneWidget);
  });
}
