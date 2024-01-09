import 'package:moviepedia/models/movie_response.dart';

class CastState {
  List<Cast>? cast;
  String? error;
  bool? isLoading;

  CastState({this.cast, this.error, this.isLoading});

  CastState copyWith({
    List<Cast>? cast,
    String? error,
    bool? isLoading,
  }) {
    return CastState(
      cast: cast ?? this.cast,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory CastState.initialState() {
    return CastState(
      cast: [],
      error: '',
      isLoading: true,
    );
  }
}