import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixlstream/models/movie.dart';
import 'package:pixlstream/services/movie_service.dart';
import 'package:pixlstream/utils/enums.dart';

import '../../../core/typedefs.dart';

final topRatedMoviesProvider = StateNotifierProvider<TopRatedMoviesNotifier, MovieState>((ref) {
  return TopRatedMoviesNotifier(
    movieService: ref.watch(movieServiceProvider),
  );
});

class TopRatedMoviesNotifier extends StateNotifier<MovieState> {
  MovieService? movieService;

  TopRatedMoviesNotifier({
    this.movieService,
  }) : super(([], MovieStatus.initial));

   Future<void> loadMovies(WidgetRef ref) async {
    state = (state.$1, MovieStatus.loading);
    try {
      List<Movie?> newMovies = await movieService!.fetchMovie(
        MovieType.topRated,
        ref,
      );
      log("new movies from provider: ${newMovies.length}");
      state = ([...state.$1, ...newMovies], MovieStatus.success);
    } catch (e) {
      state = ([], MovieStatus.failure);
    }
  }
}
