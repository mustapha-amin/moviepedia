import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/typedefs.dart';
import 'package:moviepedia/features/home/controllers/popular_movies.dart';
import 'package:moviepedia/features/home/controllers/top_rated_movies.dart';
import 'package:moviepedia/features/home/controllers/upcoming_movies.dart';
import 'package:moviepedia/features/movie_details/controller/cast_state.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/services/movie_service.dart';
import 'package:moviepedia/utils/enums.dart';

final castProvider =
    StateNotifierProvider<CastNotifier, CastState>((ref) {
  return CastNotifier(
    movieService: ref.watch(movieServiceProvider),
  );
});

class CastNotifier extends StateNotifier<CastState> {
  MovieService? movieService;
  CastNotifier({this.movieService}) : super(CastState.initialState());

  void updateCast(int? id, WidgetRef ref, MovieType movieType) async {
    try {
      var castResponse = await movieService!.fetchCast(id);
      state = state.copyWith(cast: castResponse, isLoading: false);
      switch (movieType) {
        case MovieType.popular:
          ref.read(popularMoviesProvider.notifier).updateCast(id, state.cast!);
        case MovieType.topRated:
          ref.read(topRatedMoviesProvider.notifier).updateCast(id, state.cast!);
        default:
          ref.read(upcomingMoviesProvider.notifier).updateCast(id, state.cast!);
          break;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
