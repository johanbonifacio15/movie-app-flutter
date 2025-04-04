class Movie {
  final int id;
  final String title;
  final String imageUrl;
  final int? year;
  final double? rating;
  final String? duration;
  final List<String>? genres;
  final String? description;
  final String? director;
  final List<String>? cast;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.year,
    this.rating,
    this.duration,
    this.genres,
    this.description,
    this.director,
    this.cast,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      year: json['year'] as int?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      duration: json['duration'] as String?,
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
      description: json['description'] as String?,
      director: json['director'] as String?,
      cast: json['cast'] != null ? List<String>.from(json['cast']) : null,
    );
  }
}