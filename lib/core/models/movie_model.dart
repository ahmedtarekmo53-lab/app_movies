import 'package:hive/hive.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class MovieModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String poster;
  @HiveField(3)
  final String bigPoster;
  @HiveField(4)
  final double rating;
  @HiveField(5)
  final int year;
  @HiveField(6)
  final String description;
  @HiveField(7)
  final List<String> genres;
  @HiveField(8)
  final int runtime;
  @HiveField(9)
  final String language;

  MovieModel({
    required this.id,
    required this.title,
    required this.poster,
    required this.bigPoster,
    required this.rating,
    required this.year,
    required this.description,
    required this.genres,
    required this.runtime,
    required this.language,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      poster: json['medium_cover_image'] ?? '',
      bigPoster: json['large_cover_image'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      year: json['year'] ?? 0,
      description: json['description_full'] ?? 'No description available.',
      genres: json['genres'] != null ? List<String>.from(json['genres']) : [],
      runtime: json['runtime'] ?? 0,
      language: json['language'] ?? 'en',
    );
  }
}
