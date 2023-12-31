import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixlstream/models/movie.dart';
import 'package:pixlstream/services/movie_service.dart';
import 'package:pixlstream/utils/enums.dart';

import '../../../core/typedefs.dart';

final upcomingMoviesProvider =
    StateNotifierProvider<UpcomingMoviesNotifier, MovieState>((ref) {
  return UpcomingMoviesNotifier(
    movieService: ref.watch(movieServiceProvider),
  );
});

class UpcomingMoviesNotifier extends StateNotifier<MovieState> {
  MovieService? movieService;
  String? error;

  UpcomingMoviesNotifier({
    this.movieService,
  }) : super(([], MovieStatus.initial));

  void loadMovies(WidgetRef ref) async {
    state = (state.$1, MovieStatus.loading);
    try {
      List<Movie?> newMovies = await movieService!.fetchMovie(
        MovieType.upcoming,
        ref,
      );
      state = ([...state.$1, ...newMovies], MovieStatus.success);
    } catch (e) {
      state = ([], MovieStatus.failure);
    }
  }
}
