import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/exceptions.dart';
import 'package:moviepedia/core/paths.dart';
import 'package:moviepedia/core/providers.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/utils/enums.dart';

final movieServiceProvider = Provider((ref) {
  return MovieService(dio: ref.watch(dioProvider));
});

class MovieService {
  Dio? dio;

  MovieService({this.dio});

  Future<List<Movie>> fetchMovies(
    MovieType movieType,
    WidgetRef ref,
  ) async {
    String path = switch (movieType) {
      MovieType.upcoming => Paths.upcomingMovies,
      MovieType.topRated => Paths.topRatedMovies,
      _ => Paths.popularMovies,
    };
    try {
      Response moviesResponse = await dio!.get(
        path,
        queryParameters: {
          'page': switch (movieType) {
            MovieType.upcoming => ref.watch(upcomingPageProvider),
            MovieType.topRated => ref.watch(topratedPageProvider),
            _ => ref.watch(popularPageProvider),
          },
        },
      );

      //* movies
      List<dynamic> results = moviesResponse.data['results'];
      List<Movie> movies = results.map((e) => Movie.fromJson(e)).toList();
      return movies;
    } on DioException catch (e) {
     switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw const ConnectionTimeoutException();
        case DioExceptionType.connectionError:
          throw const NoInternetConnectionException();
        default:
          throw const DefaultException();
      }
    }
  }

  Future<List<Cast>?> fetchCast(int? id) async {
    try {
      log(id.toString());
      Response response = await dio!.get('/$id/credits');
      List<dynamic> results = response.data['cast'];
      return results.map((e) => Cast.fromJson(e)).toList();
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw const ConnectionTimeoutException();
        case DioExceptionType.connectionError:
          throw const NoInternetConnectionException();
        default:
          throw const DefaultException();
      }
    }
  }

  Future<List<Movie?>> searchMovie(
    String? query,
  ) async {
    try {
      Response response = await dio!.get(Paths.searchUrl, queryParameters: {
        'query': query,
      });
      List<dynamic> movies = response.data['results'];
      log(movies.length.toString());
      return movies.map((e) => Movie.fromJson(e)).toList();
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw const ConnectionTimeoutException();
        case DioExceptionType.connectionError:
          throw const NoInternetConnectionException();
        default:
          throw const DefaultException();
      }
    }
  }
}
