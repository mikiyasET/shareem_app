import 'package:get/get.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/helpers/format.helper.dart';
import 'package:shareem_app/model/Tag.dart';
import 'package:shareem_app/utils/enums.dart';

class Draft {
  late int id;
  final String title;
  final String content;
  final List<Tag> tags;
  final Feeling feeling;

  Draft({
    this.id = 0,
    required this.title,
    required this.content,
    required this.tags,
    required this.feeling,
  });

  factory Draft.fromJson(Map<String, dynamic> json) {
    final ventController = Get.find<VentController>();
    return Draft(
      id: json['id'] ?? 0,
      title: json['title'],
      content: json['content'],
      tags: json['tags'].length > 0
          ? json['tags']
              .map<Tag>((t) =>
                  ventController.tags.firstWhere((t2) => t2.id == t['id']))
              .toList()
          : [],
      feeling: strToFeeling(json['feeling']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tags': tags.map((t) => t.toJson()).toList(),
      'feeling': feeling.toString().split('.').last,
    };
  }
}
