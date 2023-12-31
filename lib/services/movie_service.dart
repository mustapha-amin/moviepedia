import 'dart:convert';
import 'dart:developer';

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

  Future<List<Movie?>> fetchMovie(MovieType movieType, WidgetRef ref) async {
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

    List<dynamic> movies = response.data['results'];
    log(movies.length.toString());
    return movies.map((e) => Movie.fromJson(e)).toList();
  }
}
