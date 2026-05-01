import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/model/res_model/supplier_list_products_response_model/supplier_list_products_response_model.dart';
part 'supplier_brand_event.dart';
part 'supplier_brand_state.dart';
part 'supplier_brand_bloc.freezed.dart';

class SupplierBrandBloc extends Bloc<SupplierBrandEvent, SupplierBrandState> {
  SupplierBrandBloc() : super(SupplierBrandState.initial()) {
    on<SupplierBrandEvent>((event, emit) async {
      if (event is _initEvent) {
        emit(state.copyWith(isShimmering: true));
        await Future.delayed(const Duration(milliseconds: 300));
        emit(state.copyWith(brandsList: event.brandList, isShimmering: false));
        state.refreshController.refreshCompleted();
      } else if (event is _refreshEvent) {
        emit(state.copyWith(isShimmering: true, brandsList: []));
        await Future.delayed(const Duration(milliseconds: 300));
        emit(state.copyWith(brandsList: event.brandList, isShimmering: false));
        state.refreshController.refreshCompleted();
      }
    });
  }
}
