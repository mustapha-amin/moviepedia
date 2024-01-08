import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/contants.dart';
import 'package:moviepedia/core/paths.dart';
import 'package:moviepedia/features/explore/controller/search_movies.dart';
import 'package:moviepedia/features/movie_details/views/movie_detail.dart';
import 'package:moviepedia/features/navbar/views/bottom_navbar.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/utils/extensions.dart';
import 'package:moviepedia/utils/kTextStyle.dart';
import 'package:moviepedia/utils/navigation.dart';

import '../../../utils/shimmer_image.dart';

class ExploreMovies extends ConsumerWidget {
  const ExploreMovies({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchControllerProvider = ref.watch(searchControllerTextProvider);
    return searchControllerProvider.isEmpty
        ? const SizedBox()
        : ref.watch(searchMoviesProvider(searchControllerProvider)).when(
              data: (data) => data.result!.isEmpty
                  ? Center(
                      child: Text(
                        "No result",
                        style: kTextStyle(25),
                      ),
                    )
                  : ListView.builder(
                      itemCount: data.result!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => navigateTo(
                              context,
                              MovieDetail(
                                movieResponse: MovieResponse(
                                  movie: data.result![index],
                                  cast: [],
                                ),
                                isExplore: true,
                              )),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: context.screenWidth * .3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: Paths.imagePathGen(
                                        data.result![index]!.posterPath),
                                    width: context.screenWidth * .3,
                                    placeholder: (context, _) {
                                      return ShimmerImage(
                                        height: context.screenHeight * .3,
                                        width: context.screenWidth * .3,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      children: [
                                        Text(
                                          data.result![index]!.title!,
                                          style: kTextStyle(17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      AppConstants.generateGenre(
                                          data.result![index]!.genreIds!),
                                      style: kTextStyle(13),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ).padY(5),
                        );
                      },
                    ).padAll(10),
              error: (e, __) => Center(
                child: Text("An error occured $e", style: kTextStyle(17)),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            );
  }
}
