import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/product_details/product_details_model.dart';
import '../../ui/utils/themes/app_img_path.dart';

part 'basket_event.dart';
part 'basket_state.dart';
part 'basket_bloc.freezed.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  BasketBloc() : super( BasketState.initial()) {
    on<BasketEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
