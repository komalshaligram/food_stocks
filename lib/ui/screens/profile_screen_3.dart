import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile3/profile3_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';

import '../utils/themes/app_styles.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile3Route {
  static Widget get route => const ProfileScreen3();
}

class ProfileScreen3 extends StatelessWidget {
  const ProfileScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Profile3Bloc(),
      child: const ProfileScreenWidget(),
    );
  }
}

class ProfileScreenWidget extends StatelessWidget {
  const ProfileScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<Profile3Bloc, Profile3State>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteDefine.profileScreen.name);
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
            title: Text(
              AppLocalizations.of(context)!.more_details,
              style: AppStyles.rkRegularTextStyle(
                  size: 16, color: Colors.black, fontWeight: FontWeight.w400),
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
                  const SizedBox(
                    height: 20,
                  ),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.city,
                  ),
                  DropdownButtonFormField<String>(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: InputDecoration(

                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0),
                        borderSide: BorderSide(
                          color: AppColors.borderColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: BorderSide(
                            color: AppColors.borderColor,
                            width: 1,
                          )),
                    ),
                    isExpanded: true,
                    elevation: 0,
                    borderRadius: BorderRadius.circular(20),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    dropdownColor: AppColors.mainColor.withOpacity(0.1),
                    value: state.selectCity,
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
                      var temp = state.selectCity;
                      temp = tag;
                    },
                  ),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.full_address,
                  ),
                  CustomFormField(
                    fillColor: AppColors.whiteColor,
                    controller: state.addressController,
                    keyboardType: TextInputType.text,
                    hint: AppLocalizations.of(context)!.life_grocery_store,
                    validator: 'text',
                  ),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.email,
                  ),
                  CustomFormField(
                      fillColor: AppColors.whiteColor,
                      controller: state.emailController,
                      keyboardType: TextInputType.number,
                      hint: "152485",
                      validator: "number"),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.fax,
                  ),
                  CustomFormField(
                      fillColor: AppColors.whiteColor,
                      controller: state.faxController,
                      keyboardType: TextInputType.number,
                      hint: "abc@fax",
                      validator: "text"),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.logo_image,
                  ),
                  Container(
                    height: 134,
                    alignment: Alignment.center,
                    child: DottedBorder(
                      color: state.isImagePick
                          ? AppColors.whiteColor
                          : AppColors.borderColor,
                      strokeWidth: state.isImagePick ? 0 : 2,
                      dashPattern: state.isImagePick ? [1, 0] : [5, 3],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                context
                                    .read<Profile3Bloc>()
                                    .add(Profile3Event.pickLogoEvent());
                              },
                              child: state.isImagePick
                                  ? SizedBox(
                                      height: 130,
                                      width: screenWidth,
                                      child: Image.file(
                                        File(state.image.path),
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : Icon(
                                      Icons.camera_alt_rounded,
                                      color: AppColors.blueColor,
                                      size: 30,
                                    )),
                          state.isImagePick
                              ? const SizedBox()
                              : Align(
                                  child: Container(
                                    width: screenWidth,
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppLocalizations.of(context)!.upload_photo,
                                      style: AppStyles.rkRegularTextStyle(
                                          size: 14,
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 130,
                  ),
                  CustomButtonWidget(
                    buttonText: AppLocalizations.of(context)!.continued,
                    bGColor: AppColors.mainColor,
                    onPressed: () {
                      context
                          .read<Profile3Bloc>()
                          .add(Profile3Event.textFieldValidateEvent(
                          city: state.selectCity!,
                          address: state.addressController.text,
                          email: state.emailController.text,
                          fax: state.faxController.text,
                          image: state.image,
                        context: context
                      ));

                   /*   Navigator.pushNamed(
                          context, RouteDefine.operationTimeScreen.name);*/
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
}
