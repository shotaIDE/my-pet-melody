import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MyDio {
  MyDio() : _dio = Dio();

  static const _contentTypeJson = 'application/json';
  static const _contentTypeForm = 'application/x-www-form-urlencoded';

  final String _baseUrl = 'http://192.168.11.3:5000';
  final Dio _dio;

  Future<void> post<T>({
    required String path,
    required T Function(Map<String, dynamic> json) responseParser,
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
    );
  }

  Future<void> postFile<T>({
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

  Future<void> _getResult<T>({
    required String path,
    required String contentType,
    required Future<Response<dynamic>> Function(String url, Options options)
        connectionExecutor,
    required T Function(Map<String, dynamic> json) responseParser,
  }) async {
    final url = '$_baseUrl$path';

    final headers = {
      HttpHeaders.contentTypeHeader: contentType,
    };

    dynamic responseDataRaw;

    try {
      final response = await connectionExecutor(url, Options(headers: headers));
      responseDataRaw = response.data;

      final responseData =
          responseParser(response.data as Map<String, dynamic>);
      return;
    } on DioError catch (error) {
      debugPrint('DioError: $responseDataRaw');
      debugPrint('$error');

      return;
    } on SocketException catch (error) {
      debugPrint('SocketException: $responseDataRaw');
      debugPrint('$error');

      return;
    }
  }
}
