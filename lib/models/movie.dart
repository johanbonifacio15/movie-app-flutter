import 'package:movie_app_flutter/constants/api_constants.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;
  final String? imageUrl;
  final int? year;
  final String? duration;
  final String? director;
  final List<String>? cast;
  final double? rating;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
    this.imageUrl,
    this.year,
    this.duration,
    this.director,
    this.cast,
    this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<int> parseGenres(dynamic genres) {
      if (genres == null) return [];
      if (genres is int) return [genres];
      if (genres is List) return List<int>.from(genres.whereType<int>());
      if (genres is String) {
        return genres.split(',').map(int.tryParse).whereType<int>().toList();
      }
      return [];
    }

    return Movie(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'No title',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] as String? ?? '',
      genreIds: parseGenres(json['genre_ids']),
      imageUrl: json['imageUrl'] as String?,
      year: json['year'] != null ? int.tryParse(json['year'].toString()) : null,
      duration: json['duration'] as String?,
      director: json['director'] as String?,
      cast: json['cast'] != null ? List<String>.from(json['cast']) : null,
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'imageUrl': imageUrl,
      'year': year,
      'duration': duration,
      'director': director,
      'cast': cast,
      'rating': rating,
    };
  }

  String get fullPosterUrl {
    return posterPath != null
        ? '${ApiConstants.imageBaseUrl}$posterPath'
        : imageUrl ?? 'https://via.placeholder.com/200x300?text=No+Poster';
  }
}
