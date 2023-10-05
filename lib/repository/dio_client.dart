import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../ui/utils/themes/app_urls.dart';

 class DioClient {
  late Dio _dio;

  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    BaseOptions options = BaseOptions(
        baseUrl: AppUrls.baseUrl,
        connectTimeout: const Duration(milliseconds: 60000),
        receiveTimeout: const Duration(milliseconds: 60000),
        headers: {
          HttpHeaders.acceptHeader: Headers.jsonContentType,
        },
        validateStatus: (status) {
          if (status == 401) {
            return false;
          } else {
            return true;
          }
        },
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json);
    _dio = Dio(options);

    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      // print("app request data ${options.data}");
      return handler.next(options);
    }, onResponse: (response, handler) {
      if (kDebugMode) {
        debugPrint("app response data ${response.data}");
      }
      return handler.next(response);
    }, onError: (DioException e, handler) {
      if (kDebugMode) {
        debugPrint("app error data $e");
      }
      ErrorEntity eInfo = _createErrorEntity(e);
      onError(eInfo);
    }));
  } //finish internal()


  Future post(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        BuildContext? context,
      }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ) {
      try {
        Options requestOptions = options ?? Options();
        requestOptions.headers = requestOptions.headers ?? {};

        var response = await _dio.post(path,
            data: data, queryParameters: queryParameters, options: requestOptions);

        debugPrint("STATUS ${response.statusCode} ${response.statusMessage}");
        return response.data;
      } on DioException catch (e) {
        throw _createErrorEntity(e);
      }
    } else {
      debugPrint('error');
      throw Exception("Network Error");
    }
  }

  // GET
  Future<Map<String, dynamic>> get({
    required String path,
    Map<String, dynamic>? query,
  }) async {

    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ) {
      try {
        final response = await _dio.get(
          path,
          queryParameters: query,
        );
        debugPrint("STATUS ${response.statusCode} ${response.statusMessage}");
        return response.data;
      } on DioException catch (e) {
        throw _createErrorEntity(e);
      }
    } else {
      debugPrint('error');
      throw Exception("Network Error");
    }
  }



  Future<Map<String, dynamic>> uploadFileProgressWithFormData(
      {required String path,
        required FormData formData,}) async {
    try {
      final response = await _dio.post(path,
        data: formData,
       options: Options(
          receiveTimeout: const Duration(milliseconds: 60 * 1000),
        ),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _createErrorEntity(e);
    }
  }

  // PUT
  Future<Map<String, dynamic>> put({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: query,
      );
      return response.data;
    } on DioException catch (e) {
      throw _createErrorEntity(e);
    }
  }

  // PATCH
  Future<Map<String, dynamic>> patch({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: query,
      );

      return response.data;
    } on DioException catch (e) {
      throw _createErrorEntity(e);
    }
  }

  // PATCH
  Future<Map<String, dynamic>?> delete({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: query,
      );
      return response.data;
    } on DioException catch (e) {
      throw _createErrorEntity(e);
    }
  }

}

class ErrorEntity implements Exception {
  int code = -1;
  String message = "";

  ErrorEntity({required this.code, required this.message});

  @override
  String toString() {
    if (message == "") return "Exception";

    return "Exception code $code, $message";
  }
}

ErrorEntity _createErrorEntity(DioException error){
  switch(error.type){
    case DioExceptionType.connectionTimeout:
      return ErrorEntity(code: -1, message: "Connection timed out");

    case DioExceptionType.sendTimeout:
      return ErrorEntity(code: -1, message: "Send timed out");

    case DioExceptionType.receiveTimeout:
      return ErrorEntity(code: -1, message: "Receive timed out");

    case DioExceptionType.badCertificate:
      return ErrorEntity(code: -1, message: "Bad SSL certificates");

    case DioExceptionType.badResponse:

      switch(error.response!.statusCode){
        case 400:
          return ErrorEntity(code: 400, message: "Bad request");
        case 401:
          return ErrorEntity(code: 401, message: "Permission denied");
        case 500:
          return ErrorEntity(code: 500, message: "Server internal error");
      }
      return ErrorEntity(code: error.response!.statusCode!, message: "Server bad response");

    case DioExceptionType.cancel:
      return ErrorEntity(code: -1, message: "Server canceled it");

    case DioExceptionType.connectionError:
      return ErrorEntity(code: -1, message: "Connection error");

    case DioExceptionType.unknown:
      return ErrorEntity(code: -1, message: "Unknown error");
  }
}

void onError(ErrorEntity eInfo){
  debugPrint('error.code -> ${eInfo.code}, error.message -> ${eInfo.message}');
  switch(eInfo.code){
    case 400:
      debugPrint("Server syntax error");
      break;
    case 401:
      debugPrint("You are denied to continue");
      break;
    case 500:
      debugPrint("Server internal error");
      break;
    default:
      debugPrint("Unknown error");
      break;

  }
}

/*
class ApiController extends _BaseApi {
  const ApiController() {
    super.init(version:1);
  }
}*/
