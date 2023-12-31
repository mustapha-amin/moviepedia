import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/providers.dart';
import 'package:moviepedia/features/home/controllers/popular_movies.dart';
import 'package:moviepedia/features/home/controllers/top_rated_movies.dart';
import 'package:moviepedia/features/home/controllers/upcoming_movies.dart';
import 'package:moviepedia/features/home/views/movie_detail.dart';
import 'package:moviepedia/features/home/widgets/grid_movie_preview.dart';
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
  final ScrollController scrollController = ScrollController();
  bool isEnd = false;

  Future<void> loadMoreMovies(WidgetRef ref) async {
    if (widget.movieType == MovieType.popular) {
      ref.read(popularMoviesProvider.notifier).loadMovies(ref);
    } else if (widget.movieType == MovieType.topRated) {
      ref.read(topRatedMoviesProvider.notifier).loadMovies(ref);
    } else {
      ref.read(upcomingMoviesProvider.notifier).loadMovies(ref);
    }
    scrollController.position.animateTo(
      scrollController.offset + 100,
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        if (scrollController.offset ==
            scrollController.position.maxScrollExtent) {
          setState(() {
            isEnd = true;
          });
          loadMoreMovies(ref);
        } else {
          setState(() {
            isEnd = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var movies = switch (widget.movieType) {
      MovieType.upcoming => ref.watch(upcomingMoviesProvider),
      MovieType.popular => ref.watch(popularMoviesProvider),
      _ => ref.watch(topRatedMoviesProvider)
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movieType!.name.title,
          style: kTextStyle(30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: !isEnd ? context.screenHeight : context.screenHeight * .8,
              child: GridView(
                controller: scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 2,
                ),
                children: [
                  ...movies.$1.map(
                    (movie) => SizedBox(
                      width: context.screenWidth * .45,
                      child: InkWell(
                        onTap: () {
                          navigateTo(context, MovieDetail(movie: movie));
                        },
                        child: GridMoviePreview(movie: movie!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isEnd && movies.$2 == MovieStatus.loading
                ? const Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ).padAll(5)
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
