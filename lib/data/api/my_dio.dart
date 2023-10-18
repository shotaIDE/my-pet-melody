import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/definitions/app_definitions.dart';

final dioProvider = Provider(
  (ref) => MyDio(),
);

class MyDio {
  MyDio() : _dio = Dio(BaseOptions());

  static const _contentTypeJson = 'application/json';
  static const _contentTypeForm = 'application/x-www-form-urlencoded';

  final String _baseUrl = AppDefinitions.serverOrigin;
  final Dio _dio;

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

    dynamic responseDataRaw;

    try {
      final response = await connectionExecutor(url, Options(headers: headers));
      responseDataRaw = response.data;

      final responseData =
          responseParser(response.data as Map<String, dynamic>);

      return responseData;
    } on DioException catch (error) {
      debugPrint('DioException: $responseDataRaw');
      debugPrint('$error');

      return null;
    } on SocketException catch (error) {
      debugPrint('SocketException: $responseDataRaw');
      debugPrint('$error');

      return null;
    }
  }
}
