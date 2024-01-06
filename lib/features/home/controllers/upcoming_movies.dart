import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/providers.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/services/movie_service.dart';
import 'package:moviepedia/utils/enums.dart';

import '../../../core/typedefs.dart';

final upcomingMoviesProvider =
    StateNotifierProvider<UpcomingMoviesNotifier, ResponseState<MovieResponse>>((ref) {
  return UpcomingMoviesNotifier(
    movieService: ref.watch(movieServiceProvider),
  );
});

class UpcomingMoviesNotifier extends StateNotifier<ResponseState<MovieResponse>> {
  MovieService? movieService;

  UpcomingMoviesNotifier({
    this.movieService,
  }) : super(([], Status.initial, null));

  void loadMovies(WidgetRef ref) async {
    final int prevState = ref.watch(upcomingPageProvider);
    ref.read(upcomingPageProvider.notifier).state++;
    state = (state.$1, Status.loading, null);
    var newMovies = await movieService!.fetchMovie(
      MovieType.upcoming,
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
      ref.read(upcomingPageProvider.notifier).state = prevState;
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
