
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

import '../../routes/app_routes.dart';

part 'profile_bloc.freezed.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  ProfileBloc() : super(ProfileState.initial()) {
    on<ProfileEvent>((event, emit) async {


     if (event is _textFieldValidateEvent) {
         if(event.selectedBusiness.isEmpty){
           ScaffoldMessenger.of(event.context).showSnackBar(
               const SnackBar(
                 content: Text('enter type of businessName'),
               )
           );
         }
     else if(event.businessName.isEmpty){
           ScaffoldMessenger.of(event.context).showSnackBar(
                SnackBar(

                 content: Text('enter businessName name',style: AppStyles.rkRegularTextStyle(size: 14,color: AppColors.blackColor),
                 ),backgroundColor: Colors.deepOrange,
               )
           );
         }
         else  if(event.hp.isEmpty){
           ScaffoldMessenger.of(event.context).showSnackBar(
               const SnackBar(
                 content: Text('enter hp'),
               )
           );
         }
         else  if(event.owner.isEmpty){
           ScaffoldMessenger.of(event.context).showSnackBar(
               const SnackBar(
                 content: Text('enter owner'),
               )
           );
         }
         else  if(event.id.isEmpty){
           ScaffoldMessenger.of(event.context).showSnackBar(
               const SnackBar(
                 content: Text('enter id'),
               )
           );
         }
         else if(event.contact.isEmpty){
           ScaffoldMessenger.of(event.context).showSnackBar(
               const SnackBar(
                 content: Text('enter contact'),
               )
           );
         }
         else{
           Navigator.pushNamed(event.context, RouteDefine.profileScreen3.name);
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

