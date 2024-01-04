import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/providers.dart';
import 'package:moviepedia/models/movie.dart';
import 'package:moviepedia/services/movie_service.dart';
import 'package:moviepedia/utils/enums.dart';

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
    final int prevState = ref.watch(upcomingPageProvider);
    ref.read(upcomingPageProvider.notifier).state++;
    state = (state.$1, MovieStatus.loading);
    var newMovies = await movieService!.fetchMovie(
      MovieType.upcoming,
      ref,
    );
    if (newMovies.error == null) {
      error = newMovies.error;
      state = ([...state.$1, ...newMovies.result!], MovieStatus.success);
    } else {
      error = newMovies.error;
      state = (state.$1, MovieStatus.failure);
      ref.read(upcomingPageProvider.notifier).state = prevState;
    }
  }
}
