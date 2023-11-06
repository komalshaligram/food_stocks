import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/req_model/suppliers_req_model/suppliers_req_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/res_model/suppliers_res_model/suppliers_res_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'supplier_event.dart';

part 'supplier_state.dart';

part 'supplier_bloc.freezed.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  SupplierBloc() : super(SupplierState.initial()) {
    on<SupplierEvent>((event, emit) async {
      if (event is _GetSuppliersListEvent) {
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfSuppliers) {
          return;
        }
        try {
          emit(state.copyWith(
              isShimmering: state.pageNum == 0 ? true : false,
              isLoadMore: state.pageNum == 0 ? false : true));
          final res = await DioClient(event.context).post(
              AppUrls.getSuppliersUrl,
              data: SuppliersReqModel(
                      pageNum: state.pageNum + 1,
                      pageLimit: AppConstants.supplierPageLimit)
                  .toJson());
          SuppliersResModel response = SuppliersResModel.fromJson(res);
          if (response.status == 200) {
            List<Datum> supplierList =
                state.suppliersList.toList(growable: true);
            supplierList.addAll(response.data ?? []);
            debugPrint('new supplier list len = ${supplierList.length}');
            emit(state.copyWith(
                suppliersList: supplierList,
                pageNum: state.pageNum + 1,
                isLoadMore: false,
                isShimmering: false));
            emit(state.copyWith(
                isBottomOfSuppliers: state.suppliersList.length ==
                        (response.metaData?.totalRecords ?? 0)
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
      }
    });
  }
}
