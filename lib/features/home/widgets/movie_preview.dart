import 'package:flutter/material.dart';
import 'package:moviepedia/features/movie_details/views/movie_detail.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/utils/extensions.dart';
import 'package:moviepedia/utils/kTextStyle.dart';
import 'package:moviepedia/utils/navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';
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
              width: 33.w,
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
                        height: context.screenHeight * .28,
                        width: context.screenWidth * .38,
                        placeholder: (context, _) {
                          return ShimmerImage(
                            height: context.screenHeight * .28,
                            width: context.screenHeight * .38,
                          );
                        },
                        errorWidget: (context, err, _) {
                          return const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          );
                        },
                      ),
                    ),
                  ),
                  Text(
                    movieResponse.movie!.title!,
                    style: kTextStyle(13, fontWeight: FontWeight.bold).copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ).padX(3),
                ],
              )).padAll(3),
        ),
      ),
    );
  }
}
