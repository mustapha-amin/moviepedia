import 'package:flutter/material.dart';
import 'package:pixlstream/features/home/views/movie_detail.dart';
import 'package:pixlstream/models/movie.dart';
import 'package:pixlstream/utils/extensions.dart';
import 'package:pixlstream/utils/kTextStyle.dart';
import 'package:pixlstream/utils/navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/paths.dart';
import '../../../utils/shimmer_image.dart';

class MoviePreview extends StatelessWidget {
  final Movie movie;
  const MoviePreview({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(context, MovieDetail(movie: movie));
      },
      child: Hero(
        tag: movie,
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
                      imageUrl: Paths.imagePathGen(movie.posterPath),
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
                  movie.title.length < 40
                      ? movie.title
                      : '${movie.title.substring(0, 41)} ...',
                  style: kTextStyle(13),
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
