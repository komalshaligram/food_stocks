import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_styles.dart';

part 'more_details_bloc.freezed.dart';

part 'more_details_event.dart';

part 'more_details_state.dart';

class MoreDetailsBloc extends Bloc<MoreDetailsEvent, MoreDetailsState> {

  MoreDetailsBloc() : super(MoreDetailsState.initial()) {
    on<MoreDetailsEvent>((event, emit)  async {

      void showSnackBar(BuildContext context , String title) {
        final snackBar = SnackBar(
          content: Text(title,
          style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont , color: AppColors.whiteColor,fontWeight: FontWeight.w400),
          ),
          backgroundColor: AppColors.redColor,
          padding: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      if (event is _textFieldValidateEvent) {
        if(event.city.isEmpty){
          showSnackBar(event.context , 'enter city');
        }
        else if(event.address.isEmpty){
          showSnackBar(event.context , 'enter address');
        }
        else  if(event.email.isEmpty){
          showSnackBar(event.context , 'enter email');
        }
        else  if(event.fax.isEmpty){
          showSnackBar(event.context , 'enter fax');
        }
        else  if(event.image.path == ''){
          showSnackBar(event.context , 'upload photo');
        }

        else{
          Navigator.pushNamed(event.context, RouteDefine.operationTimeScreen.name);
        }
      }


           if (event is _logoFromCameraEvent)  {
        File? image;
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          image = File(pickedFile.path);
          emit(state.copyWith(image: image,isImagePick: true));
        }
      }

      if (event is _logoFromGalleryEvent)  {
        File? image;
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          image = File(pickedFile.path);
          emit(state.copyWith(image: image,isImagePick: true));
        }
      }
    });
  }
}
