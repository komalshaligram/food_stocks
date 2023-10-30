import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/model/order_model/product_details_model.dart';
import '../../ui/utils/themes/app_img_path.dart';

part 'basket_event.dart';
part 'basket_state.dart';
part 'basket_bloc.freezed.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  BasketBloc() : super( BasketState.initial()) {
    on<BasketEvent>((event, emit) {

      if(event is _getDataEvent){
        emit(state.copyWith(isShimmering: true));


      }

      if(event is _productIncrementEvent){
        List<ProductDetailsModel> temp = state.basketProductList;
        temp[event.listIndex].productWeight = event.productWeight + 1;
        emit(state.copyWith(basketProductList: temp,isRefresh: !state.isRefresh));
      }

     else if(event is _productDecrementEvent){
        List<ProductDetailsModel> temp = state.basketProductList;
        if(event.productWeight > 0){
          temp[event.listIndex].productWeight = event.productWeight - 1;
        }
        else{

        }

        emit(state.copyWith(basketProductList: temp,isRefresh: !state.isRefresh));
      }
    else  if(event is _deleteListItemEvent){
        List<ProductDetailsModel> temp = [];
        temp.addAll(state.basketProductList);
        temp.removeAt(event.listIndex);
        showSnackBar(context: event.context, title: 'Item delete', bgColor: AppColors.mainColor);
        emit(state.copyWith(basketProductList: temp,isRefresh: !state.isRefresh));

      }

    });
  }
}
