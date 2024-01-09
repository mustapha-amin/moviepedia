import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/providers.dart';
import 'package:moviepedia/features/home/controllers/movie_state.dart';
import 'package:moviepedia/services/movie_service.dart';
import 'package:moviepedia/utils/enums.dart';
import '../../../models/movie_response.dart';

final popularMoviesProvider =
    StateNotifierProvider<PopularMoviesNotifier, MovieState>((ref) {
  return PopularMoviesNotifier(
    movieService: ref.watch(movieServiceProvider),
  );
});

class PopularMoviesNotifier extends StateNotifier<MovieState> {
  MovieService? movieService;

  PopularMoviesNotifier({
    this.movieService,
  }) : super(MovieState.initialState());

  Future<void> loadMovies(WidgetRef ref) async {
    final int prevState = ref.watch(popularPageProvider);
    ref.read(popularPageProvider.notifier).state++;
    try {
      var newMovies = await movieService!.fetchMovies(
        MovieType.popular,
        ref,
      );
      List<MovieResponse> movies = newMovies
          .map((e) => MovieResponse(
                movie: e,
                cast: [],
              ))
          .toList();
      state = state.copyWith(
        movieResponse: [...state.movieResponse!, ...movies],
        isLoading: false,
      );
    } catch (e, _) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      ref.read(popularPageProvider.notifier).state = prevState;
    }
  }

  void updateCast(int? id, List<Cast> cast) {
    List<MovieResponse> movieResponseList = state.movieResponse!;
    MovieResponse movieResponse =
        state.movieResponse!.firstWhere((movie) => movie.movie!.id == id);
    int index = movieResponseList.indexOf(movieResponse);
    movieResponse = movieResponse.updateCastList(cast);
    movieResponseList[index] = movieResponse;
    state = state.copyWith(movieResponse: movieResponseList);
  }
}
