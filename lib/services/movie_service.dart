import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixlstream/core/paths.dart';
import 'package:pixlstream/core/providers.dart';
import 'package:pixlstream/models/movie.dart';
import 'package:pixlstream/utils/enums.dart';

final movieServiceProvider = Provider((ref) {
  return MovieService(dio: ref.watch(dioProvider));
});

class MovieService {
  Dio? dio;

  MovieService({this.dio});

  Future<List<Movie>?> fetchMovie(MovieType movieType, WidgetRef ref) async {
    Response response = await dio!.get(
      switch (movieType) {
        MovieType.upcoming => Paths.upcomingMovies,
        MovieType.topRated => Paths.topRatedMovies,
        _ => Paths.popularMovies,
      },
      queryParameters: {
        'page': switch (movieType) {
          MovieType.upcoming => ref.watch(upcomingPageProvider),
          MovieType.topRated => ref.watch(topratedPageProvider),
          _ => ref.watch(popularPageProvider),
        },
      },
    );
    Map<String, dynamic> data = response.data;
    List<dynamic> movies = data['results'];
    return movies.map((movie) => Movie.fromJson(movie)).toList();
  }
}
