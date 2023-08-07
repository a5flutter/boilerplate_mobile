import 'dart:async';

import 'package:blank_project/flavor/flavor_utils.dart';
import 'package:blank_project/repository/secure_local_storage.dart';
import 'package:dio/dio.dart';

class AuthInterceptorDio implements InterceptorsWrapper {
  AuthInterceptorDio(this._dio);

  static const _authorization = 'Authorization';
  final Dio _dio;
  String? token;

  @override
  Future onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    _dio.interceptors.requestLock.lock();

    ///if signIn request we adding FCM token if needed
    // if (options.path == signInEndpoint) {
    //   final String? pushToken = await FirebaseMessaging.instance.getToken();
    //   options.headers.addAll({'Device-Id': pushToken});
    // }

    if (token == null) {
      final tokens = await SecureLocalStorage().getTokens();
      if (tokens?.accessToken != null && tokens!.accessToken!.isNotEmpty) {
        token = 'Bearer ${tokens.accessToken}';
      }
    }
      options.headers.addAll({_authorization: token});
    _dio.interceptors.requestLock.unlock();
    return handler.next(options);
  }

  @override
  Future onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) async {
    return handler.next(response);
  }

  @override
  Future onError(DioError error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401 &&
        (error.requestOptions.data != null) &&
        (error.requestOptions.data as Map<String, dynamic>)
            .containsKey('token')) {
      return handler.next(error);
    }

    // Assume 401 stands for token expired
    if (error.response?.statusCode == 401) {
      final RequestOptions options = error.requestOptions;
      // If the token has been updated, repeat directly.
      if (token != options.headers[_authorization]) {
        options.headers[_authorization] = token;
        //repeat
        final opts = Options(
          method: options.method,
          headers: options.headers,
        );
        final cloneReq = await _dio.request(
          options.path,
          options: opts,
          data: options.data,
          queryParameters: options.queryParameters,
        );
        return handler.resolve(cloneReq);
      }
      // update token and repeat
      // Lock to block the incoming request until the token updated
      _dio.lock();
      _dio.interceptors.responseLock.lock();
      _dio.interceptors.errorLock.lock();
      //update token
      final String? newToken = await refreshToken();
      if (newToken == null || newToken == '401') {
        _dio.unlock();
        _dio.interceptors.responseLock.unlock();
        _dio.interceptors.errorLock.unlock();
        return handler.next(error);
      } else {
        token = 'Bearer $newToken';
        options.headers[_authorization] = token;
        //Unlock incoming requests
        _dio.unlock();
        _dio.interceptors.responseLock.unlock();
        _dio.interceptors.errorLock.unlock();

        final opts = Options(
          method: error.requestOptions.method,
          headers: error.requestOptions.headers,
        );
        final cloneReq = await _dio.request(
          error.requestOptions.path,
          options: opts,
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters,
        );

        return handler.resolve(cloneReq);
      }
    }
    return handler.next(error);
  }

  Future<String?> refreshToken() async {
    devPrint('AuthInterceptor.refreshToken');
    ///Token refreshing implement here
    // try {
    //   SignInModel tokens = await SecureLocalStorage().getTokens();
    //   Response? response;
    //   try {
    //     final url = await FlavorConfig.instance.variables['base_url'] as String;
    //     response = await Dio().post(
    //       '$url$tokenRefreshEndpoint',
    //       data: {'refresh': tokens.refreshToken},
    //     );
    //   } catch (e) {
    //     devPrint(
    //       'Error refreshing token - $e',
    //     );
    //   }
    //   if (response == null) {
    //     await AuthenticationService().signOutLocal();
    //     return '401';
    //   }
    //   tokens = SignInModel.fromJson(response.data as Map<String, dynamic>);
    //   await SecureLocalStorage().saveTokens(tokens);
    //   devPrint(
    //     'AuthenticationService.refreshToken token received - ${tokens.accessToken}',
    //   );
    //   return tokens.accessToken!;
    // } catch (error) {
    //   devPrint('AuthenticationService.refreshToken error - $error');
    //   if (error.toString() == 'Exception: 401') {
    //     return '401';
    //   }
    // }
    return null;
  }

  void clearToken() => token = null;
}
