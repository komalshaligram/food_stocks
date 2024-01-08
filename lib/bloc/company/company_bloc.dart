import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/res_model/company_res_model/company_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/company_req_model/company_req_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'company_event.dart';

part 'company_state.dart';

part 'company_bloc.freezed.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  CompanyBloc() : super(CompanyState.initial()) {
    on<CompanyEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _GetCompaniesListEvent) {
  emit(state.copyWith(language: preferencesHelper.getAppLanguage()));
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfCompanies) {
          return;
        }
        if (state.isShimmering) {
          return;
        }
        try {
          emit(state.copyWith(
              isShimmering: state.pageNum == 0 ? true : false,
              isLoadMore: state.pageNum == 0 ? false : true));
          print('state.search___${state.search}');
          final res = await DioClient(event.context).post(
              AppUrls.getCompaniesUrl,
              data: CompanyReqModel(
                      pageNum: state.pageNum + 1,
                      pageLimit: AppConstants.supplierPageLimit,
                      search: state.search)
                  .toJson());
          CompanyResModel response = CompanyResModel.fromJson(res);
          if (response.status == 200) {
            List<Brand> companiesList =
                state.companiesList.toList(growable: true);
            companiesList.addAll(response.data?.brandList ?? []);
            debugPrint('new company list len = ${companiesList.length}');
            emit(state.copyWith(
                companiesList: companiesList,
                pageNum: state.pageNum + 1,
                isLoadMore: false,
                isShimmering: false));
            emit(state.copyWith(
                isBottomOfCompanies: state.companiesList.length ==
                        (response.data?.totalRecords ?? 0)
                    ? true
                    : false));
          } else {
            emit(state.copyWith(isLoadMore: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.SUCCESS);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      } else if (event is _SetSearchEvent) {
        emit(state.copyWith(search: event.search));
      } else if (event is _RefreshListEvent) {
        emit(state.copyWith(
            pageNum: 0, companiesList: [], isBottomOfCompanies: false));
        add(CompanyEvent.getCompaniesListEvent(context: event.context));
      }
    });
  }
}
