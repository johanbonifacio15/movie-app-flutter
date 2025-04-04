import 'package:flutter/material.dart';
import '../models/movie.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final List<Movie> favoriteMovies = [
    Movie(
      id: 1,
      title: 'Película Favorita 1',
      imageUrl: 'assets/placeholder.jpg',
      year: 2023,
      rating: 4.8,
    ),
    Movie(
      id: 2,
      title: 'Película Favorita 2',
      imageUrl: 'assets/placeholder.jpg',
      year: 2022,
      rating: 4.5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Películas Favoritas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar búsqueda en favoritos
            },
          ),
        ],
      ),
      body: favoriteMovies.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 50, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Aún no tienes películas favoritas',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = favoriteMovies[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  movie.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50),
                ),
              ),
              title: Text(
                movie.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Año: ${movie.year}'),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(movie.rating.toString()),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  // TODO: Implementar eliminación de favoritos
                  // Backend: Llamar API para remover de favoritos
                },
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/movie',
                  arguments: {'movieId': movie.id},
                );
              },
            ),
          );
        },
      ),
    );
  }
}