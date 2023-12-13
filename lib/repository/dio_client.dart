import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:provider/provider.dart';

import 'package:food_stock/ui/widget/no_internet_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/services/locale_provider.dart';
import '../ui/utils/themes/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class DioClient {
  final Dio _dio;
  late BuildContext _context;
  bool isLogOut = false;
  bool isLoggedIn = true;

  DioClient(this._context)
      : _dio = Dio(
          BaseOptions(
              baseUrl: AppUrls.baseUrl,
              connectTimeout: const Duration(milliseconds: 60000),
              receiveTimeout: const Duration(milliseconds: 60000),
              headers: {
                HttpHeaders.acceptHeader: Headers.jsonContentType,
                HttpHeaders.authorizationHeader: 'Bearer 1',
              },
              validateStatus: (status) {
                if (status == 401) {
                  return false;
                } else {
                  return true;
                }
              },
              contentType: Headers.jsonContentType,
              responseType: ResponseType.json),
        )..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
            // print("app request data ${options.data}");
            return handler.next(options);
          }, onResponse: (response, handler) async {
            if (kDebugMode) {
              debugPrint("app response data ${response.data}");
            }
            return handler.next(response);
          }, onError: (DioException e, handler) {
            if (kDebugMode) {
              debugPrint("app error data $e");
            }
            /*   ErrorEntity eInfo = _createErrorEntity(e,context: _context);
    onError(eInfo);*/
            return handler.next(e);
          }));

  Future post(String path,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    SharedPreferencesHelper preferencesHelper =
        SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
    debugPrint('URL = ${AppUrls.baseUrl}$path');
    debugPrint('token = ${preferencesHelper.getAuthToken()}');
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        Options requestOptions = options ??
            Options(
                headers: {
              HttpHeaders.authorizationHeader:
                 'Bearer ${preferencesHelper.getAuthToken()}'
            });
        requestOptions.headers = requestOptions.headers ?? {};

        var response = await _dio.post(path,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions);

        return response.data;
      } on DioException catch (e) {

       // isLoggedIn =  await preferencesHelper.getUserLoggedIn();
        if(e.response?.statusCode == 401) {

          debugPrint('[refreshToken Api url] ${AppUrls.refreshTokenUrl}');

           final res = await _dio.post(AppUrls.refreshTokenUrl, data: {
            "token" : 'Bearer ${preferencesHelper.getRefreshToken()}'
          });

           debugPrint('[refreshToken Api url] ${AppUrls.refreshTokenUrl}');

          // RefreshTokenModel response = RefreshTokenModel.fromJson(res as dynamic);

          if(res.statusCode == 200) {
            print('[refresh Api response]  ${res.data['data']}');

             preferencesHelper.setUserLoggedIn(isLoggedIn: true);
             preferencesHelper.setAuthToken(accToken: res.data?['data']['accessToken'] ?? '');
             preferencesHelper.setRefreshToken(refToken: res.data?['data']['refreshToken'] ?? '');
             print('accessToken_____${res.data?['data']['accessToken'] ?? ''}');

          }

          if(res.statusCode == 401){
             var response1 = await _dio.put(AppUrls.logOutUrl,  data: {
            "userId" : preferencesHelper.getUserId()
          });

          if(response1. statusCode == 200 && !isLogOut) {
            isLogOut = true;
            await preferencesHelper.setUserLoggedIn();
            debugPrint('Token Expired = ${response1.data}');
            await Provider.of<LocaleProvider>(_context, listen: false)
                .setAppLocale(locale: Locale(AppStrings.hebrewString));
            showSnackBar(
                context: _context,
                title: '${AppLocalizations.of(_context)!.logged_out_successfully}',
                bgColor: AppColors.mainColor);

            Navigator.popUntil(_context,
                (route) => route.name == RouteDefine.bottomNavScreen.name);
            Navigator.pushNamed(_context, RouteDefine.connectScreen.name);
            ScaffoldMessenger.of(_context).hideCurrentSnackBar();
          }
          }

        } else {
        throw _createErrorEntity(e, context: _context);
        }
      }
    } else {
      debugPrint('no internet');
      showDialog(
        context: _context,
        builder: (context) => NoInternetDialog(positiveOnTap: () {
          Navigator.pop(context);
        }),
      );
    }
  }

  // GET
  Future<Map<String, dynamic>> get(
      {required String path,
      Map<String, dynamic>? query,
      Options? options}) async {
    try {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      debugPrint('URL = ${AppUrls.baseUrl}$path');
      final connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          final response = await _dio.get(path,
              queryParameters: query,
              options: options ??
                  Options(headers: {
                    HttpHeaders.authorizationHeader:
                        'Bearer ${preferencesHelper.getAuthToken()}'
                  }));
          debugPrint("STATUS ${response.statusCode} ${response.statusMessage}");
          return response.data as Map<String, dynamic>;
        } on DioException catch (e) {
          throw _createErrorEntity(e, context: _context);
        }
      } else {
        debugPrint('error');
        throw Exception("Network Error");
      }
    } on DioException catch (e) {
      throw _createErrorEntity(e);
    }
  }

  Future<Map<String, dynamic>> uploadFileProgressWithFormData(
      {required String path, required FormData formData}) async {
    try {
      debugPrint('URL = ${AppUrls.baseUrl}$path');
      final response = await _dio.post(
        path,
        data: formData,
        options: Options(
          receiveTimeout: const Duration(milliseconds: 60 * 1000),
        ),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _createErrorEntity(e, context: _context);
    }
  }

  // PUT
  Future<Map<String, dynamic>> put(
      {required String path,
      Map<String, dynamic>? data,
      Map<String, dynamic>? query,
      Options? options}) async {
    try {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      debugPrint('URL = ${AppUrls.baseUrl}$path');
      final response = await _dio.put(path,
          data: data,
          queryParameters: query,
          options: options ??
              Options(
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferencesHelper.getAuthToken()}',
                },
              ));
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
    Options? options,
  }) async {
    try {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      debugPrint('URL = ${AppUrls.baseUrl}$path');
      final response = await _dio.patch(path,
          data: data,
          queryParameters: query,
          options: options ??
              Options(
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferencesHelper.getAuthToken()}',
                },
              ));

      return response.data;
    } on DioException catch (e) {
      throw _createErrorEntity(e);
    }
  }

  // delete
  Future delete(
      {required String path,
      Map<String, dynamic>? data,
      Map<String, dynamic>? query,
      Options? options,
      required BuildContext context}) async {
    try {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      debugPrint('URL = ${AppUrls.baseUrl}$path');
      final response = await _dio.delete(path,
          data: data,
          queryParameters: query,
          options: options ??
              Options(
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferencesHelper.getAuthToken()}',
                },
              ));
      if (response.statusCode != 200) {
        debugPrint("Errorr!!!! ${response.data}");
        return showSnackBar(
            context: context,
            title: response.statusMessage ?? '${AppLocalizations.of(context)!.something_is_wrong_try_again}',
            bgColor: AppColors.redColor);
      } else {
        return response.data as Map<String, dynamic>;
      }
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

ErrorEntity _createErrorEntity(DioException error, {BuildContext? context}) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    //   showSnackBar(context: context, title: title, bgColor: bgColor);
      showSnackBar(
          context: context!,
          title: '${AppLocalizations.of(context)!.connection_timed_out}',
          bgColor: AppColors.redColor);
      return ErrorEntity(code: -1, message: '${AppLocalizations.of(context)!.connection_timed_out}');

    case DioExceptionType.sendTimeout:
      showSnackBar(
          context: context!,
          title: '${AppLocalizations.of(context)!.send_timed_out}',
          bgColor: AppColors.redColor);
      return ErrorEntity(code: -1, message: '${AppLocalizations.of(context)!.send_timed_out}',);

    case DioExceptionType.receiveTimeout:
      showSnackBar(
          context: context!,
          title: '${AppLocalizations.of(context)!.receive_timed_out}',
          bgColor: AppColors.redColor);
      return ErrorEntity(code: -1, message: '${AppLocalizations.of(context)!.receive_timed_out}');

    case DioExceptionType.badCertificate:
      showSnackBar(
          context: context!,
          title: '${AppLocalizations.of(context)!.bad_ssl_certificates}',
          bgColor: AppColors.redColor);
      return ErrorEntity(code: -1, message: '${AppLocalizations.of(context)!.bad_ssl_certificates}');

    case DioExceptionType.badResponse:
      switch (error.response!.statusCode) {
        case 400:
          showSnackBar(
              context: context!,
              title: '${AppLocalizations.of(context)!.bad_request}',
              bgColor: AppColors.redColor);
          return ErrorEntity(code: 400, message: '${AppLocalizations.of(context)!.bad_request}');
        case 401:
          showSnackBar(
              context: context!,
              title: '${AppLocalizations.of(context)!.permission_denied}',
              bgColor: AppColors.redColor);
          return ErrorEntity(code: 401, message: '${AppLocalizations.of(context)!.permission_denied}');
        case 500:
          showSnackBar(
              context: context!,
              title: '${AppLocalizations.of(context)!.server_internal_error}',
              bgColor: AppColors.redColor);
          return ErrorEntity(code: 500, message: '${AppLocalizations.of(context)!.server_internal_error}');
      }
      showSnackBar(
          context: context!,
          title: '${AppLocalizations.of(context)!.server_bad_response}',
          bgColor: AppColors.redColor);
      return ErrorEntity(
          code: error.response!.statusCode!, message: '${AppLocalizations.of(context)!.server_bad_response}');

    case DioExceptionType.cancel:
      showSnackBar(
          context: context!,
          title:'${AppLocalizations.of(context)!.server_canceled}',
          bgColor: AppColors.redColor);
      return ErrorEntity(code: -1, message: '${AppLocalizations.of(context)!.server_canceled}');

    case DioExceptionType.connectionError:
/*      showSnackBar(
          context: context,
          title: "Connection error",
          bgColor: AppColors.redColor);*/
      return ErrorEntity(code: -1, message: "Connection error");

    case DioExceptionType.unknown:
      showSnackBar(
          context: context!,
          title: '${AppLocalizations.of(context)!.unknown_error}',
          bgColor: AppColors.redColor);
      return ErrorEntity(code: -1, message: '${AppLocalizations.of(context)!.unknown_error}');
  }
}

void onError(ErrorEntity eInfo) {
  debugPrint('error.code -> ${eInfo.code}, error.message -> ${eInfo.message}');
  switch (eInfo.code) {
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
