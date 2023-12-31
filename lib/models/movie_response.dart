library movie_response;

import 'package:moviepedia/utils/extensions.dart';

part 'cast.dart';
part 'movie.dart';

class MovieResponse {
  Movie? movie;
  List<Cast>? cast;

  MovieResponse({this.movie, this.cast});

  MovieResponse updateCastList(List<Cast> newCast) {
    return MovieResponse(
      movie: movie,
      cast: newCast,
    );
  }
}
