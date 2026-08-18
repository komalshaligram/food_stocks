import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../data/model/req_model/suppliers_req_model/suppliers_req_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/suppliers_list_response_model/suppliers_list_response_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
part 'supplier_event.dart';

part 'supplier_state.dart';

part 'supplier_bloc.freezed.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  SupplierBloc() : super(SupplierState.initial()) {
    on<SupplierEvent>((event, emit) async {
      if (event is _getSuppliersListEvent) {
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfSuppliers) {
          return;
        }
        try {
          emit(state.copyWith(isShimmering: state.pageNum == 0 ? true : false, isLoadMore: state.pageNum == 0 ? false : true));
          final res = await DioClient(event.context).post(AppUrlEndPoints.getSuppliersList,
              data: SuppliersReqModel(pageNum: state.pageNum + 1, pageLimit: AppConstants.supplierPageLimit, search: state.search).toJson());
          SuppliersListResponseModel response = SuppliersListResponseModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(
                suppliersDataList: response.data?.supplierList ?? [],
                pageNum: state.pageNum + 1,
                isLoadMore: false,
                isShimmering: false,
                isBottomOfSuppliers: response.data?.supplierList?.length == (response.data?.totalRecords ?? 0)));
          } else {
            emit(state.copyWith(isLoadMore: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.success);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      } else if (event is _refreshListEvent) {
        emit(state.copyWith(pageNum: 0, suppliersDataList: [], isBottomOfSuppliers: false));
        add(SupplierEvent.getSuppliersListEvent(context: event.context));
      } else if (event is _setSearchEvent) {
        emit(state.copyWith(search: event.search));
      }
    });
  }
}
