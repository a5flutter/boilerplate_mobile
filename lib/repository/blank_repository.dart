import 'dart:async';

import 'package:blank_project/flavor/flavor_utils.dart';
import 'package:blank_project/http/http_client.dart';
import 'package:blank_project/http/http_errors.dart';
import 'package:dio/dio.dart';

abstract class IBlankRepository {
  Future<Response?> get(
    String path, {
    Map<String, dynamic> params,
    Map<String, dynamic> queryParameters,
  });

  Future<Response?> post(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParams,
  });

  Future<dynamic> put(String path, Map<String, dynamic> data);

  Future<dynamic> patch(String path, Map<String, dynamic> data);

  Future<dynamic> delete(String path, Map<String, dynamic> data);

  Response? checkErrorResponse(dynamic error) {
    if (error is TimeoutException) {
      devPrint('connection timeout - $error');
      HttpErrors.pushConnectionError();
    }

    if (error is DioError) {
      devPrint('Dio ${error.requestOptions.method} Error');
      devPrint('code - ${error.response?.statusCode}');
      devPrint('path - ${error.requestOptions.path}');
      devPrint('headers - ${error.requestOptions.headers}');
      devPrint('query params - ${error.requestOptions.queryParameters}');

      if (error.response?.statusCode == 401 &&
          ///Ignore 401 error for auth endpoints
          // error.requestOptions.path != signInEndpoint &&
          // error.requestOptions.path != signUpEndpoint &&
          // error.requestOptions.path != passwordResetEndpoint &&
          // error.requestOptions.path != changePasswordEndpoint &&
          // error.requestOptions.path != userProfileInvitationEndPoint &&
          !(error.requestOptions.data != null &&
              (error.requestOptions.data as Map<String, dynamic>)
                  .containsKey('token'))) {
        ///auth_error means sign in required and observer should push LogIn screen
        HttpErrors.pushError('auth_error');
      }
      return error.response;
    }

    return null;
  }
}

class BlankRepository extends IBlankRepository {
  Dio dio = HttpClient.getInstance().dio;

  @override
  Future<Response?> get(
    String path, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: params != null ? Options(headers: params) : null,
      );
      return response;
    } catch (e) {
      return checkErrorResponse(e);
    }
  }

  @override
  Future<Response?> post(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final Response response =
          await dio.post(path, data: data, queryParameters: queryParams);
      return response;
    } catch (e) {
      return checkErrorResponse(e);
    }
  }

  @override
  Future<dynamic> put(String path, Map<String, dynamic> data) async {
    try {
      final Response response = await dio.put(path, data: data);
      return response;
    } catch (e) {
      return checkErrorResponse(e);
    }
  }

  @override
  Future<dynamic> patch(String path, Map<String, dynamic> data) async {
    try {
      final Response response = await dio.patch(path, data: data);
      return response;
    } catch (e) {
      return checkErrorResponse(e);
    }
  }

  @override
  Future delete(String path, Map<String, dynamic> data) async {
    try {
      final Response response = await dio.delete(path, data: data);
      return response;
    } catch (e) {
      return checkErrorResponse(e);
    }
  }
}
