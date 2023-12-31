import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixlstream/features/home/views/home.dart';
import 'package:pixlstream/utils/kTextStyle.dart';

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
      appBar: AppBar(
        elevation: 0,
        title: Text(
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
