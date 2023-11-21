import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/req_model/get_app_content_req_model/get_app_content_req_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/res_model/get_app_content_res_model/get_app_content_res_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'menu_event.dart';

part 'menu_state.dart';

part 'menu_bloc.freezed.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuState.initial()) {
    on<MenuEvent>((event, emit) async {
      if (event is _GetAppContentListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getAllAppContentsUrl,
              data: GetAppContentReqModel(
                      pageNum: 1, pageLimit: AppConstants.appContentPageLimit)
                  .toJson());
          GetAppContentResModel response = GetAppContentResModel.fromJson(res);
          if (response.status == 200) {
            List<Content> contentList =
                state.contentList.toList(growable: true);
            contentList.addAll(response.contents
                    ?.map((content) => Content(
                          id: content.id,
                          contentName: content.contentName,
                        ))
                    .toList() ??
                []);
            debugPrint('new app content list len = ${contentList.length}');
            emit(state.copyWith(contentList: contentList, isShimmering: false));
          } else {
            emit(state.copyWith(isShimmering: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        }
      }
    });
  }
}
