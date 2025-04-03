import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> _movies = [];
  bool _isLoading = true;
  String? _error;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas Populares'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadMovies),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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

    return ListView.builder(
      itemCount: _movies.length,
      itemBuilder: (context, index) {
        final movie = _movies[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: Image.network(
              movie.fullPosterUrl,
              width: 50,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.movie, size: 50),
            ),
            title: Text(movie.title),
            subtitle: Text('⭐ ${movie.voteAverage.toStringAsFixed(1)}'),
            trailing: IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () => _saveFavorite(movie),
            ),
          ),
        );
      },
    );
  }
}
