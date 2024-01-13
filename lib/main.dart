import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/navbar/views/bottom_navbar.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  await dotenv.load(fileName: 'api_key.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Sizer(
          builder: (context, _, __) {
            return const AppBtmNavBar();
          },
        ),
      ),
    );
  }
}
