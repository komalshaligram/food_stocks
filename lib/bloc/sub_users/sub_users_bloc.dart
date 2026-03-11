import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/get_sub_user/get_sub_user_req_model.dart';
import '../../data/model/res_model/get_all_sub_user/get_sub_user_res_model.dart';
import '../../data/model/res_model/verify_client_res_model/verify_client_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
part 'sub_users_event.dart';
part 'sub_users_state.dart';
part 'sub_users_bloc.freezed.dart';

class SubUsersBloc extends Bloc<SubUsersEvent, SubUsersState> {
  SubUsersBloc() : super(SubUsersState.initial()) {
    on<SubUsersEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getSubUserList) {
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfProducts) {
          return;
        }
        try {
          emit(state.copyWith(isShimmering: true));
          if (state.isPop) {
            emit(state.copyWith(subUserList: [], isPop: false));
          }

          GetSubUserReqModel req = GetSubUserReqModel(
            clientId: preferences.getUserId(),
            pageLimit: AppConstants.walletLimit,
            pageNum: state.pageNum + 1,
          );

          final res = await DioClient(event.context).post(
            AppUrlEndPoints.getAllSubUserUrl,
            data: req,
          );
          GetSubUserResModel response = GetSubUserResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            List<User> subUserList = state.subUserList.toList(growable: true);
            if ((response.data?.totalRecords ?? 1) > state.subUserList.length) {
              subUserList.addAll(response.data?.users ?? []);
              emit(state.copyWith(
                subUserList: subUserList,
                isShimmering: false,
                pageNum: state.pageNum + 1,
                isLoadMore: false,
              ));
              emit(state.copyWith(isBottomOfProducts: subUserList.length >= (response.data?.totalRecords ?? 0) ? true : false));
            } else {
              emit(state.copyWith(isShimmering: false, isLoadMore: false));
            }
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (e) {
          emit(state.copyWith(isShimmering: false));
        }
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      } else if (event is _RefreshListEvent) {
        emit(state.copyWith(pageNum: 0, subUserList: [], isBottomOfProducts: false));
        add(SubUsersEvent.getSubUserList(context: event.context));
      } else if (event is _userApproveEvent) {
        emit(state.copyWith(isBottomOfProducts: false, isPop: true, pageNum: 0));

        try {
          final res = await DioClient(event.context).post(AppUrlEndPoints.verifyClientUrl, data: {AppStrings.clientIdString: preferences.getUserId()});
          VerifyClientResModel response = VerifyClientResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            if (!(response.data?.isFilledForms ?? false) || !(response.data?.isRegisterForm ?? false)) {
              Navigator.pushNamed(event.context, RouteDefine.formDataScreen.name);
            } else if (!(response.data?.isUploadedFiles ?? false) && (response.data?.isRegisterForm ?? false) && (response.data?.isFilledForms ?? false)) {
              Navigator.pushNamed(event.context, RouteDefine.fileUploadScreen.name);
            } else {
              Navigator.pushNamed(event.context, RouteDefine.subUsersProfileScreen.name);
            }
          }
        } catch (_) {}
      }
    });
  }
}
