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

  Future<void> refreshProviders() async {
    ref.invalidate(popularMoviesProvider);
    ref.invalidate(upcomingMoviesProvider);
    ref.invalidate(topRatedMoviesProvider);
    ref.read(popularMoviesProvider.notifier).loadMovies(ref);
    ref.read(upcomingMoviesProvider.notifier).loadMovies(ref);
    ref.read(topRatedMoviesProvider.notifier).loadMovies(ref);
  }

  @override
  Widget build(BuildContext context) {
    var popularMovies = ref.watch(popularMoviesProvider);
    var upcomingMovies = ref.watch(upcomingMoviesProvider);
    var topratedMovies = ref.watch(topRatedMoviesProvider);
    bool errorsAreSame = popularMovies.error == upcomingMovies.error &&
        upcomingMovies.error == topratedMovies.error;
    bool errorsExist = popularMovies.error!.isNotEmpty &&
        upcomingMovies.error!.isNotEmpty &&
        topratedMovies.error!.isNotEmpty;

    return RefreshIndicator(
      onRefresh: refreshProviders,
      child: switch (errorsExist && errorsAreSame) {
        true => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                popularMovies.error!,
                style: kTextStyle(20),
              ),
              TextButton.icon(
                onPressed: refreshProviders,
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.amber,
                ),
                label: Text(
                  "Retry",
                  style: kTextStyle(15, color: Colors.amber),
                ),
              )
            ],
          ).padX(10),
        _ => ListView(
            children: [
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular",
                        style: kTextStyle(28, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          topratedMovies.isLoading! ||
                                  topratedMovies.error!.isNotEmpty
                              ? null
                              : navigateTo(
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
                  switch (popularMovies.isLoading) {
                    true => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    _ => popularMovies.error!.isEmpty
                        ? SizedBox(
                            height: context.screenHeight * .33,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ...popularMovies.movieResponse!.map(
                                  (tmovie) => popularMovies.movieResponse!
                                              .indexOf(tmovie) <
                                          11
                                      ? MoviePreview(
                                          movieResponse: tmovie,
                                          movieType: MovieType.popular,
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Text(popularMovies.error!),
                          )
                  },
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Upcoming",
                        style: kTextStyle(28, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          upcomingMovies.isLoading! ||
                                  upcomingMovies.error!.isNotEmpty
                              ? null
                              : navigateTo(
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
                  switch (upcomingMovies.isLoading) {
                    true => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    _ => upcomingMovies.error!.isEmpty
                        ? SizedBox(
                            height: context.screenHeight * .33,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ...upcomingMovies.movieResponse!.map(
                                  (tmovie) => topratedMovies.movieResponse!
                                              .indexOf(tmovie) <
                                          11
                                      ? MoviePreview(
                                          movieResponse: tmovie,
                                          movieType: MovieType.popular,
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Text(upcomingMovies.error!),
                          )
                  },
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Top Rated",
                        style: kTextStyle(28, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          topratedMovies.isLoading! ||
                                  topratedMovies.error!.isNotEmpty
                              ? null
                              : navigateTo(
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
                  switch (topratedMovies.isLoading) {
                    true => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    _ => topratedMovies.error!.isEmpty
                        ? SizedBox(
                            height: context.screenHeight * .3,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ...topratedMovies.movieResponse!.map(
                                  (tmovie) => topratedMovies.movieResponse!
                                              .indexOf(tmovie) <
                                          11
                                      ? MoviePreview(
                                          movieResponse: tmovie,
                                          movieType: MovieType.popular,
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Text(topratedMovies.error!),
                          )
                  }
                ],
              ).padX(14)
            ],
          )
      },
    );
  }
}
