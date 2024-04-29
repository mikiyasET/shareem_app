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
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
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
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(.7),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '...',
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(.7),
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
                            Icon(CupertinoIcons.up_arrow,
                                color: Theme.of(context).colorScheme.onSurface),
                            SizedBox(width: 10),
                            Text(
                              upvotes.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 15),
                        Row(children: [
                          Icon(CupertinoIcons.down_arrow,
                              color: Theme.of(context).colorScheme.onSurface),
                          SizedBox(width: 10),
                          Text(
                            '2.5k',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ]),
                      ],
                    ),
                    Row(children: [
                      Icon(Icons.messenger_outline_sharp,
                          color: Theme.of(context).colorScheme.onSurface),
                      SizedBox(width: 10),
                      Text(
                        comments.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ]),
                    Icon(Icons.bookmark_outline,
                        color: Theme.of(context).colorScheme.onSurface),
                    Icon(CupertinoIcons.share,
                        color: Theme.of(context).colorScheme.onSurface),
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
