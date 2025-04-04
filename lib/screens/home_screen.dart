import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/category.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Movie> featuredMovies = [
    Movie(
      id: 1,
      title: 'Featured Movie 1',
      imageUrl: 'assets/placeholder.jpg',
      rating: 4.5,
    ),
    Movie(
      id: 2,
      title: 'Featured Movie 2',
      imageUrl: 'assets/placeholder.jpg',
      rating: 4.2,
    ),
  ];

  final List<Category> categories = [
    Category(id: 1, name: 'Action'),
    Category(id: 2, name: 'Comedy'),
    Category(id: 3, name: 'Drama'),
    Category(id: 4, name: 'Sci-Fi'),
  ];

  final List<Movie> popularMovies = [
    Movie(
      id: 1,
      title: 'Movie 1',
      imageUrl: 'assets/placeholder.jpg',
      year: 2023,
      rating: 4.0,
    ),
    Movie(
      id: 2,
      title: 'Movie 2',
      imageUrl: 'assets/placeholder.jpg',
      year: 2023,
      rating: 3.8,
    ),
    Movie(
      id: 3,
      title: 'Movie 3',
      imageUrl: 'assets/placeholder.jpg',
      year: 2022,
      rating: 4.2,
    ),
    Movie(
      id: 4,
      title: 'Movie 4',
      imageUrl: 'assets/placeholder.jpg',
      year: 2021,
      rating: 3.5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar búsqueda
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Películas Destacadas'),
            _buildFeaturedMovies(),
            _buildSectionTitle('Categorías'),
            _buildCategoryList(),
            _buildSectionTitle('Películas Populares'),
            _buildMovieGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeaturedMovies() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredMovies.length,
        itemBuilder: (context, index) {
          final movie = featuredMovies[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/movie',
                arguments: {'movieId': movie.id},
              );
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: MovieCard(
                movie: movie,
                isFeatured: true,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FilterChip(
              label: Text(category.name),
              onSelected: (bool selected) {
                Navigator.pushNamed(
                  context,
                  '/category',
                  arguments: {'categoryId': category.id},
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: popularMovies.length,
      itemBuilder: (context, index) {
        final movie = popularMovies[index];
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
    );
  }
}