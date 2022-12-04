// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cineme/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

class Search with ChangeNotifier {
  List<Movie> results = [];
  List<String> setGenres(List<dynamic> genres) {
    List<String> genresList = [];
    if (genres.contains(28)) {
      genresList.add('Action');
    }
    if (genres.contains(12)) {
      genresList.add('Adventure');
    }
    if (genres.contains(16)) {
      genresList.add('Animation');
    }
    if (genres.contains(35)) {
      genresList.add('Comedy');
    }
    if (genres.contains(80)) {
      genresList.add('Crime');
    }
    if (genres.contains(99)) {
      genresList.add('Documentry');
    }
    if (genres.contains(18)) {
      genresList.add('Drama');
    }
    if (genres.contains(10751)) {
      genresList.add('Family');
    }
    if (genres.contains(14)) {
      genresList.add('Fantasy');
    }
    if (genres.contains(36)) {
      genresList.add('History');
    }
    if (genres.contains(27)) {
      genresList.add('Horror');
    }
    if (genres.contains(10402)) {
      genresList.add('Music');
    }
    if (genres.contains(9648)) {
      genresList.add('Mystery');
    }
    if (genres.contains(10749)) {
      genresList.add('Romance');
    }
    if (genres.contains(878)) {
      genresList.add('Science Fiction');
    }
    if (genres.contains(10770)) {
      genresList.add('TV Movie');
    }
    if (genres.contains(53)) {
      genresList.add('Thriller');
    }
    if (genres.contains(10752)) {
      genresList.add('War');
    }
    if (genres.contains(37)) {
      genresList.add('Western');
    }
    return genresList;
  }

  Future<List> searchMovies(String searchKey) async {
    results = [];
    const String apiKey = '883cf14c854d2ecdabc055615306a25c';
    final url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=en-US&query=$searchKey&page=1&include_adult=false');
    final response = await http.get(url);
    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    var searchResult = decodedResponse['results'];
    searchResult.forEach(
      (element) {
        if (results.firstWhereOrNull(
                (resultItem) => resultItem.id == element['id']) !=
            null) {
          return;
        }
        if (element['poster_path'] == null) {
          return;
        }

        results.add(
          Movie(
            adult: element['adult'],
            id: element['id'],
            overview: element['overview'],
            poster:
                ('https://image.tmdb.org/t/p/w500') + element['poster_path'],
            releaseDate: element['release_date'],
            title: element['title'],
            rate: element['vote_average'].toString(),
            rateCount: element['vote_count'],
            genres: setGenres(
              element['genre_ids'],
            ),
          ),
        );
      },
    );
    notifyListeners();
    return results;
  }
}
