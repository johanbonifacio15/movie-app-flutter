import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  static Future<User?> signInAnonymously() async {
    try {
      final result = await FirebaseAuth.instance.signInAnonymously();
      return result.user;
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveFavorite(Movie movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(movie.id.toString())
          .set(movie.toJson());
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
