import 'dart:developer';

class Paths {
  static const baseUrl = 'https://api.themoviedb.org/3/movie';
  static const popularMovies = '/popular';
  static const upcomingMovies = '/upcoming';
  static const topRatedMovies = '/top_rated';

  static String imagePathGen(String? movieId) {
    return "https://image.tmdb.org/t/p/original/$movieId";
  }
}
