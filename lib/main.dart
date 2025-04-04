import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/category_screen.dart';
import 'screens/favorites_screen.dart';
import 'services/api_service.dart';
import 'services/movie_service.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp();
    await FirebaseService.signInAnonymously();
  }

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiService(client: http.Client())),
        Provider(
          create: (ctx) => MovieService(apiService: ctx.read<ApiService>()),
        ),
      ],
      child: const MovieCatalogApp(),
    ),
  );
}

class MovieCatalogApp extends StatelessWidget {
  const MovieCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Catalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/movie') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          if (args['movieId'] == null) {
            return _buildErrorRoute('Falta el ID de la película');
          }
          return MaterialPageRoute(
            builder:
                (context) => MovieDetailScreen(movieId: args['movieId'] as int),
          );
        }

        if (settings.name == '/category') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          if (args['categoryId'] == null) {
            return _buildErrorRoute('Falta el ID de categoría');
          }
          if (args['categoryName'] == null) {
            return _buildErrorRoute('Falta el nombre de categoría');
          }
          return MaterialPageRoute(
            builder:
                (context) => CategoryScreen(
                  categoryId: args['categoryId'] as int,
                  categoryName: args['categoryName'] as String,
                ),
          );
        }

        return null;
      },
    );
  }

  MaterialPageRoute _buildErrorRoute(String message) {
    return MaterialPageRoute(
      builder:
          (context) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    'Error de navegación',
                    style: TextStyle(fontSize: 20, color: Colors.red[700]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
