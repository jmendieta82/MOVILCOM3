import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movilcomercios/src/internet_services/dio/paths.dart';

/// Create a singleton class to contain all Dio methods and helper functions
class DioClient {
  DioClient._();

  static final instance = DioClient._();

  final Dio _dio = Dio(
      BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          responseType: ResponseType.json,
          contentType: 'application/json',
          headers: {'Authorization': 'Token 8583bfb912ad624fee1c8a14162bb237cfec69a7'})
  );

  ///Get Method
  Future<List<dynamic>> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress
      }) async{
    try{
      final Response response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      if(response.statusCode == 200){
        return response.data;
      }
      throw "something went wrong";
    } catch(e){
      rethrow;
    }
  }

  ///Post Method
  Future<Map<String, dynamic>> post(
      String path, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress
      }) async {
    try {
      final Response response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic responseData = response.data;
        if (responseData is String) {
          final decodedData = jsonDecode(responseData);
          if (decodedData is Map<String, dynamic>) {
            // Utilizar decodedData como un mapa
            return decodedData;
          }
        }
        throw "Response data is not in the expected format";
      }
      throw "something went wrong";
    } catch (e) {
      rethrow;
    }
  }
}