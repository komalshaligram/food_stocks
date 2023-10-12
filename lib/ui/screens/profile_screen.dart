import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../utils/themes/app_urls.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widget/file_selection_option_widget.dart';

class ProfileRoute {
  static Widget get route => const ProfileScreen();
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map?;

    debugPrint(
        "isUpdate : ${args?.containsKey(AppStrings.isUpdateParamString)}\nmobileNumber : ${args?.containsKey(AppStrings.contactString)}");
    return BlocProvider(
      create: (context) => ProfileBloc()
        ..add(
          ProfileEvent.getBusinessTypeListEvent(context: context),
        )..add(
          ProfileEvent.getProfileDetailsEvent(
              context: context,
              isUpdate:
              args?.containsKey(AppStrings.isUpdateParamString) ?? false
                  ? true
                  : false,
              mobileNo: args?.containsKey(AppStrings.contactString) ?? false
                  ? args![AppStrings.contactString]
                  : ''),
        ),
      child: ProfileScreenWidget(),
    );
  }
}

class ProfileScreenWidget extends StatelessWidget {
  ProfileScreenWidget({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context1) {
    ProfileBloc bloc = context1.read<ProfileBloc>();
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
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: getScreenWidth(context1) * 0.1,
                      right: getScreenWidth(context1) * 0.1),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.height,
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                height: AppConstants.containerHeight_80,
                                width: AppConstants.containerHeight_80,
                                margin: EdgeInsets.only(
                                    bottom: AppConstants.padding_3,
                                    right: AppConstants.padding_3,
                                    left: AppConstants.padding_3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  color: AppColors.mainColor.withOpacity(0.1),
                                ),
                                child: state.isUpdate
                                    ? state.UserImageUrl.contains(
                                            AppStrings.tempString)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: Image.file(
                                              state.image,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: Image.network(
                                              '${AppUrls.baseFileUrl}${state.UserImageUrl}',
                                              fit: BoxFit.fill,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return Center(
                                                    child:
                                                        CupertinoActivityIndicator(
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                  );
                                                }
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          AppColors.whiteColor,
                                                      border: Border.all(
                                                          color: AppColors
                                                              .borderColor
                                                              .withOpacity(0.5),
                                                          width: 1)),
                                                );
                                              },
                                            ))
                                    : state.image.path == ""
                                        ? Icon(
                                            Icons.person,
                                            size: 60,
                                            color: AppColors.textColor,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: Image.file(
                                              state.image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                              ),
                              Positioned(
                                right: 1,
                                bottom: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(
                                                        AppConstants.radius_20),
                                                    topLeft: Radius.circular(
                                                        AppConstants
                                                            .radius_20)),
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                  AppConstants.padding_30,
                                                  vertical:
                                                  AppConstants.padding_20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                        context)!
                                                        .upload_photo,
                                                    style: AppStyles
                                                        .rkRegularTextStyle(
                                                        size: AppConstants
                                                            .normalFont,
                                                        color: AppColors
                                                            .blackColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600),
                                                  ),
                                                  30.height,
                                                  FileSelectionOptionWidget(
                                                      title:
                                                      AppLocalizations.of(
                                                          context)!
                                                          .camera,
                                                      icon: Icons
                                                          .camera_alt_rounded,
                                                      onTap: () {
                                                        bloc.add(ProfileEvent
                                                            .pickProfileImageEvent(
                                                            context:
                                                            context,
                                                            isFromCamera:
                                                            true));
                                                        Navigator.pop(context);
                                                      }),
                                                  Container(
                                                    height: 1,
                                                    width:
                                                    getScreenWidth(context),
                                                    color: AppColors.borderColor
                                                        .withOpacity(0.5),
                                                  ),
                                                  FileSelectionOptionWidget(
                                                      title:
                                                      AppLocalizations.of(
                                                          context)!
                                                          .gallery,
                                                      icon: Icons.photo,
                                                      onTap: () {
                                                        bloc.add(ProfileEvent
                                                            .pickProfileImageEvent(
                                                            context:
                                                            context,
                                                            isFromCamera:
                                                            false));
                                                        Navigator.pop(context);
                                                      }),
                                                ],
                                              ),
                                            ),
                                        backgroundColor: Colors.transparent);
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (context1) {
                                    //     return AlertDialog(
                                    //       actionsPadding: EdgeInsets.only(
                                    //           left: AppConstants.padding_15,
                                    //           right: AppConstants.padding_15,
                                    //           top: AppConstants.padding_15,
                                    //           bottom: AppConstants.padding_30),
                                    //       title: Align(
                                    //           alignment: Alignment.center,
                                    //           child: Text(
                                    //               AppLocalizations.of(context)!
                                    //                   .upload_photo)),
                                    //       actions: [
                                    //         Row(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.spaceAround,
                                    //           children: [
                                    //             GestureDetector(
                                    //                 onTap: () {
                                    //                   bloc.add(ProfileEvent
                                    //                       .pickProfileImageEvent(
                                    //                           context: c,
                                    //                           isFromCamera: true));
                                    //                   Navigator.pop(context1);
                                    //                 },
                                    //                 child: Icon(
                                    //                   Icons.camera_alt_rounded,
                                    //                   color: AppColors.blackColor,
                                    //                 )),
                                    //             GestureDetector(
                                    //                 onTap: () {
                                    //                   bloc.add(ProfileEvent
                                    //                       .pickProfileImageEvent(
                                    //                           context: c,
                                    //                           isFromCamera: false));
                                    //                   Navigator.pop(context1);
                                    //                 },
                                    //                 child: Icon(
                                    //                   Icons.photo,
                                    //                   color: AppColors.blackColor,
                                    //                 )),
                                    //           ],
                                    //         ),
                                    //         Row(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.spaceAround,
                                    //           children: [
                                    //             Text(AppLocalizations.of(context)!
                                    //                 .camera),
                                    //             Text(AppLocalizations.of(context)!
                                    //                 .gallery),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     );
                                    //   },
                                    // );
                                  },
                                  child: Container(
                                      width: 29,
                                      height: 29,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          border: Border.all(
                                              color: AppColors.borderColor)),
                                      child: SvgPicture.asset(
                                          AppImagePath.camera,
                                          fit: BoxFit
                                              .scaleDown) /*Icon(
                                      Icons.camera_alt_rounded,
                                      color: AppColors.blueColor,
                                      size: 18,
                                    ),*/
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        3.height,
                        Container(
                          width: getScreenWidth(context1),
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
                          // height: AppConstants.textFormFieldHeight,
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
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radius_3),
                                borderSide: BorderSide(
                                  color: AppColors.borderColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radius_3),
                                borderSide: BorderSide(
                                  color: AppColors.borderColor,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radius_3),
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
                          hint:
                          "" /*AppLocalizations.of(context)!.life_grocery_store*/,
                          fillColor: Colors.transparent,
                          textInputAction: TextInputAction.next,
                          validator: AppStrings.businessNameValString,
                        ),
                        7.height,
                        CustomContainerWidget(
                          name: AppLocalizations.of(context)!.business_id,
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
                          name: AppLocalizations.of(context)!.israel_id,
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
                          name: AppLocalizations.of(context)!.contact_name,
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
                          buttonText: state.isUpdate
                              ? AppLocalizations.of(context)!.save
                              : AppLocalizations.of(context)!.next,
                          bGColor: AppColors.mainColor,
                          isLoading: state.isLoading,
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  if (state.UserImageUrl != '') {
                                    if (state.selectedBusinessType.isEmpty ||
                                        state.selectedBusinessType != '') {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        if (state.isUpdate) {
                                          bloc.add(ProfileEvent
                                              .updateProfileDetailsEvent(
                                                  context: context1));
                                        } else {
                                          bloc.add(ProfileEvent
                                              .navigateToMoreDetailsScreenEvent(
                                                  context: context1));
                                        }
                                      }
                                    } else {
                                      showSnackBar(
                                          context: context,
                                          title: AppStrings
                                              .selectBusinessTypeString,
                                          bgColor: AppColors.redColor);
                                    }
                                  } else {
                                    showSnackBar(
                                        context: context,
                                        title:
                                            AppStrings.selectProfileImageString,
                                        bgColor: AppColors.redColor);
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
            ),
          );
        },
      ),
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
