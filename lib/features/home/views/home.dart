import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/features/home/controllers/popular_movies.dart';
import 'package:moviepedia/features/home/views/view_all.dart.dart';
import 'package:moviepedia/features/home/widgets/movie_preview.dart';
import 'package:moviepedia/utils/extensions.dart';
import 'package:moviepedia/utils/kTextStyle.dart';
import 'package:moviepedia/utils/navigation.dart';

import '../../../utils/enums.dart';
import '../controllers/top_rated_movies.dart';
import '../controllers/upcoming_movies.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(popularMoviesProvider.notifier).loadMovies(ref);
      ref.read(upcomingMoviesProvider.notifier).loadMovies(ref);
      ref.read(topRatedMoviesProvider.notifier).loadMovies(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    var popularMovies = ref.watch(popularMoviesProvider);
    var upcomingMovies = ref.watch(upcomingMoviesProvider);
    var topRatedMovies = ref.watch(topRatedMoviesProvider);
    return ListView(
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Popular",
              style: kTextStyle(30),
            ),
            TextButton(
              onPressed: () {
                navigateTo(
                  context,
                  const AllMovies(
                    movieType: MovieType.popular,
                  ),
                );
              },
              child: Text(
                "View all",
                style: kTextStyle(16, color: Colors.amber),
              ),
            )
          ],
        ),
        switch (popularMovies) {
          ([], Status.initial) => const SizedBox(),
          ([], Status.loading) =>
            const Center(child: CircularProgressIndicator()),
          ([], Status.failure) => Center(
              child: Text(ref.watch(popularMoviesProvider.notifier).error!)),
          _ => SizedBox(
              height: context.screenHeight * .48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...popularMovies.$1.map(
                    (pmovie) => popularMovies.$1.indexOf(pmovie) < 11
                        ? MoviePreview(
                            movieResponse: pmovie, movieType: MovieType.popular)
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
        },
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upcoming",
              style: kTextStyle(30),
            ),
            TextButton(
              onPressed: () {
                navigateTo(
                  context,
                  const AllMovies(
                    movieType: MovieType.upcoming,
                  ),
                );
              },
              child: Text(
                "View all",
                style: kTextStyle(16, color: Colors.amber),
              ),
            )
          ],
        ),
        switch (upcomingMovies) {
          ([], Status.initial) => const SizedBox(),
          ([], Status.loading) =>
            const Center(child: CircularProgressIndicator()),
          ([], Status.failure) => Center(
              child: Text(ref.watch(upcomingMoviesProvider.notifier).error!)),
          _ => SizedBox(
              height: context.screenHeight * .48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...upcomingMovies.$1.map(
                    (umovie) => popularMovies.$1.indexOf(umovie) < 11
                        ? MoviePreview(
                            movieResponse: umovie,
                            movieType: MovieType.upcoming)
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
        },
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Top Rated",
              style: kTextStyle(30),
            ),
            TextButton(
              onPressed: () {
                navigateTo(
                  context,
                  const AllMovies(
                    movieType: MovieType.topRated,
                  ),
                );
              },
              child: Text(
                "View all",
                style: kTextStyle(16, color: Colors.amber),
              ),
            )
          ],
        ),
        switch (topRatedMovies) {
          ([], Status.initial) => const SizedBox(),
          ([], Status.loading) =>
            const Center(child: CircularProgressIndicator()),
          ([], Status.failure) => Center(
              child: Text(ref.watch(topRatedMoviesProvider.notifier).error!)),
          _ => SizedBox(
              height: context.screenHeight * .48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...topRatedMovies.$1.map(
                    (tmovie) => topRatedMovies.$1.indexOf(tmovie) < 11
                        ? MoviePreview(
                            movieResponse: tmovie,
                            movieType: MovieType.topRated)
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
        }
      ],
    ).padX(14);
  }
}
