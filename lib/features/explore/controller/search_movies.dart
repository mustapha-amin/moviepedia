import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/services/movie_service.dart';

final searchMoviesProvider =
    FutureProvider.family<({List<Movie?>? result, String? error}), String>(
        (ref, query) async {
  final movieService = ref.watch(movieServiceProvider);
  return movieService.searchMovie(query);
});
