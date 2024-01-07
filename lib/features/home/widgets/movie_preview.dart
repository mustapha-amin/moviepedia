import 'package:flutter/material.dart';
import 'package:moviepedia/features/movie_details/views/movie_detail.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/utils/extensions.dart';
import 'package:moviepedia/utils/kTextStyle.dart';
import 'package:moviepedia/utils/navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/paths.dart';
import '../../../utils/shimmer_image.dart';
import '/utils/enums.dart';

class MoviePreview extends StatelessWidget {
  final MovieResponse movieResponse;
  final MovieType movieType;
  const MoviePreview(
      {required this.movieResponse, required this.movieType, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(context,
            MovieDetail(movieResponse: movieResponse, movieType: movieType));
      },
      child: Hero(
        tag: movieResponse.movie!,
        child: Card(
          child: SizedBox(
            width: context.screenWidth * .35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      fit: BoxFit.cover,
                      imageUrl:
                          Paths.imagePathGen(movieResponse.movie!.posterPath),
                      height: context.screenHeight * .35,
                      width: context.screenWidth * .38,
                      placeholder: (context, _) {
                        return ShimmerImage(
                          height: context.screenHeight * .35,
                          width: context.screenHeight * .38,
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  movieResponse.movie!.title!.length < 40
                      ? movieResponse.movie!.title!
                      : '${movieResponse.movie!.title!.substring(0, 41)} ...',
                  style: kTextStyle(15),
                  softWrap: true,
                ),
              ],
            ).padX(7),
          ).padAll(3),
        ),
      ),
    );
  }
}
