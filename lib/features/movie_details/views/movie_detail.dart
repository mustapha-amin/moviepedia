import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviepedia/core/paths.dart';
import 'package:moviepedia/features/home/controllers/popular_movies.dart';
import 'package:moviepedia/features/home/controllers/top_rated_movies.dart';
import 'package:moviepedia/features/home/controllers/upcoming_movies.dart';
import 'package:moviepedia/features/movie_details/controller/cast_contoller.dart';
import 'package:moviepedia/features/movie_details/widgets/cast_widget.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/utils/enums.dart';
import 'package:moviepedia/utils/extensions.dart';
import 'package:moviepedia/utils/kTextStyle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:moviepedia/utils/shimmer_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetail extends ConsumerStatefulWidget {
  MovieResponse? movieResponse;
  MovieType? movieType;
  MovieDetail({this.movieResponse, this.movieType, super.key});

  @override
  ConsumerState<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends ConsumerState<MovieDetail> {
  late Movie movie;
  late List<Cast> casts;

  @override
  void initState() {
    super.initState();
    movie = widget.movieResponse!.movie!;
    casts = widget.movieResponse!.cast!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = ref.watch(switch (widget.movieType) {
        MovieType.popular => popularMoviesProvider,
        MovieType.topRated => topRatedMoviesProvider,
        _ => upcomingMoviesProvider
      });
      movieProvider.$1
              .firstWhere((element) => element.movie!.id == movie.id)
              .cast!
              .isEmpty
          ? ref.read(castProvider.notifier).updateCast(
              widget.movieResponse!.movie!.id, ref, widget.movieType!)
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: Paths.imagePathGen(
                      movie.backdropPath,
                    ),
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.2),
                    colorBlendMode: BlendMode.dstATop,
                    height: context.screenHeight * .5,
                    width: context.screenWidth,
                    placeholder: (context, _) {
                      return ShimmerImage(
                        height: context.screenHeight * .5,
                        width: context.screenWidth,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Hero(
                    tag: movie,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: Paths.imagePathGen(movie.backdropPath),
                        fit: BoxFit.cover,
                        width: context.screenWidth * .5,
                        height: context.screenHeight * .4,
                        placeholder: (context, _) {
                          return ShimmerImage(
                            height: context.screenHeight * .4,
                            width: context.screenWidth * .5,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 15,
                  child: IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.3),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Text(
                      movie.originalTitle,
                      style: kTextStyle(25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: kTextStyle(20),
                        ),
                        Text(
                          " (${movie.voteCount} votes)",
                          style: kTextStyle(18),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.star_border_outlined),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.bookmark_add_outlined),
                        ),
                      ],
                    )
                  ],
                ),
                Text(
                  'Release date: ${movie.releaseDate.formatJoinTime}',
                  style: kTextStyle(18, color: Colors.amber),
                ),
                const SizedBox(
                  height: 5,
                ),
                Consumer(
                  builder: (context, ref, _) {
                    final castController = ref.watch(castProvider);
                    return switch (castController.$2) {
                      Status.loading =>
                        const Center(child: CircularProgressIndicator()),
                      _ => SizedBox(
                          height: context.screenHeight * .3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                " Cast",
                                style: kTextStyle(
                                  40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    ...castController.$1.map(
                                      (cast) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: CastPreview(cast: cast),
                                      ),
                                    )
                                  ],
                                ).padX(2),
                              ),
                            ],
                          ),
                        )
                    };
                  },
                ),
                Text(
                  movie.overview,
                  style: kTextStyle(16),
                ),
              ],
            ).padX(10)
          ],
        ),
      ),
    );
  }
}
