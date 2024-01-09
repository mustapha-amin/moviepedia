import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/services/movie_service.dart';

final searchMoviesProvider =
    FutureProvider.family<List<Movie?>?, String>(
        (ref, query) async {
  final movieService = ref.watch(movieServiceProvider);
  return movieService.searchMovie(query);
});

final fetchMovieCastProvider =
    FutureProvider.family<List<Cast>?, int>((ref, id) async {
  final movieService = ref.watch(movieServiceProvider);
  return movieService.fetchCast(id);
});
