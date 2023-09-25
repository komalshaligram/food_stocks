import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
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

      child: ProfileScreenWidget(),

    );
  }
}

class ProfileScreenWidget extends StatelessWidget {
  const ProfileScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
            title: Text(
              AppLocalizations.of(context)!.business_details,

              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont, color: Colors.black, fontWeight: FontWeight.w400),
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
                          child: state.isImagePick
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.file(File(state.image.path),
                                      fit: BoxFit.fill),
                                )
                              : const Icon(Icons.person),
                        ),
                      ),
                      Positioned(
                        left: 188,
                        top: 45,
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<ProfileBloc>()
                                .add(ProfileEvent.pickProfilePicEvent());
                          },
                          child: state.isImagePick
                              ? const SizedBox()
                              : Container(
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
                                ),
                        ),
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
                      contentPadding: EdgeInsets.only(left: 8,right:8),
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
                      var temp = state.selectedBusiness;
                      temp = tag;
                    },
                  ),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.business_name,
                  ),
                  CustomFormField(
                    fillColor: AppColors.whiteColor,
                    controller: state.businessNameController,
                    keyboardType: TextInputType.text,
                    // inputAction: TextInputAction.done,
                    hint: AppLocalizations.of(context)!.life_grocery_store,
                    validator: '',
                  ),
                  CustomContainerWidget(
                    name: AppStrings.hpString,
                  ),
                  CustomFormField(
                      fillColor: AppColors.whiteColor,
                      controller: state.hpController,
                      keyboardType: TextInputType.number,
                      // inputAction: TextInputAction.next,
                      hint: "152485",
                      validator: ''),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.name_of_owner,
                  ),
                  CustomFormField(
                      fillColor: AppColors.whiteColor,
                      controller: state.ownerController,
                      keyboardType: TextInputType.text,
                      //  inputAction: TextInputAction.next,
                      hint: "ajsdjg",
                      validator: ""),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.id,
                  ),
                  CustomFormField(
                      fillColor: AppColors.whiteColor,
                      controller: state.idController,
                      keyboardType: TextInputType.number,
                      // inputAction: TextInputAction.next,
                      hint: "045896525",
                      validator: ""),
                  CustomContainerWidget(
                    name: AppLocalizations.of(context)!.contact,
                  ),
                  CustomFormField(
                      fillColor: AppColors.whiteColor,
                      controller: state.contactController,
                      keyboardType: TextInputType.text,
                      //  inputAction: TextInputAction.next,
                      hint: "text",
                      validator: ""),
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
}
