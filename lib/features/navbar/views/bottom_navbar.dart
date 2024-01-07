import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/features/home/views/home.dart';
import 'package:moviepedia/utils/extensions.dart';
import 'package:moviepedia/utils/kTextStyle.dart';

import '../../explore/controller/search_movies.dart';
import '../../explore/views/explore.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: ref.watch(btmNavbarIndexProvider),
        onTap: (index) {
          ref.read(btmNavbarIndexProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(label: '', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: '', icon: Icon(Icons.search)),
          BottomNavigationBarItem(label: '', icon: Icon(Icons.bookmark)),
          BottomNavigationBarItem(label: '', icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
