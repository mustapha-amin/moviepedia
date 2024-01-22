import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/features/coming_soon.dart';
import 'package:moviepedia/features/home/views/home.dart';
import 'package:moviepedia/utils/extensions.dart';
import 'package:moviepedia/utils/kTextStyle.dart';
import '../../home/controllers/popular_movies.dart';
import '../../explore/controller/search_movies.dart';
import '../../explore/views/explore.dart';
import 'package:sizer/sizer.dart';

final btmNavbarIndexProvider = StateProvider((ref) {
  return 0;
});

final searchControllerTextProvider = StateProvider(
  (ref) => '',
);

class AppBtmNavBar extends ConsumerStatefulWidget {
  const AppBtmNavBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppBtmNavBarState();
}

class _AppBtmNavBarState extends ConsumerState<AppBtmNavBar> {
  final List<Widget> screens = const [
    Home(),
    ExploreMovies(),
    ComingSoon(),
    ComingSoon(),
  ];

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        title: ref.watch(btmNavbarIndexProvider) == 1
            ? SizedBox(
                height: context.screenHeight * .07,
                child: SearchBar(
                  onTap: () {
                    log(ref.watch(searchControllerTextProvider));
                  },
                  hintText: "Search here",
                  hintStyle: MaterialStatePropertyAll(
                    kTextStyle(
                      15,
                      color: Colors.grey,
                    ),
                  ),
                  controller: searchController,
                  onChanged: (val) {
                    ref.read(searchControllerTextProvider.notifier).state = val;
                  },
                  onSubmitted: (query) {
                    ref.read(searchMoviesProvider(
                        ref.watch(searchControllerTextProvider)));
                  },
                ),
              )
            : Text(
                "MoviePedia",
                style: kTextStyle(
                  30,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      body: IndexedStack(
        index: ref.watch(btmNavbarIndexProvider),
        children: screens,
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.topCenter,
        children: [
          Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              colorScheme: const ColorScheme.dark().copyWith(
                background: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            child: BottomNavigationBar(
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: kTextStyle(14),
              unselectedLabelStyle: kTextStyle(13),
              type: BottomNavigationBarType.fixed,
              currentIndex: ref.watch(btmNavbarIndexProvider),
              onTap: (index) {
                ref.read(btmNavbarIndexProvider.notifier).state = index;
                if (index != 1) {
                  ref.invalidate(searchMoviesProvider);
                  ref.invalidate(searchControllerTextProvider);
                }
              },
              items: const [
                BottomNavigationBarItem(
                  label: 'Home',
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: 'Explore',
                  icon: Icon(Icons.search),
                ),
                BottomNavigationBarItem(
                  label: 'Bookmark',
                  icon: Icon(Icons.bookmark),
                ),
                BottomNavigationBarItem(
                  label: 'Account',
                  icon: Icon(Icons.person),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            left: switch (ref.watch(btmNavbarIndexProvider)) {
              1 => 32.w,
              2 => 57.w,
              3 => 82.w,
              _ => 7.5.w,
            },
            child: SizedBox(
              width: context.screenWidth * .1,
              height: 5,
              child: const ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: ColoredBox(
                  color: Colors.amber,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
