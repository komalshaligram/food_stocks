import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/res_model/get_app_content_details_res_model/get_app_content_details_res_model.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'app_content_event.dart';

part 'app_content_state.dart';

part 'app_content_bloc.freezed.dart';

class AppContentBloc extends Bloc<AppContentEvent, AppContentState> {
  AppContentBloc() : super(AppContentState.initial()) {
    on<AppContentEvent>((event, emit) async {
      if (event is _GetAppContentDetailsEvent) {
        try {
          emit(state.copyWith(
              contentName: event.appContentName, isShimmering: true));
          final res = await DioClient(event.context)
              .get(path: "${AppUrls.getAppContentUrl}${event.appContentId}");
          GetAppContentDetailsResModel response =
              GetAppContentDetailsResModel.fromJson(res);
          if (response.status == 200) {
            emit(state.copyWith(
                appContentDetails: response.data?.first ?? Datum(),
                isShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      }
    });
  }
}
