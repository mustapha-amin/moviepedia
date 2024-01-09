import 'package:moviepedia/models/movie_response.dart';

class MovieState {
  List<MovieResponse>? movieResponse;
  String? error;
  bool? isLoading;

  MovieState({this.movieResponse, this.error, this.isLoading});

  MovieState copyWith({
    List<MovieResponse>? movieResponse,
    String? error,
    bool? isLoading,
  }) {
    return MovieState(
      movieResponse: movieResponse ?? this.movieResponse,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory MovieState.initialState() {
    return MovieState(
      movieResponse: [],
      error: '',
      isLoading: true,
    );
  }
}
