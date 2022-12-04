import 'dart:convert';
import 'package:cineme/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class Movies with ChangeNotifier {
  List<Movie> popularMovieList = [];
  List<Movie> trendingMovieList = [];
  List<Movie> topRatedMovieList = [];
  List<Movie> upcomingMovieList = [];

  bool isFetching = false;
  int popularPage = 1;
  int trendingPage = 1;
  int topRatedPage = 1;
  int upcomingPage = 1;
  Future<void> fetchMovies() async {
    isFetching = true;
    notifyListeners();

    await Future.wait([
      fetchAndSetPopularMovies(),
      fetchAndSetTrendingMovies(),
      fetchAndSetUpcomingMovies(),
      fetchAndSettopRatedMovies(),
    ]);

    isFetching = false;
    notifyListeners();
  }

  Future<void> fetchAndSetPopularMovies() async {
    const apiKey = '883cf14c854d2ecdabc055615306a25c';
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=$popularPage&region=US');
    var response = await http.get(url);

    var decodedResponse = json.decode(response.body);
    var finalResponse = decodedResponse['results'] as List;
    for (var item in finalResponse) {
      var contain =
          popularMovieList.where((element) => element.id == item['id']);
      if (contain.isNotEmpty) {
        return;
      }
      popularMovieList.add(
        Movie(
          adult: item['adult'],
          id: item['id'],
          overview: item['overview'],
          poster: ('https://image.tmdb.org/t/p/w500') + item['poster_path'],
          releaseDate: item['release_date'],
          title: item['title'],
          rate: (item['vote_average'] as num).toStringAsFixed(2),
          rateCount: item['vote_count'],
          genres: setGenres(
            item['genre_ids'],
          ),
        ),
      );
    }

    notifyListeners();
    popularPage += 1;
  }

  Future<void> fetchAndSetTrendingMovies() async {
    const apiKey = '883cf14c854d2ecdabc055615306a25c';
    var url = Uri.parse(
        'https://api.themoviedb.org/3/trending/all/day?api_key=$apiKey&page=$trendingPage');
    var response = await http.get(url);

    var decodedResponse = json.decode(response.body);
    var finalResponse = decodedResponse['results'] as List;
    for (var item in finalResponse) {
      var contain =
          trendingMovieList.where((element) => element.id == item['id']);
      if (contain.isNotEmpty) {
        return;
      }

      if (item['release_date'] == null) {
        return;
      }
      trendingMovieList.add(
        Movie(
          adult: item['adult'],
          id: item['id'],
          overview: item['overview'],
          poster: ('https://image.tmdb.org/t/p/w500') + item['poster_path'],
          releaseDate: item['release_date'],
          title: item['title'],
          rate: (item['vote_average'] as num).toStringAsFixed(2),
          rateCount: item['vote_count'],
          genres: setGenres(
            item['genre_ids'],
          ),
        ),
      );
    }

    notifyListeners();
    trendingPage += 1;
  }

  Future<void> fetchAndSettopRatedMovies() async {
    const apiKey = '883cf14c854d2ecdabc055615306a25c';
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=en-US&page=$topRatedPage&region=US');
    var response = await http.get(url);

    var decodedResponse = json.decode(response.body);
    var finalResponse = decodedResponse['results'] as List;
    for (var item in finalResponse) {
      var contain =
          topRatedMovieList.where((element) => element.id == item['id']);
      if (contain.isNotEmpty) {
        return;
      }

      topRatedMovieList.add(
        Movie(
          adult: item['adult'],
          id: item['id'],
          overview: item['overview'],
          poster: ('https://image.tmdb.org/t/p/w500') + item['poster_path'],
          releaseDate: item['release_date'],
          title: item['title'],
          rate: (item['vote_average'] as num).toStringAsFixed(2),
          rateCount: item['vote_count'],
          genres: setGenres(
            item['genre_ids'],
          ),
        ),
      );
    }

    notifyListeners();
    topRatedPage += 1;
  }

  Future<void> fetchAndSetUpcomingMovies() async {
    const apiKey = '883cf14c854d2ecdabc055615306a25c';
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=en-US&page=$upcomingPage');
    var response = await http.get(url);

    var decodedResponse = json.decode(response.body);
    var finalResponse = decodedResponse['results'] as List;
    for (var item in finalResponse) {
      var contain =
          upcomingMovieList.where((element) => element.id == item['id']);
      if (contain.isNotEmpty) {
        return;
      }
      upcomingMovieList.add(
        Movie(
          adult: item['adult'],
          id: item['id'],
          overview: item['overview'],
          poster: ('https://image.tmdb.org/t/p/w500') + item['poster_path'],
          releaseDate: item['release_date'],
          title: item['title'],
          rate: (item['vote_average'] as num).toStringAsFixed(2),
          rateCount: item['vote_count'],
          genres: setGenres(
            item['genre_ids'],
          ),
        ),
      );
    }

    notifyListeners();
    upcomingPage += 1;
  }

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
}
