import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';

class FirebaseService {
  static Future<void> initialize() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await Firebase.initializeApp();
    }
  }

  static Future<User?> signInAnonymously() async {
    if (!Platform.isAndroid && !Platform.isIOS) return null;

    try {
      final result = await FirebaseAuth.instance.signInAnonymously();
      return result.user;
    } catch (e) {
      debugPrint('Error en autenticación anónima: $e');
      return null;
    }
  }

  static Future<void> saveFavorite(Movie movie) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      debugPrint('Firestore no disponible en esta plataforma');
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(movie.id.toString())
            .set(movie.toJson());
      }
    } catch (e) {
      debugPrint('Error guardando favorito: $e');
    }
  }

  static Future<List<Movie>> getFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('favorites')
              .get();

      return snapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList();
    }
    return [];
  }
}
