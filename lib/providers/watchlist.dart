import 'package:cineme/models/movie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:collection/collection.dart';

class Watchlist with ChangeNotifier {
  List<Movie> watchlistMovies = [];
  bool isFetching = false;

  Future<void> toggleWatchlist(Movie movie) async {
    final user = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    if (movie.isWatchlist) {
      watchlistMovies.add(movie);
      notifyListeners();
      db.collection('watchlist').doc(user!.uid).collection('id').add(
        {
          'id': movie.id,
          'adult': movie.adult,
          'overview': movie.overview,
          'poster': movie.poster,
          'title': movie.title,
          'releasedate': movie.releaseDate,
          'rate': movie.rate,
          'ratecount': movie.rateCount,
          'iswatchlist': movie.isWatchlist,
          'genres': movie.genres
        },
      );
    } else {
      // delete
      watchlistMovies.removeWhere((element) => element.id == movie.id);
      notifyListeners();
      FirebaseFirestore.instance
          .collection("watchlist")
          .doc(user!.uid)
          .collection('id')
          .where("id", isEqualTo: movie.id)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection("watchlist")
              .doc(user.uid)
              .collection('id')
              .doc(element.id)
              .delete()
              .then((value) {});
        });
      });
    }
  }

  Future<void> fetchAndSetWatchlist() async {
    isFetching = true;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    final response = FirebaseFirestore.instance
        .collection('watchlist')
        .doc(user!.uid)
        .collection('id');
    QuerySnapshot querySnapshot = await response.get();
    final _docData = querySnapshot.docs.map((doc) => doc.data()).toList();
    var movie;
    _docData.forEach(
      (element) {
        final Map<String, dynamic> i = element as Map<String, dynamic>;
        movie = Movie(
          adult: element['adult'],
          id: element['id'],
          overview: element['overview'],
          poster: element['poster'],
          releaseDate: element['releasedate'],
          title: element['title'],
          rate: element['rate'],
          rateCount: element['ratecount'],
          genres: element['genres'],
        );
        if (watchlistMovies
                .indexWhere((movieItem) => movieItem.id == element['id']) ==
            -1) {
          watchlistMovies.add(movie);
        } else {
          return;
        }
      },
    );
    isFetching = false;
    notifyListeners();
  }

  bool isInWatch(int id) {
    if (watchlistMovies.firstWhereOrNull((element) => element.id == id) ==
        null) {
      return false;
    } else {
      return true;
    }
  }
}
