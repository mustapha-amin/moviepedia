import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/features/home/controllers/popular_movies.dart';
import 'package:moviepedia/features/home/controllers/top_rated_movies.dart';
import 'package:moviepedia/features/home/controllers/upcoming_movies.dart';
import 'package:moviepedia/features/movie_details/views/movie_detail.dart';
import 'package:moviepedia/features/home/widgets/grid_movie_preview.dart';
import 'package:moviepedia/utils/enums.dart';
import 'package:moviepedia/utils/extensions.dart';
import 'package:moviepedia/utils/kTextStyle.dart';
import 'package:moviepedia/utils/navigation.dart';

class AllMovies extends ConsumerStatefulWidget {
  final MovieType? movieType;
  const AllMovies({Key? key, this.movieType}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllMoviesState();
}

class _AllMoviesState extends ConsumerState<AllMovies> {
  final ScrollController scrollController = ScrollController();

  Future<void> loadMoreMovies(WidgetRef ref) async {
    if (widget.movieType == MovieType.popular) {
      ref.read(popularMoviesProvider.notifier).loadMovies(ref);
    } else if (widget.movieType == MovieType.topRated) {
      ref.read(topRatedMoviesProvider.notifier).loadMovies(ref);
    } else {
      ref.read(upcomingMoviesProvider.notifier).loadMovies(ref);
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        loadMoreMovies(ref);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var moviesProvider = switch (widget.movieType) {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GridView(
              controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 2,
              ),
              children: [
                ...moviesProvider.movieResponse!.map(
                  (movieResponse) => SizedBox(
                    width: context.screenWidth * 0.45,
                    child: InkWell(
                      onTap: () {
                        navigateTo(context, MovieDetail(movieResponse: movieResponse));
                      },
                      child: GridMoviePreview(movie: movieResponse.movie!),
                    ),
                  ),
                )
              ],
            ).padX(5),
          ),
          if (moviesProvider.isLoading!)
            const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
