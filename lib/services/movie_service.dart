import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/paths.dart';
import 'package:moviepedia/core/providers.dart';
import 'package:moviepedia/models/movie.dart';
import 'package:moviepedia/utils/enums.dart';

final movieServiceProvider = Provider((ref) {
  return MovieService(dio: ref.watch(dioProvider));
});

class MovieService {
  Dio? dio;

  MovieService({this.dio});

  Future<({List<Movie?>? result, String? error})> fetchMovie(
      MovieType movieType, WidgetRef ref) async {
    try {
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
      return (
        result: movies.map((e) => Movie.fromJson(e)).toList(),
        error: null
      );
    } on DioException catch (e) {
      return (result: null, error: e.message);
    }
  }

  Future<({List<Movie?>? result, String? error})> searchMovie(
      String? query) async {
    try {
      Response response = await dio!.get(Paths.searchUrl, queryParameters: {
        'query': query,
      });
      List<dynamic> movies = response.data['results'];
      log(movies.length.toString());
      return (
        result: movies.map((e) => Movie.fromJson(e)).toList(),
        error: null
      );
    } on DioException catch (e) {
      return (result: null, error: e.message!);
    }
  }
}
