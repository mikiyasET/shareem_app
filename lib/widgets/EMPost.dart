import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shareem_app/model/Tag.dart';
import 'package:shareem_app/service/api/vent.api.dart';
import 'package:shareem_app/utils/constants.dart';
import 'package:shareem_app/utils/enums.dart';

class EMPost extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  final Feeling feeling;
  final String author;
  final String? authorAvatar;
  final String date;
  final int upvotes;
  final int comments;
  final bool isLiked;
  final bool isDisliked;
  final bool isSaved;
  final List<Tag> tags;
  final bool isDetailed;
  final bool bottomBorder;
  final bool tools;
  final Function()? onTap;

  const EMPost({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.feeling,
    required this.author,
    this.authorAvatar,
    required this.date,
    required this.upvotes,
    required this.comments,
    this.isLiked = false,
    this.isDisliked = false,
    this.isSaved = false,
    this.tags = const [],
    this.isDetailed = false,
    this.bottomBorder = true,
    this.tools = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shortName = author.split(' ').map((e) => e[0]).join();
    final VentApi ventApi = VentApi();

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
              width: bottomBorder ? .5 : 0,
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
                    backgroundImage: authorAvatar == null
                        ? null
                        : NetworkImage("${profileUrl}/${authorAvatar!}"),
                    child: authorAvatar == null
                        ? Text(
                            shortName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    author,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  feeling.toString().split('.').last == 'none'
                      ? SizedBox()
                      : Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(feeling.toString().split('.').last,
                              style: const TextStyle(fontSize: 12)),
                        ),
                  const Spacer(),
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
            const SizedBox(height: 10),
            isDetailed
                ? Text(
                    content,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(.7),
                    ),
                  )
                : Text(
                    content.length > 200
                        ? content.replaceAll("\n", " ").substring(0, 200)
                        : content.replaceAll("\n", " "),
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(.7),
                    ),
                  ),
            const SizedBox(height: 5),
            content.length > 200 && !isDetailed
                ? Text(
                    '...',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(.7),
                      fontSize: 15,
                    ),
                  )
                : const SizedBox(),
            tags.length > 0 ? const SizedBox(height: 5) : SizedBox(),
            tags.length > 0
                ? Wrap(
                    children: tags
                        .map((tag) => Container(
                              margin: const EdgeInsets.only(right: 5, top: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '#${tag.name}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ))
                        .toList(),
                  )
                : const SizedBox(),
            tools
                ? Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                ventApi.reactVent(id, true);
                              },
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.up_arrow,
                                      color: isLiked
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                  const SizedBox(width: 10),
                                  Text(
                                    upvotes.toString(),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            InkWell(
                              onTap: () {
                                ventApi.reactVent(id, false);
                              },
                              child: Icon(CupertinoIcons.down_arrow,
                                  color: isDisliked
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                            ),
                          ],
                        ),
                        Row(children: [
                          Icon(Icons.messenger_outline_sharp,
                              color: Theme.of(context).colorScheme.onSurface),
                          const SizedBox(width: 10),
                          Text(
                            comments.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ]),
                        InkWell(
                          onTap: () {
                            ventApi.saveVent(id);
                          },
                          child: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_outline,
                              color: isSaved
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface),
                        ),
                        Icon(CupertinoIcons.share,
                            color: Theme.of(context).colorScheme.onSurface),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
