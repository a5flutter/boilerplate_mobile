import 'package:blank_project/http/auth_interceptor_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

class HttpClient {
  HttpClient({BaseOptions? options}) {
    dio = Dio(options ?? baseOptions);
    authInterceptorDio = AuthInterceptorDio(dio);
    dio.interceptors.addAll([authInterceptorDio]);
  }
  static HttpClient client = HttpClient(options: baseOptions);

  late Dio dio;
  late AuthInterceptorDio authInterceptorDio;

  static BaseOptions baseOptions = BaseOptions(
    baseUrl: FlavorConfig.instance.variables['base_url'] as String,
    connectTimeout: 20000,
    receiveTimeout: 20000,
  );

  static HttpClient getInstance()=> client;

  void clearToken (){
    authInterceptorDio.clearToken();
  }
}
