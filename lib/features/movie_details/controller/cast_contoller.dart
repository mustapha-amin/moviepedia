import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/typedefs.dart';
import 'package:moviepedia/features/home/controllers/popular_movies.dart';
import 'package:moviepedia/features/home/controllers/top_rated_movies.dart';
import 'package:moviepedia/features/home/controllers/upcoming_movies.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/services/movie_service.dart';
import 'package:moviepedia/utils/enums.dart';

final castProvider =
    StateNotifierProvider<CastNotifier, ResponseState<Cast>>((ref) {
  return CastNotifier(
    movieService: ref.watch(movieServiceProvider),
  );
});

class CastNotifier extends StateNotifier<ResponseState<Cast>> {
  MovieService? movieService;
  CastNotifier({this.movieService}) : super(([], Status.initial));

  void updateCast(int? id, WidgetRef ref, MovieType movieType) async {
    try {
      state = ([], Status.loading);

      var castResponse = await movieService!.fetchCast(id);
      state = (castResponse.cast!, Status.success);
      switch (movieType) {
        case MovieType.popular:
          ref.read(popularMoviesProvider.notifier).updateCast(id, state.$1);
        case MovieType.topRated:
          ref.read(topRatedMoviesProvider.notifier).updateCast(id, state.$1);
        default:
          ref.read(upcomingMoviesProvider.notifier).updateCast(id, state.$1);
          break;
      }
    } catch (e) {
      state = ([], Status.failure);
    }
  }
}
