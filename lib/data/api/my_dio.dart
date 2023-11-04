import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/definitions/app_definitions.dart';
import 'package:my_pet_melody/data/logger/error_reporter.dart';

final dioProvider = Provider(
  (ref) => MyDio(
    errorReporter: ref.watch(errorReporterProvider),
  ),
);

class MyDio {
  MyDio({required ErrorReporter errorReporter})
      : _dio = Dio(BaseOptions()),
        _errorReporter = errorReporter;

  static const _contentTypeJson = 'application/json';
  static const _contentTypeForm = 'application/x-www-form-urlencoded';

  final String _baseUrl = serverOrigin;
  final Dio _dio;
  final ErrorReporter _errorReporter;

  Future<T?> post<T>({
    required String path,
    required T Function(Map<String, dynamic> json) responseParser,
    required String token,
    String? purchaseUserId,
    Map<String, dynamic>? data,
  }) async {
    return _getResult<T>(
      path: path,
      contentType: _contentTypeJson,
      connectionExecutor: (url, options) async =>
          _dio.post<Map<String, dynamic>>(
        url,
        data: data,
        options: options,
      ),
      responseParser: responseParser,
      token: token,
      purchaseUserId: purchaseUserId,
    );
  }

  Future<T?> postFile<T>({
    required String path,
    required File file,
    required String fileName,
    required T Function(Map<String, dynamic> json) responseParser,
  }) async {
    final fileData =
        await MultipartFile.fromFile(file.path, filename: fileName);
    final data = FormData.fromMap(<String, dynamic>{
      'file': fileData,
    });

    return _getResult<T>(
      path: path,
      contentType: _contentTypeForm,
      connectionExecutor: (url, options) async =>
          _dio.post<Map<String, dynamic>>(
        url,
        data: data,
        options: options,
      ),
      responseParser: responseParser,
    );
  }

  Future<T?> _getResult<T>({
    required String path,
    required String contentType,
    required Future<Response<dynamic>> Function(String url, Options options)
        connectionExecutor,
    required T Function(Map<String, dynamic> json) responseParser,
    String? token,
    String? purchaseUserId,
  }) async {
    final url = '$_baseUrl$path';

    final headers = {
      HttpHeaders.contentTypeHeader: contentType,
    };

    if (token != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    if (purchaseUserId != null) {
      headers['purchase-user-id'] = purchaseUserId;
    }

    if (Platform.isIOS) {
      headers['platform'] = 'iOS';
    } else {
      headers['platform'] = 'Android';
    }

    try {
      final response = await connectionExecutor(url, Options(headers: headers));

      final responseData =
          responseParser(response.data as Map<String, dynamic>);

      return responseData;
    } on DioException catch (error, stack) {
      unawaited(
        _errorReporter.send(
          error,
          stack,
          reason: 'exception when calling API',
          information: [
            error.message?.toString() ?? '(No message)',
            error.type.name,
            error.response.toString(),
          ],
        ),
      );

      return null;
    } on SocketException {
      return null;
    }
  }
}
