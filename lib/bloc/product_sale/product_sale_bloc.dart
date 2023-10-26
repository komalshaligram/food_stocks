import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/res_model/product_sales_res_model/product_sales_res_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'product_sale_event.dart';

part 'product_sale_state.dart';

part 'product_sale_bloc.freezed.dart';

class ProductSaleBloc extends Bloc<ProductSaleEvent, ProductSaleState> {
  ProductSaleBloc() : super(ProductSaleState.initial()) {
    on<ProductSaleEvent>((event, emit) async {
      if (event is _GetProductSalesListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res =
              await DioClient(event.context).post(AppUrls.getSaleProductsUrl);
          ProductSalesResModel response = ProductSalesResModel.fromJson(res);
          debugPrint('product sales = ${response.data}');
          if (response.status == 200) {
            emit(state.copyWith(
                productSalesList: response, isShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      }
    });
  }
}
