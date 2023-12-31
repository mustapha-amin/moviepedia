import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviepedia/core/paths.dart';

final dioProvider = Provider(
  (ref) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Paths.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        queryParameters: {
          'api_key': dotenv.env['API_KEY'],
          'language': 'en-US',
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log("--> ${options.method} ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log("<-- ${response.statusCode} ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log("<-- Error: ${e.message}");
        },
      ),
    );
    return dio;
  },
);

final topratedPageProvider = StateProvider((ref) {
  return 1;
});

final upcomingPageProvider = StateProvider((ref) {
  return 1;
});

final popularPageProvider = StateProvider((ref) {
  return 1;
});
