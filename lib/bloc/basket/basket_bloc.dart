import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/order_model/product_details_model.dart';
import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'basket_event.dart';
part 'basket_state.dart';
part 'basket_bloc.freezed.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  BasketBloc() : super( BasketState.initial()) {
    on<BasketEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(
          prefs: await SharedPreferences.getInstance());

   if(event is _getAllCartEvent){
        preferencesHelper.getCartId();
        emit(state.copyWith(isShimmering: true));
       try {
          final res = await DioClient(event.context).post(
              AppUrls.getAllCartUrl,
              data: {
                'id' : preferencesHelper.getCartId()
              },
          );
          GetAllCartResModel response = GetAllCartResModel.fromJson(res);
          debugPrint('GetAllCartResModel  = $response');

          if (response.status == 200) {

              emit(state.copyWith(CartItemList: response,isShimmering: false));

            showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
          } else {
            emit(state.copyWith(CartItemList: response , isShimmering : false));
            showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
          }
        }  on ServerException {}
      }

    else  if(event is _productUpdateEvent){
        try {
/*
         VerifyStockModel reqMap = VerifyStockModel(
           supplierId: [event.supplierId],
           quantity: event.productWeight + 1,
           productId: event.productId,

          );

          final res = await DioClient(event.context).post(
            AppUrls.verifyStockUrl,
            data: reqMap,
          );
         debugPrint('VerifyStock reqMap  = $reqMap');
         VerifyStockResModel response = VerifyStockResModel.fromJson(res);
          debugPrint('VerifyStockModel  = $response');
*/
        print('supplierId_____${event.supplierId}');
        print('productId_____${event.productId}');


          UpdateCartReqModel reqMap = UpdateCartReqModel(
            supplierId: event.supplierId,
            quantity: event.productWeight + 1,
            productId: event.productId,
            cartId: preferencesHelper.getCartId(),
          );

          final res = await DioClient(event.context).post(
            AppUrls.updateCartProductUrl,
            data: reqMap,
          );
          debugPrint('update cart reqMap  = $reqMap');
          debugPrint('update cart resMap  = $res');
        /*  VerifyStockResModel response = VerifyStockResModel.fromJson(res);
          debugPrint('VerifyStockModel  = $response');


          if (response.status == 200) {
            print('response.status____${response.status}');
           if(response.data!.stock!.first.message == 'Product quantity fulfilled')
             showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
             emit(state.copyWith(CartItemList: state.CartItemList,isRefresh: !state.isRefresh));
           }
          else {
            showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
          }*/
        }  on ServerException {}

      }

    else  if(event is _deleteListItemEvent){
        List<ProductDetailsModel> temp = [];
      //  temp.addAll(state.basketProductList);
        temp.removeAt(event.listIndex);
        showSnackBar(context: event.context, title: 'Item delete', bgColor: AppColors.mainColor);
     //   emit(state.copyWith(basketProductList: temp,isRefresh: !state.isRefresh));

      }
   else if(event is _clearCartEvent){
     try {
       final res = await DioClient(event.context).post(
         AppUrls.clearCartUrl,
         data: {
           'id' : preferencesHelper.getCartId()
         },
       );

       debugPrint('clear cart response_______${res}');

       if (res["status"] == 201) {
         Navigator.pop(event.context);

       } else {
         showSnackBar(context: event.context, title: res['message'], bgColor: AppColors.mainColor);
       }
     }  on ServerException {}

   }


    });
  }
}
