import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EMPost extends StatelessWidget {
  final String title;
  final String content;
  final String author;
  final String? authorAvatar;
  final String date;
  final int upvotes;
  final int comments;

  const EMPost(
      {super.key,
      required this.title,
      required this.content,
      required this.author,
      this.authorAvatar,
      required this.date,
      required this.upvotes,
      required this.comments});

  @override
  Widget build(BuildContext context) {
    final shortName = author.split(' ').map((e) => e[0]).join();

    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: .5,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 13,
                        child: authorAvatar == null
                            ? Text(
                                shortName,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              )
                            : null,
                        backgroundImage: authorAvatar == null
                            ? null
                            : NetworkImage(authorAvatar!),
                      ),
                      SizedBox(width: 10),
                      Text(
                        author,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '...',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'images/icons/upvote_outline.png',
                              width: 20,
                              height: 19,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(width: 10),
                            Text(
                              upvotes.toString(),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 15),
                        Row(children: [
                          Image.asset(
                            'images/icons/downvote_outline.png',
                            width: 20,
                            height: 19,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '2.5k',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ]),
                      ],
                    ),
                    Row(children: [
                      Icon(Icons.messenger_outline_sharp, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        comments.toString(),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ]),
                    Icon(Icons.bookmark_outline, color: Colors.black),
                    Icon(CupertinoIcons.share, color: Colors.black),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
