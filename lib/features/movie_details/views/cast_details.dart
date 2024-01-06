import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/utils/extensions.dart';

import '../../../utils/shimmer_image.dart';

class CastDetails extends StatelessWidget {
  final Cast cast;
  const CastDetails({required this.cast, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CachedNetworkImage(
                  imageUrl: cast.profilePath,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.2),
                  colorBlendMode: BlendMode.dstATop,
                  height: context.screenHeight * .6,
                  width: context.screenWidth,
                  placeholder: (context, _) {
                    return ShimmerImage(
                      height: context.screenHeight * .6,
                      width: context.screenWidth,
                    );
                  },
                ),
                Positioned(
                  top: 40,
                  left: 15,
                  child: IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.3),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
