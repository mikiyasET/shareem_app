import 'package:flutter/material.dart';

class EMChat extends StatelessWidget {
  final String? image;
  final String name;
  final String message;
  final String time;
  final int unread;
  final chatType type;

  const EMChat(
      {super.key,
      this.image,
      required this.name,
      required this.message,
      required this.time,
      this.unread = 0,
      required this.type});

  @override
  Widget build(BuildContext context) {
    final shortName = name.split(' ').map((e) => e[0]).join();
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 3),
      leading: CircleAvatar(
        radius: 28,
        child: image == null
            ? Text(
                shortName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              )
            : null,
        backgroundImage: image == null
            ? null
            : const NetworkImage(
                'https://previews.123rf.com/images/aleshyn/aleshyn1402/aleshyn140200165/25985734-picture-of-beautiful-girl-on-the-ocean.jpg'),
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(message),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: unread > 0 ? MainAxisAlignment.center : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 85,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                type == chatType.received
                    ? SizedBox()
                    : Icon(
                        type == chatType.seen
                            ? Icons.done_all
                            : type == chatType.delivered
                                ? Icons.done_all
                                : Icons.done,
                        size: 20,
                        color:
                            type == chatType.seen ? Colors.black : Colors.grey,
                      ),
                SizedBox(width: 10),
                Text(time),
              ],
            ),
          ),
          SizedBox(height: 5),
          unread > 0
              ? CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.black,
                  child: Text(
                    unread.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      // bottom border
      shape: Border(
        bottom: BorderSide(
          color: Colors.black12,
          width: .5,
        ),
      ),
    );
  }
}

enum chatType { seen, delivered, sent, received }
