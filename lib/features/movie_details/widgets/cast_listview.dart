import 'package:flutter/material.dart';
import 'package:moviepedia/features/movie_details/widgets/cast_widget.dart';
import 'package:moviepedia/models/movie_response.dart';
import 'package:moviepedia/utils/extensions.dart';

import '../../../utils/kTextStyle.dart';

class CastListView extends StatelessWidget {
  final List<Cast> castList;
  const CastListView({required this.castList, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * .3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            " Cast",
            style: kTextStyle(
              35,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                ...castList.map(
                  (cast) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CastPreview(cast: cast),
                  ),
                )
              ],
            ).padX(2),
          ),
        ],
      ),
    );
  }
}
