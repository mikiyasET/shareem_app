import 'package:flutter/material.dart';

class CommentedPage extends StatefulWidget {
  const CommentedPage({super.key});

  @override
  State<CommentedPage> createState() => _CommentedPageState();
}

class _CommentedPageState extends State<CommentedPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Comments'),
      ),
    );
  }
}
