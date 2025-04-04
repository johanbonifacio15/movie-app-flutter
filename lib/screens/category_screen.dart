import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

class CategoryScreen extends StatelessWidget {
  // Constructor ya no es const porque tenemos campos no constantes
  CategoryScreen({super.key});

  // Datos de ejemplo como campos finales (no const)
  final String categoryName = 'Categoría nombre';

  final List<Movie> movies = [
    Movie(
      id: 1,
      title: 'Película 1',
      imageUrl: 'assets/placeholder.jpg',
      year: 2023,
      rating: 4.0,
    ),
    Movie(
      id: 2,
      title: 'Película 2',
      imageUrl: 'assets/placeholder.jpg',
      year: 2023,
      rating: 3.8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final categoryId = args['categoryId'] as int;

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/movie',
                arguments: {'movieId': movie.id},
              );
            },
            child: MovieCard(movie: movie),
          );
        },
      ),
    );
  }
}