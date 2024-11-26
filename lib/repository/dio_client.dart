import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import 'package:provider/provider.dart';

import '../../ui/widget/no_internet_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/res_model/refresh_token/refresh_token_model.dart';
import '../data/services/locale_provider.dart';
import '../ui/utils/themes/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DioClient {
  final Dio _dio;
  late final BuildContext _context;
  bool isLogOut = false;
  bool isLoggedIn = true;
  bool isInProgress = false;
  DioClient(this._context)
      : _dio = Dio(
          BaseOptions(
              baseUrl: AppUrlEndPoints.baseUrl,
              connectTimeout: Duration(milliseconds: AppConstants.timeOutDuration.toInt()),
              receiveTimeout: Duration(milliseconds: AppConstants.timeOutDuration.toInt()),
              headers: {
                HttpHeaders.acceptHeader: Headers.jsonContentType,
                HttpHeaders.authorizationHeader: 'Bearer ',
              },
              validateStatus: (status) {
                if (status == AppConstants.code_401) {
                  return false;
                } else {
                  return true;
                }
              },
              contentType: Headers.jsonContentType,
              responseType: ResponseType.json),
        )..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
            //  printData("app request data ${options.data}");
            return handler.next(options);
          }, onResponse: (response, handler) async {
            if (kDebugMode) {
              printData("app response data ${response.data}");
            }
            return handler.next(response);
          }, onError: (DioException e, handler) {
            if (kDebugMode) {
              printData("app error data $e");
            }
            return handler.next(e);
          }));

  Future post(String path, {Object? data, Map<String, dynamic>? queryParameters, Options? options}) async {
    SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
    final connectivityResult = await (Connectivity().checkConnectivity());
    preferencesHelper.setApiUrl(apiUrl: path);
    printData('URL = ${AppUrlEndPoints.baseUrl}$path');
    printData('token = ${preferencesHelper.getAuthToken()}');
    printData('req:${data.toString()}');
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.ethernet) {
      try {
        Options requestOptions = options ?? Options(headers: {HttpHeaders.authorizationHeader: 'Bearer ${preferencesHelper.getAuthToken()}'});
        requestOptions.headers = requestOptions.headers ?? {};
        var response = await _dio.post(path, data: data, queryParameters: queryParameters, options: requestOptions);
        printData("$path: RES: ${response.toString()}");
        isInProgress = false;
        return response.data;
      } on DioException catch (e) {
        if (e.response?.statusCode == AppConstants.code_401 && path != AppUrlEndPoints.refreshTokenUrl) {
          return tokenExpirationWork(path, data, preferencesHelper, AppStrings.postMethod, queryParameters ?? {});
        } else if (path == AppUrlEndPoints.refreshTokenUrl && e.response?.statusCode == AppConstants.code_401) {
          return manageRefreshTokenWork(preferencesHelper, queryParameters ?? {});
        } else {
          throw _createErrorEntity(e, context: _context);
        }
      }
    } else {
      showDialog(
        context: _context,
        builder: (context) => NoInternetDialog(positiveOnTap: () {
          Navigator.pop(context);
        }),
      );
    }
  }

  tokenExpirationWork(String path, Object? data, SharedPreferencesHelper preferencesHelper, String type, Map<String, dynamic> queryParams) async {
    ///save data of expire api
    preferencesHelper.setApiUrl(apiUrl: path);
    preferencesHelper.setReqPram(reqPram: jsonEncode(data));

    final response = await post(AppUrlEndPoints.refreshTokenUrl, data: {"token": 'Bearer ${preferencesHelper.getRefreshToken()}'});

    RefreshTokenModel res = RefreshTokenModel.fromJson(response);
    printData('[refreshToken token] ${res.data?.accessToken}');

    if (res.status == AppConstants.code_200) {
      return manageAccessTokenWork(preferencesHelper, res, type, queryParams, path, data);
    }
    if (res.status == AppConstants.code_401) {
      //logout work
      return manageRefreshTokenWork(preferencesHelper, queryParams);
    }
  }

  manageAccessTokenWork(SharedPreferencesHelper preferencesHelper, dynamic res, String type, Map<String, dynamic> queryParams, String path, Object? data) async {
    preferencesHelper.setUserLoggedIn(isLoggedIn: true);
    preferencesHelper.setAuthToken(accToken: res.data?.accessToken ?? '');
    preferencesHelper.setRefreshToken(refToken: res.data?.refreshToken ?? '');
    printData('accessToken_____${res.data?.accessToken ?? ''}');
    Options requestOptions = Options(headers: {HttpHeaders.authorizationHeader: 'Bearer ${preferencesHelper.getAuthToken()}'});
    requestOptions.headers = requestOptions.headers ?? {};
    var response;
    switch (type) {
      case "GET":
        response = await _dio.get(path, queryParameters: queryParams, options: requestOptions);
        break;
      case "POST":
        response = await _dio.post(
          path,
          data: data,
          options: requestOptions,
          queryParameters: queryParams,
        );
        break;
      case "PUT":
        response = await _dio.put(
          path,
          data: data,
          options: requestOptions,
          queryParameters: queryParams,
        );
        break;
    }
    printData('res_______________________$response');
    return response.data;
  }

  void manageRefreshTokenWork(SharedPreferencesHelper preferencesHelper, Map<String, dynamic> queryParams) async {
    var response = await _dio.put(AppUrlEndPoints.logOutUrl, data: {"userId": preferencesHelper.getUserId()});

    if (response.statusCode == AppConstants.code_200 && !isLogOut) {
      isLogOut = true;
      await preferencesHelper.setUserLoggedIn();
      printData('Token Expired = ${response.data}');
      await Provider.of<LocaleProvider>(_context, listen: false).setAppLocale(locale: const Locale(AppStrings.hebrewString));
      Navigator.popUntil(_context, (route) => route.name == RouteDefine.bottomNavScreen.name);
      Navigator.pushNamed(_context, RouteDefine.connectScreen.name);
      ScaffoldMessenger.of(_context).hideCurrentSnackBar();
      CustomSnackBar.showSnackBar(context: _context, title: AppLocalizations.of(_context)!.logged_out_successfully, type: SnackBarType.success);
    }
  }

  // GET
  Future get({required String path, Map<String, dynamic>? query, Options? options}) async {
    try {
      isInProgress = true;
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      printData('URL = ${AppUrlEndPoints.baseUrl}$path');
      printData('token = ${preferencesHelper.getAuthToken()}');
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.ethernet) {
        try {
          final response = await _dio.get(path, queryParameters: query, options: options ?? Options(headers: {HttpHeaders.authorizationHeader: 'Bearer ${preferencesHelper.getAuthToken()}'}));
          printData("$path: RES: ${response.toString()}");
          isInProgress = false;
          return response.data as Map<String, dynamic>;
        } on DioException catch (e) {
          if (e.response?.statusCode == AppConstants.code_401 && path != AppUrlEndPoints.refreshTokenUrl) {
            return tokenExpirationWork(path, null, preferencesHelper, AppStrings.getMethod, query ?? {});
          } else if (path == AppUrlEndPoints.refreshTokenUrl && e.response?.statusCode == AppConstants.code_401) {
            return manageRefreshTokenWork(preferencesHelper, query ?? {});
          } else {
            throw _createErrorEntity(e, context: _context);
          }
        }
      } else {
        showDialog(
          context: _context,
          builder: (context) => NoInternetDialog(positiveOnTap: () {
            Navigator.pop(context);
          }),
        );
        throw Exception("Network Error");
      }
    } on DioException catch (e) {
      throw _createErrorEntity(e);
    }
  }

  Future<Map<String, dynamic>> uploadFileProgressWithFormData({required String path, required FormData formData}) async {
    try {
      printData('URL = ${AppUrlEndPoints.baseUrl}$path');
      final response = await _dio.post(
        path,
        data: formData,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _createErrorEntity(e, context: _context);
    }
  }

  // PUT
  Future put({required String path, Map<String, dynamic>? data, Map<String, dynamic>? query, Options? options}) async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.ethernet) {
        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
        try {
          printData('URL = ${AppUrlEndPoints.baseUrl}$path');
          printData('token = ${preferencesHelper.getAuthToken()}');
          printData('req:${data.toString()}');
          final response = await _dio.put(path,
              data: data,
              queryParameters: query,
              options: options ??
                  Options(
                    headers: {
                      HttpHeaders.authorizationHeader: 'Bearer ${preferencesHelper.getAuthToken()}',
                    },
                  ));
          printData('$path: res:${response.data.toString()}');
          return response.data;
        } on DioException catch (e) {
          if (e.response?.statusCode == AppConstants.code_401 && path != AppUrlEndPoints.refreshTokenUrl) {
            return tokenExpirationWork(path, data, preferencesHelper, AppStrings.putMethod, query ?? {});
          } else if (path == AppUrlEndPoints.refreshTokenUrl && e.response?.statusCode == AppConstants.code_401) {
            return manageRefreshTokenWork(preferencesHelper, query ?? {});
          } else {
            throw _createErrorEntity(e, context: _context);
          }
        }
      } else {
        printData('error');
        showDialog(
          context: _context,
          builder: (context) => NoInternetDialog(positiveOnTap: () {
            Navigator.pop(context);
          }),
        );
        throw Exception("Network Error");
        //  }
      }
    } on DioException catch (e) {
      throw _createErrorEntity(e);
    }
  }

  //delete
  Future delete({required String path, Map<String, dynamic>? data, Map<String, dynamic>? query, Options? options}) async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.ethernet) {
        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
        try {
          printData('URL = ${AppUrlEndPoints.baseUrl}$path');
          printData('token = ${preferencesHelper.getAuthToken()}');
          printData('req:${data.toString()}');
          final response = await _dio.delete(path,
              data: data,
              options: options ??
                  Options(
                    headers: {
                      HttpHeaders.authorizationHeader: 'Bearer ${preferencesHelper.getAuthToken()}',
                    },
                  ));
          return response.data;
        } on DioException catch (e) {
          if (e.response?.statusCode == AppConstants.code_401 && path != AppUrlEndPoints.refreshTokenUrl) {
            return tokenExpirationWork(path, data, preferencesHelper, AppStrings.putMethod, query ?? {});
          } else if (path == AppUrlEndPoints.refreshTokenUrl && e.response?.statusCode == AppConstants.code_401) {
            return manageRefreshTokenWork(preferencesHelper, query ?? {});
          } else {
            throw _createErrorEntity(e, context: _context);
          }
        }
      } else {
        printData('error');
        showDialog(
          context: _context,
          builder: (context) => NoInternetDialog(positiveOnTap: () {
            Navigator.pop(context);
          }),
        );
        throw Exception("Network Error");
        //  }
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
      CustomSnackBar.showSnackBar(context: context!, title: AppLocalizations.of(context)!.connection_timed_out, type: SnackBarType.failure);
      return ErrorEntity(code: -1, message: AppLocalizations.of(context)!.connection_timed_out);

    case DioExceptionType.sendTimeout:
      CustomSnackBar.showSnackBar(context: context!, title: AppLocalizations.of(context)!.send_timed_out, type: SnackBarType.failure);
      return ErrorEntity(
        code: -1,
        message: AppLocalizations.of(context)!.send_timed_out,
      );

    case DioExceptionType.receiveTimeout:
      CustomSnackBar.showSnackBar(context: context!, title: AppLocalizations.of(context)!.receive_timed_out, type: SnackBarType.failure);
      return ErrorEntity(code: -1, message: AppLocalizations.of(context)!.receive_timed_out);

    case DioExceptionType.badCertificate:
      CustomSnackBar.showSnackBar(context: context!, title: AppLocalizations.of(context)!.bad_ssl_certificates, type: SnackBarType.failure);
      return ErrorEntity(code: -1, message: AppLocalizations.of(context)!.bad_ssl_certificates);

    case DioExceptionType.badResponse:
      switch (error.response!.statusCode) {
        case 400:
          CustomSnackBar.showSnackBar(context: context!, title: AppLocalizations.of(context)!.bad_request, type: SnackBarType.failure);
          return ErrorEntity(code: 400, message: AppLocalizations.of(context)!.bad_request);
        case 401:
          CustomSnackBar.showSnackBar(context: context!, title: AppLocalizations.of(context)!.permission_denied, type: SnackBarType.failure);
          return ErrorEntity(code: 401, message: AppLocalizations.of(context)!.permission_denied);
        case 500:
          CustomSnackBar.showSnackBar(context: context!, title: AppLocalizations.of(context)!.server_internal_error, type: SnackBarType.failure);
          return ErrorEntity(code: 500, message: AppLocalizations.of(context)!.server_internal_error);
      }
      CustomSnackBar.showSnackBar(context: context!, title: AppLocalizations.of(context)!.server_bad_response, type: SnackBarType.failure);
      return ErrorEntity(code: error.response!.statusCode!, message: AppLocalizations.of(context)!.server_bad_response);

    case DioExceptionType.cancel:
      CustomSnackBar.showSnackBar(context: context!, title: AppLocalizations.of(context)!.server_canceled, type: SnackBarType.failure);
      return ErrorEntity(code: -1, message: AppLocalizations.of(context)!.server_canceled);

    case DioExceptionType.connectionError:
      CustomSnackBar.showSnackBar(context: context!, title: AppLocalizations.of(context)!.connection_error, type: SnackBarType.failure);
      return ErrorEntity(code: -1, message: AppLocalizations.of(context)!.connection_error);

    case DioExceptionType.unknown:
      CustomSnackBar.showSnackBar(context: context!, title: AppLocalizations.of(context)!.unknown_error, type: SnackBarType.failure);
      return ErrorEntity(code: -1, message: AppLocalizations.of(context)!.unknown_error);
  }
}

void onError(ErrorEntity eInfo) {
  printData('error.code -> ${eInfo.code}, error.message -> ${eInfo.message}');
  switch (eInfo.code) {
    case 400:
      printData("Server syntax error");
      break;
    case 401:
      printData("You are denied to continue");
      break;
    case 500:
      printData("Server internal error");
      break;
    default:
      printData("Unknown error");
      break;
  }
}
