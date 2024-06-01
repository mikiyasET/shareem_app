import 'package:flutter/material.dart';
import 'package:shareem_app/utils/enums.dart';

class EMChatText extends StatelessWidget {
  final String message;
  final bool isMe;
  final String date;
  final ChatStatus? status;
  final ChatType type;

  const EMChatText({
    super.key,
    required this.message,
    this.isMe = false,
    required this.date,
    this.status,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    IconData getStatusIcon() {
      switch (status) {
        case ChatStatus.delivered:
          return Icons.done;
        case ChatStatus.seen:
          return Icons.done_all;
        default:
          return Icons.access_time;
      }
    }

    return Align(
      alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .7,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.onSurface.withOpacity(.1)
              : Colors.blue.withOpacity(.2),
          borderRadius: isMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "$message   ",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextSpan(
                      text: date,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.transparent,
                      ),
                    ),
                    isMe
                        ? TextSpan(
                            text: 'too',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.transparent,
                            ),
                          )
                        : TextSpan(),
                  ],
                ),
              ),
            ),

            //real additionalInfo
            Positioned(
              child: isMe
                  ? Row(
                      children: [
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.5),
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          getStatusIcon(),
                          size: 15,
                          color: status == ChatStatus.seen
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(.5),
                        ),
                      ],
                    )
                  : Text(
                      date,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.5),
                      ),
                    ),
              right: 0.0,
              bottom: 8.0,
            )
          ],
        ),
      ),
    );
  }
}
