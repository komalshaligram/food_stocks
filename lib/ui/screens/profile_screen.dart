import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/profile/profile_bloc.dart';
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
    final temp =  (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map ;
    if(temp[AppStrings.contactString] == null){
      temp[AppStrings.contactString] = '';
    }
    else{
      temp[AppStrings.contactString];
    }


    return BlocProvider(
      create: (context) =>
          ProfileBloc()..add(ProfileEvent.getBusinessTypeListEvent()),
      child: ProfileScreenWidget(contact: temp[AppStrings.contactString]),
    );
  }
}

class ProfileScreenWidget extends StatelessWidget {
  final String contact;
  ProfileScreenWidget({super.key ,  this.contact = ''});
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext c) {
    ProfileBloc bloc = c.read<ProfileBloc>();
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {},
      child: BlocBuilder<ProfileBloc, ProfileState>(
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
                    left: getScreenWidth(c) * 0.1,
                    right: getScreenWidth(c) * 0.1),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.height,
                      Stack(
                        children: [
                          Container(
                            height: AppConstants.containerHeight_80,
                            width: getScreenWidth(c),
                            alignment: Alignment.center,
                            child: Container(
                              height: AppConstants.containerHeight_80,
                              width: AppConstants.containerHeight_80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200),
                                color: AppColors.mainColor.withOpacity(0.1),
                              ),
                              child: state.image.path == ""
                                  ? const Icon(Icons.person)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(AppConstants.radius_40),
                                      child: Image.file(File(state.image.path),
                                          fit: BoxFit.fill),
                                    ),
                            ),
                          ),
                          Positioned(
                            left: getScreenWidth(c) * 0.44,
                            top: getScreenHeight(c) * 0.05,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context1) {
                                    return AlertDialog(
                                      actionsPadding: EdgeInsets.only(
                                          left: AppConstants.padding_15,
                                          right: AppConstants.padding_15,
                                          top: AppConstants.padding_15,
                                          bottom: AppConstants.padding_30),
                                      title: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .upload_photo)),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  bloc.add(ProfileEvent
                                                      .profilePicFromCameraEvent(context: c));
                                                  Navigator.pop(context1);
                                                },
                                                child: Icon(
                                                  Icons.camera_alt_rounded,
                                                  color: AppColors.blackColor,
                                                )),
                                            GestureDetector(
                                                onTap: () {
                                                  bloc.add(ProfileEvent
                                                      .profilePicFromGalleryEvent(context: c));
                                                  Navigator.pop(context1);
                                                },
                                                child: Icon(
                                                  Icons.photo,
                                                  color: AppColors.blackColor,
                                                )),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(AppLocalizations.of(context)!
                                                .camera),
                                            Text(AppLocalizations.of(context)!
                                                .gallery),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 29,
                                height: 29,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(AppConstants.radius_20),
                                    border: Border.all(
                                        color: AppColors.borderColor)),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: AppColors.blueColor,
                                  size: AppConstants.mediumFont,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      3.height,
                      Container(
                        width: getScreenWidth(c),
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context)!.profile_picture,
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.font_14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor),
                        ),
                      ),
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.type_of_business,
                      ),
                      SizedBox(
                        height: AppConstants.textFormFieldHeight,
                        child: DropdownButtonFormField<String>(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.blackColor,
                          ),
                          alignment: Alignment.bottomCenter,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: AppConstants.padding_10,
                                right: AppConstants.padding_10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radius_3),
                              borderSide: BorderSide(
                                color: AppColors.borderColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radius_3),
                              borderSide: BorderSide(
                                color: AppColors.borderColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radius_3),
                              borderSide: BorderSide(
                                color: AppColors.borderColor,
                              ),
                            ),
                          ),
                          isExpanded: true,
                          elevation: 0,
                          style: TextStyle(
                            fontSize: AppConstants.smallFont,
                            color: AppColors.blackColor,
                          ),
                          value: state.selectedBusinessType,
                          items: state.businessTypeList.data?.clientTypes
                              ?.map((businessType) {
                            return DropdownMenuItem<String>(
                              value: businessType.businessType,
                              child: Text("${businessType.businessType}"),
                            );
                          }).toList(),
                          onChanged: (tag) {},
                        ),
                      ),
                      7.height,
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.business_name,
                      ),
                      CustomFormField(
                        controller: state.businessNameController,
                        keyboardType: TextInputType.text,
                        hint: "" /*AppLocalizations.of(context)!.life_grocery_store*/,
                        fillColor: Colors.transparent,
                        textInputAction: TextInputAction.next,
                        validator: AppStrings.businessNameValString,
                      ),
                      7.height,
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.hp,
                      ),
                      CustomFormField(
                        controller: state.hpController,
                        keyboardType: TextInputType.number,
                        hint: "",
                        fillColor: Colors.transparent,
                        textInputAction: TextInputAction.next,
                        validator: AppStrings.hpValString,
                      ),
                      7.height,
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.name_of_owner,
                      ),
                      CustomFormField(
                        controller: state.ownerNameController,
                        keyboardType: TextInputType.text,
                        hint: "",
                        fillColor: Colors.transparent,
                        textInputAction: TextInputAction.next,
                        validator: AppStrings.ownerNameValString,
                      ),
                      7.height,
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.id,
                      ),
                      CustomFormField(
                        controller: state.idController,
                        keyboardType: TextInputType.number,
                        hint: "",
                        fillColor: Colors.transparent,
                        textInputAction: TextInputAction.next,
                        validator: AppStrings.idValString,
                      ),
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.contact,
                      ),
                      7.height,
                      CustomFormField(
                        controller: state.contactController,
                        keyboardType: TextInputType.text,
                        hint: "",
                        fillColor: Colors.transparent,
                        textInputAction: TextInputAction.done,
                        validator: AppStrings.contactNameValString,
                      ),
                      40.height,
                      CustomButtonWidget(
                        buttonText: AppLocalizations.of(context)!.continued,
                        bGColor: AppColors.mainColor,
                        onPressed: () {
                          if (state.image.path != '') {
                            if (state.selectedBusinessType.isEmpty ||
                                state.selectedBusinessType != '') {
                              if (_formKey.currentState?.validate() ?? false) {
                                bloc.add(ProfileEvent
                                    .navigateToMoreDetailsScreenEvent(
                                        context: c,
                                  phoneNumber: contact

                                ));
                              }
                            } else {
                              SnackBarShow(
                                  context,
                                  'Please select your business type',
                                  AppColors.redColor);
                            }
                          } else {
                            SnackBarShow(
                                context,
                                'Please select your profile photo',
                                AppColors.redColor);
                          }
                        },
                        fontColors: AppColors.whiteColor,
                      ),
                      20.height,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
