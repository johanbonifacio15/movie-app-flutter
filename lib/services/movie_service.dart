import '../models/movie.dart';
import '../models/api_response.dart';
import 'api_service.dart';
import '../constants/api_constants.dart';

class MovieService {
  final ApiService apiService;

  MovieService({required this.apiService});

  Future<ApiResponse<List<Movie>>> getPopularMovies() async {
    final response = await apiService.get(ApiConstants.popularMovies);

    if (!response.success) {
      return ApiResponse(error: response.error);
    }

    try {
      final movies =
          (response.data!['results'] as List)
              .map((json) => Movie.fromJson(json))
              .toList();

      return ApiResponse(data: movies);
    } catch (e) {
      return ApiResponse(error: 'Failed to parse movies');
    }
  }

  Future<ApiResponse<List<Movie>>> searchMovies(String query) async {
    final response = await apiService.get(
      ApiConstants.searchMovies,
      queryParams: {'query': query},
    );

    if (!response.success) {
      return ApiResponse(error: response.error);
    }

    final movies =
        (response.data['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();

    return ApiResponse(data: movies);
  }

  Future<ApiResponse<Movie>> getMovieDetails(int movieId) async {
    final response = await apiService.get(
      '${ApiConstants.movieDetails}/$movieId',
    );
    if (!response.success) return ApiResponse(error: response.error);

    try {
      final movie = Movie.fromJson(response.data!);
      return ApiResponse(data: movie);
    } catch (e) {
      return ApiResponse(error: 'Failed to parse movie details');
    }
  }

  Future<ApiResponse<List<Movie>>> getMoviesByCategory(int categoryId) async {
    final response = await apiService.get(
      ApiConstants.discoverMovies,
      queryParams: {'with_genres': categoryId.toString()},
    );

    if (!response.success) return ApiResponse(error: response.error);

    try {
      final movies =
          (response.data!['results'] as List)
              .map((json) => Movie.fromJson(json))
              .toList();
      return ApiResponse(data: movies);
    } catch (e) {
      return ApiResponse(error: 'Failed to parse movies by category');
    }
  }
}
