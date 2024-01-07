import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviepedia/core/paths.dart';
import 'package:moviepedia/utils/extensions.dart';
import 'package:moviepedia/utils/kTextStyle.dart';

import '../../../models/movie_response.dart';

class GridMoviePreview extends StatelessWidget {
  final Movie movie;
  const GridMoviePreview({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                fadeInDuration: const Duration(milliseconds: 100),
                fadeOutDuration: const Duration(milliseconds: 100),
                fit: BoxFit.cover,
                imageUrl: Paths.imagePathGen(movie.posterPath),
                height: context.screenHeight * .4,
                width: context.screenWidth * .45,
              ),
            ),
          ),
          Wrap(
            children: [
              Text(
                movie.title!.length <= 40
                    ? movie.title!
                    : '${movie.title!.substring(0, 41)} ...',
                style: kTextStyle(15),
                softWrap: true,
              ),
            ],
          ),
        ],
      ).padAll(5),
    );
  }
}
