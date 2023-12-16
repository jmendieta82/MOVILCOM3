import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:movilcomercios/src/internet_services/dio/dio_exception.dart';

/// Create a singleton class to contain all Dio methods and helper functions
class DioClient {
  DioClient._();
  static final instance = DioClient._();

  final Dio _dio = Dio(
      BaseOptions(
          //baseUrl: "http://192.168.1.103:8000/",
          baseUrl: "https://api-produccion-recargas-mrn.click/",
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          responseType: ResponseType.json,
          contentType: 'application/json',
          )
  );
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Token $token';
  }
  ///Get Method
  Future<List<dynamic>> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
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
      throw Exception("Received status code ${response.statusCode}");
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
        ProgressCallback? onReceiveProgress,
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
        }else{
          return response.data;
        }
        throw "Response data is not in the expected format";
      }
      throw Exception("Received status code ${response.statusCode}");
    }on DioException catch (e) {
      throw DioExceptionCustom.fromDioError(e);
    }
  }
}