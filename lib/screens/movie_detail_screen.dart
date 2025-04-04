import 'package:flutter/material.dart';
import 'package:movie_app_flutter/services/firebase_service.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId; // Cambio importante: recibir movieId como parámetro

  const MovieDetailScreen({
    super.key,
    required this.movieId, // Requerimos el movieId
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Movie movie;
  bool isLoading = true;
  String? error;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
    _checkIfFavorite();
  }

  Future<void> _loadMovieDetails() async {
    final movieService = Provider.of<MovieService>(context, listen: false);

    try {
      final response = await movieService.getMovieDetails(
        widget.movieId,
      ); // Usamos widget.movieId
      if (response.success) {
        setState(() {
          movie = response.data!;
          isLoading = false;
        });
      } else {
        setState(() {
          error = response.error ?? 'Error al cargar detalles';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error de conexión: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _checkIfFavorite() async {
    try {
      final favorites = await FirebaseService.getFavorites();
      setState(() {
        isFavorite = favorites.any(
          (m) => m.id == widget.movieId,
        ); // Usamos widget.movieId
      });
    } catch (e) {
      debugPrint('Error verificando favoritos: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      if (isFavorite) {
        await FirebaseService.removeFavorite(movie);
      } else {
        await FirebaseService.saveFavorite(movie);
      }
      setState(() {
        isFavorite = !isFavorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite ? 'Añadido a favoritos' : 'Eliminado de favoritos',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error!),
              ElevatedButton(
                onPressed: _loadMovieDetails,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'movie-${movie.id}',
              child: Image.network(
                movie.fullPosterUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 100),
                      ),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (movie.releaseDate.isNotEmpty)
                        Text(movie.releaseDate.substring(0, 4)),
                      if (movie.voteAverage > 0) ...[
                        const SizedBox(width: 16),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(movie.voteAverage.toStringAsFixed(1)),
                      ],
                    ],
                  ),
                  if (movie.genreIds.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          movie.genreIds
                              .map(
                                (genreId) =>
                                    Chip(label: Text('Género $genreId')),
                              )
                              .toList(),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Text(
                    'Sinopsis',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(movie.overview, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
