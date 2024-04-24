const String tableMovizies = 'movizies';

class MovizyFields {
  static final List<String> values = [id, title, description, time];

  static const String id = '_id';
  static const String title = 'title';
  static const String picture = 'picture';
  static const String description = 'description';
  static const String time = 'time';
}

class Movizy {
  final int? id;
  final String title;
  final String picture;
  final String description;
  final DateTime createdTime;

  const Movizy({
    this.id,
    required this.title,
    required this.picture,
    required this.description,
    required this.createdTime,
  });

  Map<String, Object?> toJson() => {
        MovizyFields.id: id,
        MovizyFields.title: title,
        MovizyFields.picture: picture,
        MovizyFields.description: description,
        MovizyFields.time: createdTime.toIso8601String()
      };

  static Movizy fromJson(Map<String, Object?> json) => Movizy(
        id: json[MovizyFields.id] as int?,
        title: json[MovizyFields.title] as String,
        picture: json[MovizyFields.picture] as String,
        description: json[MovizyFields.description] as String,
        createdTime: DateTime.parse(json[MovizyFields.time] as String),
      );

  Movizy copy({
    int? id,
    String? title,
    String? picture,
    String? description,
    DateTime? createdTime,
  }) =>
      Movizy(
          id: id ?? this.id,
          title: title ?? this.title,
          picture: picture ?? this.picture,
          description: description ?? this.description,
          createdTime: createdTime ?? this.createdTime);
}
