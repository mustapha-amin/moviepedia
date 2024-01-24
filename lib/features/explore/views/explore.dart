import 'dart:developer';

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

class ExploreMovies extends ConsumerStatefulWidget {
  const ExploreMovies({super.key});

  @override
  ConsumerState<ExploreMovies> createState() => _ExploreMoviesState();
}

class _ExploreMoviesState extends ConsumerState<ExploreMovies> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 40,
          child: SearchBar(
            elevation: const MaterialStatePropertyAll(3),
            onTap: () {
              log(searchController.text);
            },
            hintText: "Search here",
            hintStyle: MaterialStatePropertyAll(
              kTextStyle(
                15,
                color: Colors.grey,
              ),
            ),
            controller: searchController,
          ).padX(10),
        ),
        const SizedBox(
          height: 10,
        ),
        searchController.text.isEmpty
            ? const SizedBox()
            : ref
                .watch(searchMoviesProvider(searchController.text.trim()))
                .when(
                  data: (data) => data!.isEmpty
                      ? Center(
                          child: Text(
                            "No result",
                            style: kTextStyle(25),
                          ),
                        )
                      : Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.5,
                            ),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => navigateTo(
                                    context,
                                    MovieDetail(
                                      movieResponse: MovieResponse(
                                        movie: data[index],
                                        cast: [],
                                      ),
                                      isExplore: true,
                                    )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: Paths.imagePathGen(
                                            data[index]!.posterPath),
                                        width: context.screenWidth * .28,
                                        height: context.screenHeight * .23,
                                        placeholder: (context, _) {
                                          return ShimmerImage(
                                            height: context.screenHeight * .23,
                                            width: context.screenWidth * .28,
                                          );
                                        },
                                      ),
                                    ),
                                    Text(
                                      data[index]!.title!,
                                      style: kTextStyle(13,
                                              fontWeight: FontWeight.bold)
                                          .copyWith(
                                              overflow: TextOverflow.ellipsis),
                                    ),
                                    Text(
                                      data[index]!.releaseDate!,
                                      style: kTextStyle(
                                        12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ).padX(10),
                              );
                            },
                          ),
                        ),
                  error: (e, __) => Center(
                    child: Text("An error occured $e", style: kTextStyle(17)),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
      ],
    );
  }
}
