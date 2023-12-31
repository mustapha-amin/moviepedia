import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixlstream/models/movie.dart';
import 'package:pixlstream/services/movie_service.dart';
import 'package:pixlstream/utils/enums.dart';

import '../../../core/typedefs.dart';

final popularMoviesProvider = StateNotifierProvider<PopularMoviesNotifier, MovieState>((ref) {
  return PopularMoviesNotifier(
    movieService: ref.watch(movieServiceProvider),
  );
});

class PopularMoviesNotifier extends StateNotifier<MovieState> {
  MovieService? movieService;

  PopularMoviesNotifier({
    this.movieService,
  }) : super(([], MovieStatus.initial));

  Future<void> loadMovies(WidgetRef ref) async {
    state = (state.$1, MovieStatus.loading);
    try {
      List<Movie?> newMovies = await movieService!.fetchMovie(
        MovieType.popular,
        ref,
      );
      state = ([...state.$1, ...newMovies], MovieStatus.success);
    } catch (e) {
      state = ([], MovieStatus.failure);
    }
  }
}
