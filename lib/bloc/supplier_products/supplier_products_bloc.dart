import 'package:bloc/bloc.dart';
import 'package:food_stock/data/model/res_model/supplier_products_res_model/supplier_products_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_products_event.dart';

part 'supplier_products_state.dart';

part 'supplier_products_bloc.freezed.dart';

class SupplierProductsBloc
    extends Bloc<SupplierProductsEvent, SupplierProductsState> {
  SupplierProductsBloc() : super(SupplierProductsState.initial()) {
    on<SupplierProductsEvent>((event, emit) {});
  }
}
