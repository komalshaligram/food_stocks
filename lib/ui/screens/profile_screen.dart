import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/profile_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_alert_dialog.dart';
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
        )
        ..add(
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
      listener: (context, state) {
        if (state.isFileSizeExceeds) {
          CustomSnackBar.showSnackBar(
              context: context,
              title: '${AppLocalizations.of(context)!.file_size_must_be_less_then}',
              type: SnackBarType.FAILURE);
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          debugPrint('image   1   ${state.image}');
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: AppBar(
              surfaceTintColor: AppColors.whiteColor,
              leading: GestureDetector(
                  onTap: () {
                    if (!state.isUpdate) {
                      Navigator.pushNamed(
                          context, RouteDefine.connectScreen.name);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
              title: Text(
                AppLocalizations.of(context)!.business_details,
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              titleSpacing: 0,
              elevation: 0,
            ),
            body: state.isShimmering
                ? /*Shimmer.fromColors(child: Container(height: 100, width: 200,), baseColor: AppColors.greyColor, highlightColor: AppColors.saleRedColor)*/ ProfileScreenShimmerWidget()
                : Stack(
                    children: [
                      SafeArea(
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
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context1) => Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.whiteColor,
                                                    borderRadius: BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                AppConstants
                                                                    .radius_20),
                                                        topLeft: Radius.circular(
                                                            AppConstants
                                                                .radius_20)),
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: AppConstants
                                                          .padding_30,
                                                      vertical: AppConstants
                                                          .padding_20),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context1)!
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
                                                          title: AppLocalizations
                                                                  .of(context1)!
                                                              .camera,
                                                          icon: Icons
                                                              .camera_alt_rounded,
                                                          onTap: () async {
                                                            Map<Permission,
                                                                    PermissionStatus>
                                                                statuses =
                                                                await [
                                                              Permission.camera,
                                                            ].request();
                                                            if (Platform
                                                                .isAndroid) {
                                                              if (!statuses[
                                                                      Permission
                                                                          .camera]!
                                                                  .isGranted) {
                                                                Navigator.pop(
                                                                    context1);
                                                                CustomSnackBar.showSnackBar(
                                                                    context:
                                                                        context,
                                                                    title: AppLocalizations.of(
                                                                            context)!
                                                                        .camera_permission,
                                                                    type: SnackBarType
                                                                        .FAILURE);
                                                                return;
                                                              }
                                                            } else if (Platform
                                                                .isIOS) {
                                                              // Navigator.pop(context);
                                                            }
                                                            bloc.add(ProfileEvent
                                                                .pickProfileImageEvent(
                                                                    context:
                                                                        context,
                                                                    isFromCamera:
                                                                        true));
                                                            Navigator.pop(
                                                                context1);
                                                          }),
                                                      FileSelectionOptionWidget(
                                                          title: AppLocalizations
                                                                  .of(context1)!
                                                              .gallery,
                                                          icon: Icons.photo,
                                                          lastItem: state
                                                                  .UserImageUrl
                                                                  .isEmpty
                                                              ? true
                                                              : false,
                                                          onTap: () async {
                                                            Map<Permission,
                                                                    PermissionStatus>
                                                                statuses =
                                                                await [
                                                              Permission
                                                                  .storage,
                                                            ].request();
                                                            if (Platform
                                                                .isAndroid) {
                                                              DeviceInfoPlugin
                                                                  deviceInfo =
                                                                  DeviceInfoPlugin();
                                                              AndroidDeviceInfo
                                                                  androidInfo =
                                                                  await deviceInfo
                                                                      .androidInfo;
                                                              if (androidInfo
                                                                      .version
                                                                      .sdkInt <
                                                                  33) {
                                                                if (!statuses[
                                                                        Permission
                                                                            .storage]!
                                                                    .isGranted) {
                                                                  CustomSnackBar.showSnackBar(
                                                                      context:
                                                                          context,
                                                                      title: AppLocalizations.of(
                                                                              context)!
                                                                          .storage_permission,
                                                                      type: SnackBarType
                                                                          .FAILURE);
                                                                  Navigator.pop(
                                                                      context);
                                                                  return;
                                                                }
                                                              }
                                                            } else if (Platform
                                                                .isIOS) {
                                                              // Navigator.pop(context);
                                                            }
                                                            bloc.add(ProfileEvent
                                                                .pickProfileImageEvent(
                                                                    context:
                                                                        context,
                                                                    isFromCamera:
                                                                        false));
                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                      state.UserImageUrl.isEmpty
                                                          ? 0.width
                                                          : FileSelectionOptionWidget(
                                                              title: AppLocalizations.of(
                                                                      context1)!
                                                                  .remove,
                                                              icon:
                                                                  Icons.delete,
                                                              iconColor:
                                                                  AppColors
                                                                      .redColor,
                                                              lastItem: true,
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context1);
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context2) =>
                                                                          CommonAlertDialog(
                                                                    title:
                                                                        '${AppLocalizations.of(context)!.remove}',
                                                                    subTitle:
                                                                        '${AppLocalizations.of(context)!.are_you_sure}',
                                                                    positiveTitle:
                                                                        '${AppLocalizations.of(context)!.yes}',
                                                                    negativeTitle:
                                                                        '${AppLocalizations.of(context)!.no}',
                                                                    negativeOnTap:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context2);
                                                                    },
                                                                    positiveOnTap:
                                                                        () async {
                                                                      bloc.add(ProfileEvent.deleteFileEvent(
                                                                          context:
                                                                              context));
                                                                      Navigator.pop(
                                                                          context2);
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                    ],
                                                  ),
                                                ),
                                            backgroundColor:
                                                Colors.transparent);
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
                                      child: Stack(
                                        children: [
                                          Container(
                                              height: AppConstants
                                                  .containerHeight_80,
                                              width: AppConstants
                                                  .containerHeight_80,
                                              margin: EdgeInsets.only(
                                                  bottom:
                                                      AppConstants.padding_3,
                                                  right: AppConstants.padding_3,
                                                  left: AppConstants.padding_3),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: state.UserImageUrl
                                                            .isNotEmpty
                                                        ? AppColors
                                                            .lightBorderColor
                                                        : Colors.transparent),
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                                color: state
                                                        .UserImageUrl.isNotEmpty
                                                    ? AppColors.whiteColor
                                                    : AppColors.mainColor
                                                        .withOpacity(0.1),
                                              ),
                                              child: state.isUpdate
                                                  ? state.UserImageUrl
                                                          .isNotEmpty
                                                      ? state.image.path != ''
                                                          ? SizedBox(
                                                              height: getScreenHeight(
                                                                      context) *
                                                                  0.18,
                                                              width:
                                                                  getScreenWidth(
                                                                      context),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            40),
                                                                child:
                                                                    Image.file(
                                                                  state.image,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ))
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                              child:
                                                                  Image.network(
                                                                '${AppUrls.baseFileUrl}${state.UserImageUrl}',
                                                                fit: BoxFit
                                                                    .contain,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  } else {
                                                                    return Center(
                                                                      child:
                                                                          CupertinoActivityIndicator(
                                                                        color: AppColors
                                                                            .blackColor,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                        color: AppColors
                                                                            .whiteColor,
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      AppStrings
                                                                          .failedToLoadString,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: AppStyles.rkRegularTextStyle(
                                                                          size: AppConstants
                                                                              .font_14,
                                                                          color:
                                                                              AppColors.textColor),
                                                                    ),
                                                    );
                                                  },
                                                ),
                                              )
                                              :SvgPicture.asset(
          AppImagePath.placeholderProfile,
          width: 80,
          height: 80,
          fit: BoxFit.scaleDown,
          // colorFilter: ColorFilter.mode(
          //     AppColors.mainColor,
          //     BlendMode.dstIn),
          )
                                              : state.image.path != ''
                                              ? ClipRRect(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                40),
                                                child: Image.file(
                                                  File(
                                                      state.image.path),
                                                  fit: BoxFit.contain,
                                                ),
                                              )
                                              : SvgPicture.asset(
                                                AppImagePath.placeholderProfile,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.scaleDown,
                                                // colorFilter: ColorFilter.mode(
                                                //     AppColors.mainColor,
                                                //     BlendMode.dstIn),
                                              ),),/*state.isUpdate
                                              ? state.isFileUploading
                                                  ? Center(
                                                      child:
                                                          CupertinoActivityIndicator(
                                                        color: AppColors
                                                            .blackColor,
                                                      ),
                                                    )
                                                  : state.UserImageUrl.isEmpty
                                                      ? Icon(
                                                          Icons.person,
                                                          size: 60,
                                                          color: AppColors
                                                              .textColor,
                                                        )
                                                      : state.UserImageUrl
                                                              .contains(AppStrings
                                                                  .tempString)
                                                          ? ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                              child: Image.file(
                                                                state.image,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                              child:
                                                                  Image.network(
                                                                '${AppUrls.baseFileUrl}${state.UserImageUrl}',
                                                                fit:
                                                                    BoxFit.fill,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  } else {
                                                                    return Center(
                                                                      child:
                                                                          CupertinoActivityIndicator(
                                                                        color: AppColors
                                                                            .blackColor,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Icon(
                                                                    Icons
                                                                        .person,
                                                                    size: 60,
                                                                    color: AppColors
                                                                        .textColor,
                                                                  )
                                                                      *//*Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors
                                                            .whiteColor,
                                                        border: Border.all(
                                                            color: AppColors
                                                                .borderColor
                                                                .withOpacity(
                                                                    0.5),
                                                            width: 1)),
                                                  )*//*
                                                                      ;
                                                                },
                                                              ))
                                              : state.image.path == ''
                                                  ? Icon(
                                                      Icons.person,
                                                      size: 60,
                                                      color:
                                                          AppColors.textColor,
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      child: Image.file(
                                                        state.image,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )),*/
                                          Positioned(
                                            right: context.rtl ? null : 1,
                                            left: context.rtl ? 1 : null,
                                            bottom: 1,
                                            child: Container(
                                                width: 29,
                                                height: 29,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        color: AppColors
                                                            .borderColor)),
                                                child: SvgPicture.asset(
                                                    AppImagePath.camera,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            AppColors.mainColor,
                                                            BlendMode.srcIn),
                                                    fit: BoxFit
                                                        .scaleDown) /*Icon(
                                      Icons.camera_alt_rounded,
                                      color: AppColors.blueColor,
                                      size: 18,
                                    ),*/
                                            ),
                                      ),
                                    ],
                                  ),
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
                                      color: AppColors.textColor),
                                ),
                              ),
                              CustomContainerWidget(
                                name: AppLocalizations.of(context)!
                                    .type_of_business,
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
                                  items: state
                                      .businessTypeList.data?.clientTypes
                                      ?.map((businessType) {
                                    return DropdownMenuItem<String>(
                                      value: businessType.businessType,
                                      child:
                                          Text("${businessType.businessType}"),
                                    );
                                  }).toList(),
                                  onChanged: (newBusinessType) {
                                    bloc.add(
                                        ProfileEvent.changeBusinessTypeEvent(
                                            newBusinessType: newBusinessType!));
                                  },
                                ),
                              ),
                              7.height,
                              CustomContainerWidget(
                                name:
                                    AppLocalizations.of(context)!.business_name,
                              ),
                              CustomFormField(
                                context: context,
                                controller: state.businessNameController,
                                inputformet: [
                                  /*FilteringTextInputFormatter.deny(
                                RegExp(r'\s')),*/
                                  LengthLimitingTextInputFormatter(20)
                                ],
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
                                context: context,
                                controller: state.hpController,
                                inputformet: [
                                  /*FilteringTextInputFormatter.deny(
                              RegExp(r'\s')),*/
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(9)
                                ],
                                keyboardType: TextInputType.number,
                                hint: "",
                                fillColor: Colors.transparent,
                                textInputAction: TextInputAction.next,
                                validator: AppStrings.hpValString,
                              ),
                              7.height,
                              CustomContainerWidget(
                                name:
                                    AppLocalizations.of(context)!.name_of_owner,
                              ),
                              CustomFormField(
                                context: context,
                                controller: state.ownerNameController,
                                inputformet: [
                                  /*FilteringTextInputFormatter.deny(
                              RegExp(r'\s')),*/

                                      LengthLimitingTextInputFormatter(20)
                                    ],
                                    keyboardType: TextInputType.text,
                                    hint: "",
                                    fillColor: Colors.transparent,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.ownerNameValString,
                                  ),
                                  7.height,
                                  CustomContainerWidget(
                                    name:
                                        AppLocalizations.of(context)!.israel_id,
                                  ),
                                  CustomFormField(
                                    context: context,
                                    controller: state.idController,
                                    inputformet: [
                                      /*TextInputFormatter.withFunction((oldValue, newValue) {
                                print('old____${oldValue}');
                                print('new____${newValue}');
                                print('hgsjdsds _____${newValue.text.length < 1}');
                                if(newValue.text.length == 1){
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'));
                                  return TextEditingValue(text: state.idController.text);
                                }
                                return newValue;

                              }),*/
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(9)
                                    ],
                                    // maxLimits: 9,
                                    keyboardType: TextInputType.number,
                                    hint: "",
                                    fillColor: Colors.transparent,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.idValString,
                                  ),
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!
                                        .contact_name,
                                  ),
                                  7.height,
                                  CustomFormField(
                                    controller: state.contactController,
                                    inputformet: [
                                      LengthLimitingTextInputFormatter(20)
                                    ],
                                    keyboardType: TextInputType.text,
                                    hint: "",
                                    fillColor: Colors.transparent,
                                    textInputAction: TextInputAction.done,
                                    validator: AppStrings.contactNameValString, context: context,
                                  ),
                                  40.height,
                                  CustomButtonWidget(
                                    buttonText: state.isUpdate
                                        ? AppLocalizations.of(context)!
                                            .save
                                            .toUpperCase()
                                        : AppLocalizations.of(context)!
                                            .next
                                            .toUpperCase(),
                                    bGColor: AppColors.mainColor,
                                    isLoading: state.isLoading,
                                    onPressed: state.isLoading
                                        ? null
                                        : () {
                                            // if (state.UserImageUrl != '') {
                                            if (state.selectedBusinessType
                                                    .isEmpty ||
                                                state.selectedBusinessType !=
                                                    '') {
                                              if (_formKey.currentState
                                                      ?.validate() ??
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
                                              CustomSnackBar.showSnackBar(
                                                  context: context,
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .select_business_type,
                                                  type: SnackBarType.FAILURE);
                                            }
                                      // } else {
                                            //   CustomSnackBar.showSnackBar(
                                            //       context: context,
                                            //       title:
                                            //           AppStrings.selectProfileImageString,
                                            //       bgColor: AppColors.redColor);
                                            // }
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
                      state.isUpdating
                          ? Container(
                              color: Color.fromARGB(10, 0, 0, 0),
                              height: getScreenHeight(context),
                              width: getScreenWidth(context),
                              alignment: Alignment.center,
                              child: CupertinoActivityIndicator(
                                color: AppColors.blackColor,
                              ),
                            )
                          : 0.width,
                    ],
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
