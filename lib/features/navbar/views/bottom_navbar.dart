import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixlstream/features/home/controllers/popular_movies.dart';
import 'package:pixlstream/features/home/controllers/top_rated_movies.dart';
import 'package:pixlstream/features/home/controllers/upcoming_movies.dart';
import 'package:pixlstream/features/home/views/home.dart';

final btmNavbarIndexProvider = StateProvider((ref) {
  return 0;
});

class PixlBtmNavBar extends ConsumerStatefulWidget {
  const PixlBtmNavBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PixlBtmNavBarState();
}

class _PixlBtmNavBarState extends ConsumerState<PixlBtmNavBar> {
  final List<Widget> screens = const [
    Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
