import 'package:flutter/material.dart';
import 'package:shareem_app/widgets/EMChat.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
              child: Text('Messages'),
            ),
            EMChat(
              name: 'Mikiyas Lemlemu',
              message: "Eyemetaw new",
              time: '10:00 PM',
              image: 'https://previews.123rf.com/images/aleshyn/aleshyn1402/aleshyn140200165/25985734-picture-of-beautiful-girl-on-the-ocean.jpg',
              unread: 6,
              type: ChatType.received,
            ),
            EMChat(
              name: 'Solomon Nigguse',
              message: "Eyemetaw new",
              time: '10:00 PM',
              type: ChatType.sent,
            ),
            EMChat(
              name: 'Surafel Zeleke',
              message: "Eyemetaw new",
              time: '10:00 PM',
              image: 'https://previews.123rf.com/images/aleshyn/aleshyn1402/aleshyn140200165/25985734-picture-of-beautiful-girl-on-the-ocean.jpg',
              type: ChatType.seen,
            ),
            EMChat(
              name: 'Yoseph Taddese',
              message: "Eyemetaw new",
              time: '10:00 PM',
              type: ChatType.delivered,
            ),
          ],
        ),
      ),
    );
  }
}
