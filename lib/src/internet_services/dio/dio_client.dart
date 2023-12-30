import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:movilcomercios/src/internet_services/dio/dio_exception.dart';

/// Create a singleton class to contain all Dio methods and helper functions
class DioClient {
  DioClient._();
  static final instance = DioClient._();
  static const urlMRN = "http://192.168.1.100:8000/";
  //static const urlMRN = "https://api-produccion-recargas-mrn.click/";

  final Dio _dio = Dio(
      BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          responseType: ResponseType.json,
          contentType: 'application/json',
          )
  );

  Future<bool> checkInternetConnection() async {
    try {
      Dio dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5); // Timeout de conexión de 5 segundos
      dio.options.receiveTimeout = const Duration(seconds: 5); // Timeout de recepción de 5 segundos
      Response response = await dio.get('https://www.google.com');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Token $token';
  }
  getBaseUrl(){
    return _dio.options.baseUrl;
  }

  void setUrl(String url, {String token = ''}){
     _dio.options.baseUrl = urlMRN + url;
     if (token.isNotEmpty) {
       _dio.options.headers['Authorization'] = 'Token $token';
     } else {
       _dio.options.headers.remove('Authorization');
     }
  }
  void setUrlConceptoMovilLogin(String url, {String token = ''}){
    _dio.options.baseUrl = 'https://150.136.18.204';
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'URL': urlMRN + url,
      'UUID': 'uuid',
      'Brand-Device': 'manufacturer',
      'Model-Device': 'model',
      'Type-Device': 'platform',
      'Sponsor-Authorization': "\$2b\$10\$5hBiWZcdxXo6sQjy5equ1eUl/axKYblXTJ0Y0UG4lmiDtbRd846P2",
    };
    if (token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Token $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
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
        print(response.data);
        final dynamic responseData = response.data;
        if (responseData is String) {
          final decodedData = jsonDecode(responseData);
          if (decodedData is Map<String, dynamic>) {
            // Utilizar decodedData como un mapa
            return decodedData;
          }
        }else if (responseData is Map<String, dynamic>) {
          // Si es un mapa (JSON), devolverlo
          return responseData;
        } else{
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