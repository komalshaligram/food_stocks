import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/product_details/product_details_model.dart';
import '../../ui/utils/themes/app_img_path.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';
part 'product_details_bloc.freezed.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super( ProductDetailsState.initial()) {
    on<ProductDetailsEvent>((event, emit) {
      if(event is _checkBoxEvent){
        emit(state.copyWith(isCheckBox: !state.isCheckBox));
      }
      if(event is _productProblemEvent){
        emit(state.copyWith(isProductProblem: !state.isProductProblem));
      }
    });
  }
}
