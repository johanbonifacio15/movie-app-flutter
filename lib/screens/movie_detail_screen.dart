import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final movieId = args['movieId'] as int;

    final movieData = Movie(
      id: movieId,
      title: 'Movie Title',
      imageUrl: 'assets/placeholder.jpg',
      year: 2023,
      rating: 4.5,
      duration: '2h 15m',
      genres: ['Action', 'Adventure'],
      description:
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      director: 'Director Name',
      cast: ['Actor 1', 'Actor 2', 'Actor 3'],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(movieData.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              // TODO: Implementar lógica de favoritos con backend
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'movie-${movieData.id}',
              child: Image.asset(
                movieData.imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, size: 100)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movieData.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (movieData.year != null)
                        Text(movieData.year.toString()),
                      if (movieData.rating != null) ...[
                        const SizedBox(width: 16),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(movieData.rating!.toStringAsFixed(1)),
                      ],
                      if (movieData.duration != null) ...[
                        const SizedBox(width: 16),
                        Text(movieData.duration!),
                      ],
                    ],
                  ),
                  if (movieData.genres != null && movieData.genres!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: movieData.genres!
                          .map((genre) => Chip(label: Text(genre)))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Text(
                    'Sinopsis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movieData.description!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  if (movieData.director != null) ...[
                    const Text(
                      'Director',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(movieData.director!),
                    const SizedBox(height: 16),
                  ],
                  if (movieData.cast != null && movieData.cast!.isNotEmpty) ...[
                    const Text(
                      'Reparto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(movieData.cast!.join(', ')),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/favorites');
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}