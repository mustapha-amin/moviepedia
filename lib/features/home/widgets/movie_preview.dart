import 'package:flutter/material.dart';
import 'package:pixlstream/models/movie.dart';
import 'package:pixlstream/utils/extensions.dart';
import 'package:pixlstream/utils/kTextStyle.dart';

import '../../../core/paths.dart';

class MoviePreview extends StatelessWidget {
  final Movie movie;
  const MoviePreview({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * .35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: context.screenHeight * .35,
            width: context.screenWidth * .35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  Paths.imagePathGen(
                    movie.backdropPath,
                  ),
                ),
              ),
            ),
          ).padY(2),
          Text(
            movie.title.length < 40
                ? movie.title
                : '${movie.title.substring(0, 41)} ...',
            style: kTextStyle(13),
            softWrap: true,
          ),
        ],
      ).padX(7),
    );
  }
}
