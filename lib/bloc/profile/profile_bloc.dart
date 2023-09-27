
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_constants.dart';
part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  ProfileBloc() : super(ProfileState.initial()) {
    on<ProfileEvent>((event, emit) async {

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
         if(event.selectedBusiness.isEmpty){
           showSnackBar(event.context,'enter type of business');
         }
        else if(event.businessName.isEmpty){
           showSnackBar(event.context , 'enter businessName name');
         }
         else  if(event.hp.isEmpty){
           showSnackBar(event.context , 'enter hp');
         }
         else  if(event.owner.isEmpty){
           showSnackBar(event.context , 'enter owner');
         }
         else  if(event.id.isEmpty){
           showSnackBar(event.context , 'enter id');
         }
         else if(event.contact.isEmpty){
           showSnackBar(event.context , 'enter contact');
         }
         else{
           Navigator.pushNamed(event.context, RouteDefine.moreDetailsScreen.name);
         }
      }

      if (event is _profilePicFromCameraEvent) {
      File? image;
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(state.copyWith(image: image));
      }
      }

     if (event is _profilePicFromGalleryEvent) {
       File? image;
       final picker = ImagePicker();
       final pickedFile = await picker.pickImage(source: ImageSource.gallery);
       if (pickedFile != null) {
         image = File(pickedFile.path);
         emit(state.copyWith(image: image));
       }
     }
    });
  }


}

