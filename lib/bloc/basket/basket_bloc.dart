import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/order_model/product_details_model.dart';
import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'basket_event.dart';
part 'basket_state.dart';
part 'basket_bloc.freezed.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  BasketBloc() : super(BasketState.initial()) {
    on<BasketEvent>((event, emit) async {

      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getAllCartEvent) {
        debugPrint('cartId____${preferencesHelper.getCartId()}');

        emit(state.copyWith(
            isShimmering: true,
            language: preferencesHelper.getAppLanguage(),
            cartCount: preferencesHelper.getCartCount()));
        try {
          final res = await DioClient(event.context).post(
            '${AppUrls.getAllCartUrl}${preferencesHelper.getCartId()}',
          );

          GetAllCartResModel response = GetAllCartResModel.fromJson(res);

          if (response.status == 200) {
            emit(state.copyWith(CartItemList: response, isShimmering: false));
            List<ProductDetailsModel> temp = [];
            state.CartItemList.data!.data!.forEach((element) {
              temp.add(ProductDetailsModel(
                totalQuantity: element.totalQuantity,
                productName: element.productDetails!.productName!,
                mainImage: element.productDetails!.mainImage!,
                totalPayment: double.parse(element.totalAmount!.toString()),
                cartProductId: element.cartProductId!,
                scales: element.productDetails!.scales!,
                weight: element.productDetails!.itemsWeight!,
              ));
            });

            await preferencesHelper.setCartCount(
                count: temp.isEmpty
                    ? preferencesHelper.getCartCount()
                    : temp.length);
            emit(state.copyWith(
                basketProductList: temp,
                isRefresh: !state.isRefresh,
                totalPayment: response.data!.cart!.first.totalAmount!));
          } else {
            emit(state.copyWith(CartItemList: response, isShimmering: false));
          }
        } on ServerException {}
      } else if (event is _productUpdateEvent) {
        List<ProductDetailsModel> list = [];
        list = [...state.basketProductList];
        list[event.listIndex].isProcess = true;

        emit(state.copyWith(isLoading: true, basketProductList: list));

        try {
          UpdateCartReqModel reqMap = UpdateCartReqModel();
          if (event.saleId != '') {
            reqMap = UpdateCartReqModel(
                supplierId: event.supplierId,
                quantity: event.productWeight,
                productId: event.productId,
                cartProductId: event.cartProductId,
                saleId: event.saleId);
          } else {
            reqMap = UpdateCartReqModel(
              supplierId: event.supplierId,
              quantity: event.productWeight,
              productId: event.productId,
              cartProductId: event.cartProductId,
            );
          }

          final res = await DioClient(event.context).post(
            '${AppUrls.updateCartProductUrl}${preferencesHelper.getCartId()}',
            data: reqMap,
          );

          UpdateCartResModel response = UpdateCartResModel.fromJson(res);

          if (response.status == 201) {
            List<ProductDetailsModel> list = [];
            list = [...state.basketProductList];
            int quantity = list[event.listIndex].totalQuantity!;
            double payment = list[event.listIndex].totalPayment!;
            list[event.listIndex].totalQuantity =
                response.data!.cartProduct!.quantity;
            list[event.listIndex].totalPayment =
                ((payment / quantity) * response.data!.cartProduct!.quantity!);
            double newAmount = (payment / quantity);
            double totalAmount = 0;
            if (list[event.listIndex].totalPayment! > payment) {
              totalAmount = event.totalPayment + newAmount;
              await preferencesHelper.setIsAnimation(isAnimation: true);
            } else {
              totalAmount = event.totalPayment - newAmount;
            }
            list[event.listIndex].isProcess = false;
            emit(state.copyWith(
              basketProductList: list,
              totalPayment: totalAmount,
              isLoading: false,
            ));
          } else {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.FAILURE);
          }

        } on ServerException {    emit(state.copyWith(isLoading: false));}
      } else if (event is _removeCartProductEvent) {
        emit(state.copyWith(isRemoveProcess: true));
        try {
          final player = AudioPlayer();
          final response = await DioClient(event.context).post(
            AppUrls.removeCartProductUrl,
            data: {AppStrings.cartProductIdString: event.cartProductId},
          );
          if (response['status'] == 200) {
            Navigator.pop(event.dialogContext);
            player.play(AssetSource('audio/delete_sound.mp3'));
            add(BasketEvent.setCartCountEvent(isClearCart: false));
            List<ProductDetailsModel> list = [];
            list = [...state.basketProductList];
            list.removeAt(event.listIndex);
            emit(state.copyWith(
                basketProductList: list,
                isRefresh: !state.isRefresh,
                totalPayment: state.totalPayment - event.totalAmount,
              isRemoveProcess: false,
            ));
            add(BasketEvent.getAllCartEvent(context: event.context));

          } else {
            Navigator.pop(event.dialogContext);
            emit(state.copyWith(
              isRemoveProcess: false,
            ));
          }
        } on ServerException {
          emit(state.copyWith(
            isRemoveProcess: false,
          ));
          Navigator.pop(event.dialogContext);}
      }
      else if (event is _clearCartEvent) {
        emit(state.copyWith(isRemoveProcess: true));
        try {
          final res = await DioClient(event.context)
              .post('${AppUrls.clearCartUrl}${preferencesHelper.getCartId()}');
          if (res["status"] == 201) {
            add(BasketEvent.setCartCountEvent(isClearCart: true));
            List<ProductDetailsModel> list = [];
            list = [...state.basketProductList];
            list.clear();
            Navigator.pop(event.context);
            emit(state.copyWith(
                basketProductList: list, isRefresh: !state.isRefresh,isRemoveProcess: false));
          } else {
            Navigator.pop(event.context);
            emit(state.copyWith(isRemoveProcess: false));
          }
        } on ServerException {
          Navigator.pop(event.context);
          emit(state.copyWith(isRemoveProcess: false));
        }
      } else if (event is _SetCartCountEvent) {

        await preferencesHelper.setCartCount(
            count: event.isClearCart ? 0 : preferencesHelper.getCartCount() - 1);

      } else if (event is _updateImageIndexEvent) {
        emit(state.copyWith(productImageIndex: event.index));
      }
     else if(event is _refreshListEvent) {
       Navigator.pop(event.context);
     emit(state.copyWith(CartItemList: state.CartItemList));
}

});
  }
}
