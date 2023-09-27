import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../routes/app_routes.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileRoute {
  static Widget get route => const ProfileScreen();
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: ProfileScreenWidget(con: context,),
    );
  }
}

class ProfileScreenWidget extends StatelessWidget {
  final BuildContext con;
   ProfileScreenWidget({required this.con,super.key});
  String temp = '';
  @override
  Widget build(BuildContext c) {
    final screenWidth = MediaQuery.of(c).size.width;
    final screenHeight = MediaQuery.of(c).size.height;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
            title: Text(
              AppLocalizations.of(context)!.business_details,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            backgroundColor: Colors.white,
            titleSpacing: 0,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.1, right: screenWidth * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 80,
                        width: screenWidth,
                        alignment: Alignment.center,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: AppColors.mainColor.withOpacity(0.1),
                          ),
                          child: state.image.path == ""
                              ? const Icon(Icons.person)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.file(File(state.image.path),
                                      fit: BoxFit.fill),
                                ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.44,
                        top: screenHeight * 0.07,
                        child: GestureDetector(
                            onTap: () {
                            //  alertDialog(con);
                              showDialog(
                                context: context,
                                builder:(c1) {
                                  return BlocBuilder<ProfileBloc, ProfileState>(
                                    builder: (c1, state) {
                                      return AlertDialog(
                                        title: Align(
                                            alignment: Alignment.center,
                                            child: Text(AppLocalizations.of(context)!.upload_photo)),
                                        actions: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                  onTap: (){
                                                    context
                                                        .read<ProfileBloc>()
                                                        .add(ProfileEvent.profilePicFromCameraEvent());
                                                    Navigator.pop(c1);
                                                  },
                                                  child: Icon(Icons.camera_alt_rounded)),
                                              GestureDetector(
                                                  onTap: (){
                                                    context
                                                        .read<ProfileBloc>()
                                                        .add(ProfileEvent.profilePicFromGalleryEvent());
                                                    Navigator.pop(c1);
                                                  },
                                                  child: Icon(Icons.photo)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(AppLocalizations.of(context)!.camera),
                                              Text(AppLocalizations.of(context)!.gallery),
                                            ],
                                          ),

                                        ],
                                      );
                                    },
                                  );
                                }, );
                            },
                            child: state.image.path == ""
                                ? Container(
                                    width: 29,
                                    height: 29,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: AppColors.borderColor)),
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      color: AppColors.blueColor,
                                      size: 18,
                                    ),
                                  )
                                : const SizedBox()),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: screenWidth,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.profile_picture,
                      style: AppStyles.rkRegularTextStyle(
                          size: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor),
                    ),
                  ),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.type_of_business,
                  ),
                  DropdownButtonFormField<String>(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    alignment: Alignment.bottomCenter,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8, right: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0),
                        borderSide: BorderSide(
                          color: AppColors.borderColor,
                        ),
                      ),
                    ),
                    isExpanded: true,
                    elevation: 0,
                    //  borderRadius: BorderRadius.circular(3),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    //dropdownColor: AppColors.mainColor.withOpacity(0.1),
                    value: state.selectedBusiness,
                    hint: const Text(
                      'select tag',
                    ),
                    items: state.institutionalList.map((tag) {
                      return DropdownMenuItem<String>(
                        value: tag,
                        child: Text(tag),
                      );
                    }).toList(),
                    onChanged: (tag) {
                      temp = state.selectedBusiness!;
                      temp = tag!;
                    },
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.business_name,
                  ),
                  CustomFormField(
                    controller: state.businessNameController,
                    keyboardType: TextInputType.text,
                    hint: AppLocalizations.of(context)!.life_grocery_store,
                    fillColor: Colors.transparent,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.hp,
                  ),
                  CustomFormField(
                    controller: state.hpController,
                    keyboardType: TextInputType.number,
                    hint: "152485",
                    fillColor: Colors.transparent,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.name_of_owner,
                  ),
                  CustomFormField(
                    controller: state.ownerController,
                    keyboardType: TextInputType.text,
                    hint: "ajsdjg",
                    fillColor: Colors.transparent,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.id,
                  ),
                  CustomFormField(
                    controller: state.idController,
                    keyboardType: TextInputType.number,
                    hint: "045896525",
                    fillColor: Colors.transparent,
                  ),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.contact,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  CustomFormField(
                    controller: state.contactController,
                    keyboardType: TextInputType.text,
                    hint: "text",
                    fillColor: Colors.transparent,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomButtonWidget(
                    buttonText: AppLocalizations.of(context)!.continued,
                    bGColor: AppColors.mainColor,
                    onPressed: () {
                      /*      context
                          .read<ProfileBloc>()
                          .add(ProfileEvent.textFieldValidateEvent(
                          businessName: state.businessNameController.text,
                      contact: state.contactController.text,
                      hp: state.hpController.text,
                      id: state.idController.text,
                      owner: state.ownerController.text,
                      selectedBusiness: state.selectedBusiness!,
                      context: context,
                      ));*/
                      Navigator.pushNamed(
                          context, RouteDefine.profileScreen3.name);
                    },
                    fontColors: AppColors.whiteColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


 /*  void alertDialog(BuildContext context , String image){

     showDialog(
       context: context,
       builder:(c1) {
         return BlocBuilder<ProfileBloc, ProfileState>(
           builder: (c1, state) {
             image = state.image.path;
             print('dialog_____${state.image.path}');
             return AlertDialog(
               title: Align(
                 alignment: Alignment.center,
                   child: Text(AppLocalizations.of(context)!.upload_photo)),

               actions: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     GestureDetector(
                         onTap: (){
                           context
                               .read<ProfileBloc>()
                               .add(ProfileEvent.profilePicFromCameraEvent());
                         },
                         child: Icon(Icons.camera_alt_rounded)),
                     GestureDetector(
                         onTap: (){
                           context
                               .read<ProfileBloc>()
                               .add(ProfileEvent.profilePicFromGalleryEvent());
                         },
                         child: Icon(Icons.photo)),
                   ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                   Text(AppLocalizations.of(context)!.camera),
                     Text(AppLocalizations.of(context)!.gallery),
                   ],
                 ),

               ],
             );
           },
         );
       }, );
   }
*/
}
