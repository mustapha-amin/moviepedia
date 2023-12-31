import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/providers.dart';
import 'package:moviepedia/models/movie.dart';
import 'package:moviepedia/services/movie_service.dart';
import 'package:moviepedia/utils/enums.dart';

import '../../../core/typedefs.dart';

final topRatedMoviesProvider =
    StateNotifierProvider<TopRatedMoviesNotifier, MovieState>((ref) {
  return TopRatedMoviesNotifier(
    movieService: ref.watch(movieServiceProvider),
  );
});

class TopRatedMoviesNotifier extends StateNotifier<MovieState> {
  MovieService? movieService;
  String? error;

  TopRatedMoviesNotifier({
    this.movieService,
  }) : super(([], MovieStatus.initial));

  Future<void> loadMovies(WidgetRef ref) async {
    final int prevState = ref.watch(topratedPageProvider);
    state = (state.$1, MovieStatus.loading);
    ref.read(topratedPageProvider.notifier).state++;
    var newMovies = await movieService!.fetchMovie(
      MovieType.topRated,
      ref,
    );
    if (newMovies.error == null) {
      state = ([...state.$1, ...newMovies.result!], MovieStatus.success);
      error = newMovies.error;
    } else {
      state = (state.$1, MovieStatus.failure);
      error = newMovies.error;
      ref.read(topratedPageProvider.notifier).state = prevState;
    }
  }
}
