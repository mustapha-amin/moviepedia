import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/providers.dart';
import 'package:moviepedia/models/movie.dart';
import 'package:moviepedia/services/movie_service.dart';
import 'package:moviepedia/utils/enums.dart';

import '../../../core/typedefs.dart';

final popularMoviesProvider =
    StateNotifierProvider<PopularMoviesNotifier, MovieState>((ref) {
  return PopularMoviesNotifier(
    movieService: ref.watch(movieServiceProvider),
  );
});

class PopularMoviesNotifier extends StateNotifier<MovieState> {
  MovieService? movieService;
  String? error;

  PopularMoviesNotifier({
    this.movieService,
  }) : super(([], MovieStatus.initial));

  Future<void> loadMovies(WidgetRef ref) async {
    final int prevState = ref.watch(popularPageProvider);
    ref.read(popularPageProvider.notifier).state++;
    state = (state.$1, MovieStatus.loading);
    var newMovies = await movieService!.fetchMovie(
      MovieType.popular,
      ref,
    );
    if (newMovies.error == null) {
      state = ([...state.$1, ...newMovies.result!], MovieStatus.success);
      error = newMovies.error;
    } else {
      state = (state.$1, MovieStatus.failure);
      error = newMovies.error;
      ref.read(popularPageProvider.notifier).state = prevState;
    }
  }
}
