import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixlstream/core/paths.dart';

final dioProvider = Provider(
  (ref) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Paths.baseUrl,
        connectTimeout: const Duration(milliseconds: 5000),
        queryParameters: {
          'api_key': '1dfbe81151a008c60f7af078a5272f5e',
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
          log("<-- ${response.statusCode} ${response.requestOptions.path}");
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
