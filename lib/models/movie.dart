part of movie_response;

class Movie {
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;

  Movie({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"] ?? '',
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"] ?? '',
        originalLanguage: json["original_language"] ?? '',
        originalTitle: json["original_title"] ?? '',
        overview: json["overview"] ?? '',
        popularity: json["popularity"]?.toDouble() ?? 0,
        posterPath: json["poster_path"] ?? '',
        releaseDate: json["release_date"] == ""
            ? "unknown date"
            : DateTime.tryParse(json["release_date"])!.formatJoinTime,
        title: json["title"] ?? '',
        video: json["video"] ?? '',
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );
}
