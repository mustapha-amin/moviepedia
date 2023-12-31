import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/paths.dart';
import 'package:moviepedia/features/home/controllers/popular_movies.dart';
import 'package:moviepedia/features/home/controllers/top_rated_movies.dart';
import 'package:moviepedia/features/home/controllers/upcoming_movies.dart';
import 'package:moviepedia/features/home/views/movie_detail.dart';
import 'package:moviepedia/features/home/widgets/grid_movie_preview.dart';
import 'package:moviepedia/features/home/widgets/movie_preview.dart';
import 'package:moviepedia/models/movie.dart';
import 'package:moviepedia/utils/enums.dart';
import 'package:moviepedia/utils/extensions.dart';
import 'package:moviepedia/utils/kTextStyle.dart';
import 'package:moviepedia/utils/navigation.dart';

class AllMovies extends ConsumerStatefulWidget {
  MovieType? movieType;
  AllMovies({this.movieType, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllMoviesState();
}

class _AllMoviesState extends ConsumerState<AllMovies> {
  List<Movie?>? movies;

  @override
  Widget build(BuildContext context) {
    movies = switch (widget.movieType) {
      MovieType.upcoming => ref.watch(upcomingMoviesProvider),
      MovieType.popular => ref.watch(popularMoviesProvider),
      _ => ref.watch(topRatedMoviesProvider)
    }
        .$1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movieType!.name.title,
          style: kTextStyle(30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 2,
        ),
        children: [
          ...movies!.map(
            (movie) => SizedBox(
              width: context.screenWidth * .45,
              child: InkWell(
                onTap: () {
                  navigateTo(context, MovieDetail(movie: movie));
                },
                child: GridMoviePreview(movie: movie!),
              ),
            ),
          )
        ],
      ),
    );
  }
}
