import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/res_model/company_res_model/company_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/req_model/company_req_model/company_req_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'company_event.dart';

part 'company_state.dart';

part 'company_bloc.freezed.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  CompanyBloc() : super(CompanyState.initial()) {
    on<CompanyEvent>((event, emit) async {
      if (event is _GetCompaniesListEvent) {
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
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
      } else if (event is _SetSearchEvent) {
        emit(state.copyWith(search: event.search));
      }
    });
  }
}
