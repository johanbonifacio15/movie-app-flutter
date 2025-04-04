import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../models/category.dart';
import '../widgets/movie_card.dart';
import '../services/movie_service.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> _movies = [];
  List<Movie> _featuredMovies = [];
  bool _isLoading = true;
  String? _error;

  final List<Category> categories = [
    Category(id: 1, name: 'Action'),
    Category(id: 2, name: 'Comedy'),
    Category(id: 3, name: 'Drama'),
    Category(id: 4, name: 'Sci-Fi'),
  ];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final movieService = Provider.of<MovieService>(context, listen: false);
    final response = await movieService.getPopularMovies();

    setState(() {
      _isLoading = false;
      if (response.success) {
        _movies = response.data!;
        _featuredMovies = response.data!.take(2).toList();
      } else {
        _error = response.error ?? 'Error desconocido';
      }
    });
  }

  Future<void> _saveFavorite(Movie movie) async {
    try {
      await FirebaseService.saveFavorite(movie);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película añadida a favoritos')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: ${e.toString()}')),
      );
    }
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
        itemCount: _featuredMovies.length,
        itemBuilder: (context, index) {
          final movie = _featuredMovies[index];
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
                onFavoritePressed: () => _saveFavorite(movie),
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
      itemCount: _movies.length,
      itemBuilder: (context, index) {
        final movie = _movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/movie',
              arguments: {'movieId': movie.id},
            );
          },
          child: MovieCard(
            movie: movie,
            onFavoritePressed: () => _saveFavorite(movie),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadMovies,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMovies,
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
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});
}
