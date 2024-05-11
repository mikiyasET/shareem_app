import 'package:get/get.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/helpers/format.helper.dart';
import 'package:shareem_app/model/Comment.dart';
import 'package:shareem_app/model/Saved.dart';
import 'package:shareem_app/model/Tag.dart';
import 'package:shareem_app/model/VentUser.dart';
import 'package:shareem_app/utils/enums.dart';

class Vent {
  final String id;
  final String title;
  final String content;
  final String userId;
  final VentUser author;
  late int likes;
  late bool isLiked;
  late bool isDisliked;
  late int comments;
  final List<Comment> commentList;
  final Feeling feeling;
  final List<Tag> tags;
  final List<Saved> saved;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vent({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.author,
    required this.likes,
    this.isLiked = false,
    this.isDisliked = false,
    required this.comments,
    this.commentList = const [],
    required this.feeling,
    required this.tags,
    required this.saved,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vent.fromJson(Map<String, dynamic> json) {
    final ventController = Get.find<VentController>();
    // print("_____");
    return Vent(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      userId: json['userId'],
      author: VentUser.fromJson(json['user']),
      likes: json['likes'],
      isLiked: json['like'].length > 0 && json['like'][0]['type'] == 'upvote',
      isDisliked:
          json['like'].length > 0 && json['like'][0]['type'] == 'downvote',
      comments: json['comments'],
      commentList: [],
      feeling: strToFeeling(json['feeling']),
      tags: json['tags'].length > 0
          ? json['tags']
              .map<Tag>((t) =>
                  ventController.tags.firstWhere((t2) => t2.id == t['tag_id']))
              .toList()
          : [],
      saved: json['saved'].length > 0
          ? json['saved'].map<Saved>((s) => Saved.fromJson(s)).toList()
          : [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'userId': userId,
        'author': author.toJson(),
        'likes': likes,
        'isLiked': isLiked,
        'isDisLiked': isDisliked,
        'comments': comments,
        'commentList': commentList.map((c) => c.toJson()).toList(),
        'feeling': feeling,
        'tags': tags,
        'saved': saved,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
