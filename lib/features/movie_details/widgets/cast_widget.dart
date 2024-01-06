import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/utils/extensions.dart';
import 'package:moviepedia/utils/kTextStyle.dart';
import 'package:moviepedia/utils/shimmer_image.dart';

import '../../../core/paths.dart';

class CastPreview extends StatelessWidget {
  final Cast cast;
  const CastPreview({required this.cast, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        cast.profilePath.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: Paths.imagePathGen(cast.profilePath),
                  height: context.screenWidth * .25,
                  width: context.screenWidth * .25,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return ShimmerImage(
                      height: context.screenWidth * .28,
                      width: context.screenWidth * .28,
                    );
                  },
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: context.screenWidth * .25,
                      width: context.screenWidth * .25,
                      child: const ColoredBox(color: Colors.grey),
                    ),
                    const Icon(
                      Icons.person,
                      size: 40,
                    )
                  ],
                ),
              ),
        Text(
          cast.originalName,
          style: kTextStyle(16, fontWeight: FontWeight.bold),
        ),
        Text(
          cast.character,
          style: kTextStyle(12),
        ),
      ],
    );
  }
}
