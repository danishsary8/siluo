import 'json_utils.dart';

/// A home-screen hero campaign (`GET /home/campaigns`).
class CapsuleCollection {
  final String id;
  final String tag;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String ctaText;

  const CapsuleCollection({
    required this.id,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.ctaText = 'Shop now',
  });

  /// Parses one item of `GET /home/campaigns`.
  factory CapsuleCollection.fromJson(JsonMap json) => CapsuleCollection(
        id: json.str('id'),
        tag: json.str('tag'),
        title: json.str('title'),
        subtitle: json.str('subtitle'),
        imageUrl: json.str('imageUrl'),
        ctaText: json.strOrNull('ctaText') ?? 'Shop now',
      );

  /// Serialises to the API JSON shape.
  JsonMap toJson() => {
        'id': id,
        'tag': tag,
        'title': title,
        'subtitle': subtitle,
        'imageUrl': imageUrl,
        'ctaText': ctaText,
      };
}
