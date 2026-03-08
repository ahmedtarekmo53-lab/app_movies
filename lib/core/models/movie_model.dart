class MovieModel {
  final int id;
  final String title;
  final String poster;
  final String bigPoster;
  final double rating;
  final int year;
  final String description;
  final List<String> genres;
  final int runtime;
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
