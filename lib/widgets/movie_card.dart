import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../constants/api_constants.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isFeatured;
  final VoidCallback? onFavoritePressed;

  const MovieCard({
    super.key,
    required this.movie,
    this.isFeatured = false,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sección de la imagen
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: _buildMovieImage(),
            ),
          ),
          // Sección de información
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  movie.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isFeatured ? 16 : 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Año y rating
                if (movie.year != null || movie.rating != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (movie.year != null)
                          Text(
                            movie.year.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        if (movie.rating != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                movie.rating!.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Botón de favoritos (si está definido)
          if (onFavoritePressed != null)
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: onFavoritePressed,
              iconSize: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildMovieImage() {
    // Si tenemos un posterPath, intentamos cargar la imagen de la API
    if (movie.posterPath != null && movie.posterPath!.isNotEmpty) {
      return Image.network(
        '${ApiConstants.imageBaseUrl}${movie.posterPath}',
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    }
    // Si no hay posterPath, mostramos placeholder
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Image.network(
      'https://via.placeholder.com/200x300?text=No+Poster',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.broken_image, size: 50));
      },
    );
  }
}
