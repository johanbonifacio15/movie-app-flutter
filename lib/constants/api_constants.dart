import '../secrets.dart';

class ApiConstants {
  static const String apiKey = tmdbApiKey;
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // Endpoints
  static const String popularMovies = '/movie/popular';
  static const String movieDetails = '/movie/{id}';
  static const String searchMovies = '/search/movie';
  static const String genres = '/genre/movie/list';

  // Parametros
  static const Map<String, String> defaultParams = {
    'api_key': apiKey,
    'language': 'es-ES',
  };
}
