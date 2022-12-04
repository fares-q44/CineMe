class Movie {
  final bool adult;
  final int id;
  final String overview;
  final String poster;
  final String releaseDate;
  final String title;
  final String rate;
  final int rateCount;
  final List<dynamic> genres;
  bool isWatchlist = false;
  Movie({
    required this.adult,
    required this.id,
    required this.overview,
    required this.poster,
    required this.releaseDate,
    required this.title,
    required this.rate,
    required this.rateCount,
    required this.genres,
  });
}
