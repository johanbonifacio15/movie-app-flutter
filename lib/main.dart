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

  // Inicialización condicional de Firebase
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
        '/movie': (context) => const MovieDetailScreen(),
        '/category': (context) => const CategoryScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}