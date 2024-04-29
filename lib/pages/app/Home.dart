import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shareem_app/widgets/EMPost.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EMPost(
            title: 'About my new born son',
            content:
            'I have been be blessed with is not helthy he keeps crying',
            author: 'Feven Alemu',
            date: '5 hours ago',
            upvotes: 57,
            comments: 5,
          ),
          EMPost(
            title: 'I got a lottory ticket worth 1 million birr',
            content: 'What would you do if you were in my shoes?',
            author: 'Solomon Niggusie',
            date: '12 hours ago',
            authorAvatar: 'https://previews.123rf.com/images/aleshyn/aleshyn1402/aleshyn140200165/25985734-picture-of-beautiful-girl-on-the-ocean.jpg',
            upvotes: 100,
            comments: 23,
          ),
        ],
      ),
    );
  }
}
