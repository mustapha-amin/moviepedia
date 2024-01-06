import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/utils/extensions.dart';
import 'package:moviepedia/utils/kTextStyle.dart';
import 'package:moviepedia/utils/shimmer_image.dart';

class CastPreview extends StatelessWidget {
  final Cast cast;
  const CastPreview({required this.cast, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: cast.name,
            height: context.screenWidth * .28,
            width: context.screenWidth * .28,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return ShimmerImage(
                height: context.screenWidth * .28,
                width: context.screenWidth * .28,
              );
            },
          ),
        ),
        Text(
          cast.originalName,
          style: kTextStyle(16, fontWeight: FontWeight.bold),
        ),
        Text(
          cast.name,
          style: kTextStyle(12),
        ),
      ],
    );
  }
}
