import 'package:flutter/material.dart';
import 'package:pixlstream/core/paths.dart';
import 'package:pixlstream/models/movie.dart';
import 'package:pixlstream/utils/extensions.dart';
import 'package:pixlstream/utils/kTextStyle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pixlstream/utils/shimmer_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;
  const MovieDetail({required this.movie, super.key});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: Paths.imagePathGen(
                    widget.movie.backdropPath,
                  ),
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
              ),
              Positioned(
                bottom: 20,
                child: Hero(
                  tag: widget.movie,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: Paths.imagePathGen(widget.movie.backdropPath),
                      fit: BoxFit.cover,
                      width: context.screenWidth * .5,
                      height: context.screenHeight * .4,
                      placeholder: (context, _) {
                        return ShimmerImage(
                          height: context.screenHeight * .4,
                          width: context.screenWidth * .5,
                        );
                      },
                    ),
                  ),
                ),
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
                  icon: const Icon(Icons.arrow_back_ios_outlined),
                ),
              ),
              Text(
                widget.movie.originalTitle,
                style: kTextStyle(20, fontWeight: FontWeight.bold),
              ).padX(8),
            ],
          ),
          SizedBox(
            height: context.screenHeight * .4,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Text(
                          widget.movie.voteAverage.toStringAsFixed(1),
                          style: kTextStyle(20),
                        ),
                        Text(
                          " (${widget.movie.voteCount} votes)",
                          style: kTextStyle(18),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.bookmark_add_outlined),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.star_border_outlined),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Release date: ${widget.movie.releaseDate.formatJoinTime}',
                  style: kTextStyle(18, color: Colors.amber),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.movie.overview,
                  style: kTextStyle(16),
                ),
              ],
            ).padX(10),
          )
        ],
      ),
    );
  }
}
