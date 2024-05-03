class Tag {
  final int id;
  final String name;
  final int count;

  Tag({required this.id, required this.name, required this.count});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'count': count,
      };
}
