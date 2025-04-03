import '../constants/api_constants.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
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
    };
  }

  String get fullPosterUrl {
    return posterPath != null
        ? '${ApiConstants.imageBaseUrl}$posterPath'
        : 'https://via.placeholder.com/200x300?text=No+Poster';
  }
}
