import 'package:flutter/material.dart';

class EMChat extends StatelessWidget {
  final String? image;
  final String name;
  final String message;
  final String time;
  final int unread;
  final ChatType type;

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
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
            width: .3,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: image == null
              ? null
              : const NetworkImage(
                  'https://previews.123rf.com/images/aleshyn/aleshyn1402/aleshyn140200165/25985734-picture-of-beautiful-girl-on-the-ocean.jpg'),
          child: image == null
              ? Text(
                  shortName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                )
              : null,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  type == ChatType.received
                      ? const SizedBox()
                      : Icon(
                          type == ChatType.seen
                              ? Icons.done_all
                              : type == ChatType.delivered
                                  ? Icons.done_all
                                  : Icons.done,
                          size: 20,
                          color:
                              type == ChatType.seen ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withOpacity(.5),
                        ),
                  const SizedBox(width: 10),
                  Text(time),
                ],
              ),
            ),
            const SizedBox(height: 5),
            unread > 0
                ? CircleAvatar(
                    radius: 13,
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    child: Text(
                      unread.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

enum ChatType { seen, delivered, sent, received }
