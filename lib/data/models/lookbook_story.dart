import 'json_utils.dart';

/// A story bubble on the home screen (`GET /home/stories`).
class LookbookStory {
  final String id;
  final String label;
  final String imageUrl;
  final bool hasUnseen;

  const LookbookStory({
    required this.id,
    required this.label,
    required this.imageUrl,
    this.hasUnseen = true,
  });

  /// Parses one item of `GET /home/stories`.
  factory LookbookStory.fromJson(JsonMap json) => LookbookStory(
        id: json.str('id'),
        label: json.str('label'),
        imageUrl: json.str('imageUrl'),
        hasUnseen: json.boolOr('hasUnseen', fallback: true),
      );

  /// Serialises to the API JSON shape.
  JsonMap toJson() => {'id': id, 'label': label, 'imageUrl': imageUrl, 'hasUnseen': hasUnseen};
}
