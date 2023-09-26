import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_styles.dart';

part 'profile3_bloc.freezed.dart';

part 'profile3_event.dart';

part 'profile3_state.dart';

class Profile3Bloc extends Bloc<Profile3Event, Profile3State> {

  Profile3Bloc() : super(Profile3State.initial()) {
    on<Profile3Event>((event, emit)  async {


      if (event is _textFieldValidateEvent) {
        if(event.city.isEmpty){
          ScaffoldMessenger.of(event.context).showSnackBar(
              const SnackBar(
                content: Text('enter city'),
              )
          );
        }
        else if(event.address.isEmpty){
          ScaffoldMessenger.of(event.context).showSnackBar(
              SnackBar(
                content: Text('enter address',style: AppStyles.rkRegularTextStyle(size: 14,color: AppColors.blackColor),
                ),backgroundColor: Colors.deepOrange,
              )
          );
        }
        else  if(event.email.isEmpty){
          ScaffoldMessenger.of(event.context).showSnackBar(
              const SnackBar(
                content: Text('enter email'),
              )
          );
        }
        else  if(event.fax.isEmpty){
          ScaffoldMessenger.of(event.context).showSnackBar(
              const SnackBar(
                content: Text('enter fax'),
              )
          );
        }
        else  if(event.image.path == ''){
          ScaffoldMessenger.of(event.context).showSnackBar(
              const SnackBar(
                content: Text('upload image'),
              )
          );
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
