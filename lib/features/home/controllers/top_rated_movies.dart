import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/providers.dart';
import 'package:moviepedia/services/movie_service.dart';
import 'package:moviepedia/utils/enums.dart';

import '../../../core/typedefs.dart';
import '../../../models/movie_response.dart';

final topRatedMoviesProvider =
    StateNotifierProvider<TopRatedMoviesNotifier, ResponseState<MovieResponse>>((ref) {
  return TopRatedMoviesNotifier(
    movieService: ref.watch(movieServiceProvider),
  );
});

class TopRatedMoviesNotifier extends StateNotifier<ResponseState<MovieResponse>> {
  MovieService? movieService;

  TopRatedMoviesNotifier({
    this.movieService,
  }) : super(([], Status.initial, null));

  Future<void> loadMovies(WidgetRef ref) async {
    final int prevState = ref.watch(topratedPageProvider);
    state = (state.$1, Status.loading, null);
    ref.read(topratedPageProvider.notifier).state++;
    var newMovies = await movieService!.fetchMovie(
      MovieType.topRated,
      ref,
    );
    if (newMovies.error == null) {
      state = (
        [
          ...state.$1,
          ...newMovies.movie!.map((e) => MovieResponse(movie: e, cast: []))
        ],
        Status.success,
        null,
      );
    } else {
      state = (state.$1, Status.failure, newMovies.error);
      ref.read(topratedPageProvider.notifier).state = prevState;
    }
  }

  void updateCast(int? id, List<Cast> cast) {
    List<MovieResponse> movieResponseList = state.$1;
    MovieResponse movieResponse =
        state.$1.firstWhere((movie) => movie.movie!.id == id);
    int index = movieResponseList.indexOf(movieResponse);
    movieResponse = movieResponse.updateCastList(cast);
    movieResponseList[index] = movieResponse;
    state = (movieResponseList, Status.success, null);
  }
}
