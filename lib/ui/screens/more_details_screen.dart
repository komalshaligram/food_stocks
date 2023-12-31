import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/profile_req_model/profile_model.dart';
import 'package:food_stock/ui/widget/more_details_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../bloc/more_details/more_details_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_alert_dialog.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widget/file_selection_option_widget.dart';

class MoreDetailsRoute {
  static Widget get route => MoreDetailsScreen();
}

class MoreDetailsScreen extends StatelessWidget {
  MoreDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => MoreDetailsBloc()
        ..add(MoreDetailsEvent.getProfileModelEvent(
          profileModel: args?[AppStrings.profileParamString] ?? ProfileModel(),
          context: context,
        ))
        ..add(MoreDetailsEvent.getProfileMoreDetailsEvent(
            context: context,
            isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false
                ? true
                : false)),
      child: MoreDetailsScreenWidget(),
    );
  }
}

class MoreDetailsScreenWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  List<String> list = [];

  MoreDetailsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final listNotifier = ValueNotifier<List<String>>([]);

    MoreDetailsBloc bloc = context.read<MoreDetailsBloc>();
    return BlocListener<MoreDetailsBloc, MoreDetailsState>(
      listener: (context, state) {
        if (state.isFileSizeExceeds) {
          CustomSnackBar.showSnackBar(
              context: context,
              title: '${AppLocalizations.of(context)!.file_size_must_be_less_then}',
              type: SnackBarType.FAILURE);
        }
        ;
      },
      child: BlocBuilder<MoreDetailsBloc, MoreDetailsState>(
        builder: (context, state) {
          if (list.isEmpty) {
            list = [...state.cityList];
          }
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: AppBar(
              surfaceTintColor: AppColors.whiteColor,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
              title: Text(
                AppLocalizations.of(context)!.more_details,
                style:
                    AppStyles.rkRegularTextStyle(size: 16, color: Colors.black),
              ),
              backgroundColor: AppColors.whiteColor,
              titleSpacing: 0,
              elevation: 0,
            ),
            body: state.isShimmering
                ? MoreDetailsScreenShimmerWidget()
                : Stack(
                    children: [
                      SafeArea(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: getScreenWidth(context) * 0.1,
                                right: getScreenWidth(context) * 0.1),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  10.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!.city,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        context: context,
                                        isScrollControlled: true,
                                        shape: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(
                                                    AppConstants.radius_20),
                                                topLeft: Radius.circular(
                                                    AppConstants.radius_20)),
                                            borderSide: BorderSide.none),
                                        builder: (context1) {
                                          return ValueListenableBuilder(
                                              valueListenable: listNotifier,
                                              builder:
                                                  (context, _content, child) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Container(
                                                    height: getScreenHeight(
                                                            context) *
                                                        0.9,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        7.height,
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .city,
                                                                  style: AppStyles.rkRegularTextStyle(
                                                                      size: AppConstants
                                                                          .mediumFont,
                                                                      color: AppColors
                                                                          .blackColor)),
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context1);
                                                                },
                                                                child: Icon(
                                                                    Icons
                                                                        .close))
                                                          ],
                                                        ),
                                                        15.height,
                                                        CustomFormField(
                                                          context: context,
                                                          prefixIcon: Icon(
                                                            Icons.search,
                                                            color: AppColors
                                                                .borderColor,
                                                          ),
                                                          onChangeValue:
                                                              (value) {
                                                            bloc.add(
                                                                MoreDetailsEvent
                                                                    .citySearchEvent(
                                                              search: value,
                                                            ));
                                                            list = state
                                                                .cityList
                                                                .where((city) =>
                                                                    city.contains(
                                                                        value))
                                                                .toList();
                                                            listNotifier.value =
                                                                list;
                                                          },
                                                          controller: state
                                                              .cityController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          hint: AppLocalizations
                                                                  .of(context)!
                                                              .city,
                                                          fillColor: AppColors
                                                              .whiteColor,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          validator: '',
                                                          textCapitalization:
                                                              TextCapitalization
                                                                  .words,
                                                          autofocus: true,
                                                          cursorColor: AppColors
                                                              .mainColor,
                                                        ),
                                                        7.height,
                                                        list.length == 0
                                                            ? Expanded(
                                                                child: Center(
                                                                  child: Text(
                                                                      '${AppLocalizations.of(context)!.cities_not_available}',
                                                                    style: AppStyles.rkRegularTextStyle(
                                                                        size: AppConstants
                                                                            .smallFont,
                                                                        color: AppColors
                                                                            .textColor),
                                                                  ),
                                                                ),
                                                              )
                                                            : Expanded(
                                                                child: ListView
                                                                    .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: list
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          bloc.add(MoreDetailsEvent.selectCityEvent(
                                                                              city: list[index],
                                                                              context: context));
                                                                          Navigator.pop(
                                                                              context1);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          list[index]
                                                                              .toString(),
                                                                          style:
                                                                              AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 46,
                                      width: getScreenWidth(context),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        border: Border.all(
                                            color: AppColors.borderColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppConstants.radius_3)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppConstants.padding_10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.selectCity,
                                            style: AppStyles.rkRegularTextStyle(
                                                size: AppConstants.mediumFont,
                                                color: AppColors.blackColor),
                                            // textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  7.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!
                                        .full_address,
                                  ),
                                  CustomFormField(
                                    context: context,
                                    controller: state.addressController,
                                    inputformet: [
                                      /*FilteringTextInputFormatter.deny(
                                  RegExp(r'\s')),*/
                                      LengthLimitingTextInputFormatter(50)
                                    ],
                                    keyboardType: TextInputType.text,
                                    hint: AppLocalizations.of(context)!.address,
                                    fillColor: AppColors.whiteColor,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.addressValString,
                                  ),
                                  7.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!.email,
                                  ),
                                  CustomFormField(
                                    context: context,
                                    controller: state.emailController,
                                    inputformet: [
                                      /*FilteringTextInputFormatter.deny(
                                  RegExp(r'\s')),*/
                                      LengthLimitingTextInputFormatter(25)
                                    ],
                                    keyboardType: TextInputType.emailAddress,
                                    hint: "",
                                    fillColor: AppColors.whiteColor,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.emailValString,
                                  ),
                                  7.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!.fax,
                                  ),
                                  CustomFormField(
                                    context: context,
                                    controller: state.faxController,
                                    inputformet: [
                                      /*FilteringTextInputFormatter.deny(
                                  RegExp(r'\s')),*/
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(11)
                                    ],
                                    onChangeValue: (FAX) {
                                      bloc.add(
                                          MoreDetailsEvent.setFAXFormatEvent(
                                              FAX: FAX));
                                    },
                                    textDirection:
                                        context.rtl ? TextDirection.ltr : null,
                                    keyboardType: TextInputType.number,
                                    hint: AppLocalizations.of(context)!.fax,
                                    fillColor: AppColors.whiteColor,
                                    textInputAction: TextInputAction.done,
                                    validator: AppStrings.faxValString,
                                  ),
                                  7.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!
                                        .logo_image,
                                    star: '',
                                  ),
                                  Container(
                                    height: getScreenHeight(context) * 0.2,
                                    alignment: Alignment.center,
                                    child: DottedBorder(
                                      color: /*state.companyLogo.isNotEmpty ?  state.image.path != ''
                                    ? AppColors.whiteColor
                                    : AppColors.whiteColor :*/
                                          AppColors.borderColor,
                                      radius: Radius.circular(
                                          AppConstants.radius_3),
                                      borderType: BorderType.RRect,
                                      strokeWidth: 1,
                                      dashPattern: [3, 2],
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context1) => Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.whiteColor,
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                AppConstants
                                                                    .padding_30,
                                                            vertical:
                                                                AppConstants
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
                                                                    .of(
                                                                        context1)!
                                                                .camera,
                                                            icon: Icons
                                                                .camera_alt_rounded,
                                                            onTap: () async {
                                                              Map<Permission,
                                                                      PermissionStatus>
                                                                  statuses =
                                                                  await [
                                                                Permission
                                                                    .camera,
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
                                                                      title:
                                                                          '${AppLocalizations.of(context)!.camera_permission}',
                                                                      type: SnackBarType
                                                                          .FAILURE);
                                                                  return;
                                                                }
                                                              } else if (Platform
                                                                  .isIOS) {
                                                                // Navigator.pop(context);
                                                              }
                                                              bloc.add(MoreDetailsEvent
                                                                  .pickLogoImageEvent(
                                                                      context:
                                                                          context,
                                                                      isFromCamera:
                                                                          true));
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        FileSelectionOptionWidget(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context1)!
                                                                .gallery,
                                                            icon: Icons.photo,
                                                            lastItem: state
                                                                    .companyLogo
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
                                                                    Navigator.pop(
                                                                        context1);
                                                                    CustomSnackBar.showSnackBar(
                                                                        context:
                                                                            context,
                                                                        title:
                                                                            '${AppLocalizations.of(context)!.storage_permission}',
                                                                        type: SnackBarType
                                                                            .FAILURE);
                                                                    return;
                                                                  }
                                                                }
                                                              } else if (Platform
                                                                  .isIOS) {
                                                                // Navigator.pop(context);
                                                              }
                                                              bloc.add(MoreDetailsEvent
                                                                  .pickLogoImageEvent(
                                                                      context:
                                                                          context,
                                                                      isFromCamera:
                                                                          false));
                                                              Navigator.pop(
                                                                  context1);
                                                            }),
                                                        state.companyLogo
                                                                .isEmpty
                                                            ? 0.width
                                                            : FileSelectionOptionWidget(
                                                                title: AppLocalizations
                                                                        .of(
                                                                            context1)!
                                                                    .remove,
                                                                icon: Icons
                                                                    .delete,
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
                                                                        bloc.add(MoreDetailsEvent.deleteFileEvent(
                                                                            context:
                                                                                context));
                                                                        Navigator.pop(
                                                                            context2);
                                                                      },
                                                                    ),
                                                                  );
                                                                })
                                                      ],
                                                    ),
                                                  ),
                                              backgroundColor:
                                                  Colors.transparent);
                                        },
                                        child: Container(
                                          color: AppColors.whiteColor,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              state.isUpdate
                                                  ? state.companyLogo.isNotEmpty
                                                      ? state.image.path != ''
                                                          ? Expanded(
                                                              child: SizedBox(
                                                                // height:
                                                                //     getScreenHeight(
                                                                //             context) *
                                                                //         0.18,
                                                                width:
                                                                    getScreenWidth(
                                                                        context),
                                                                child:
                                                                    Image.file(
                                                                  File(state
                                                                      .image
                                                                      .path),
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              height: getScreenHeight(
                                                                      context) *
                                                                  0.19,
                                                              width:
                                                                  getScreenWidth(
                                                                      context),
                                                              child:
                                                                  Image.network(
                                                                '${AppUrls.baseFileUrl}${state.companyLogo}',
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
                                                                    color: AppColors
                                                                        .whiteColor,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      AppStrings
                                                                          .failedToLoadString,
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
                                                      : Icon(
                                                          Icons
                                                              .camera_alt_rounded,
                                                          color: AppColors
                                                              .blueColor,
                                                          size: 30,
                                                        )
                                                  : state.image.path != ''
                                                      ? SizedBox(
                                                          height:
                                                              getScreenHeight(
                                                                      context) *
                                                                  0.18,
                                                          width: getScreenWidth(
                                                              context),
                                                          child: Image.file(
                                                            File(state
                                                                .image.path),
                                                            fit: BoxFit.contain,
                                                          ),
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .camera_alt_rounded,
                                                          color: AppColors
                                                              .blueColor,
                                                          size: 30,
                                                        ),
                                              state.isUpdate
                                                  ? state.companyLogo.isNotEmpty
                                                      ? SizedBox()
                                                      : Align(
                                                          child: Container(
                                                            width:
                                                                getScreenWidth(
                                                                    context),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .upload_photo,
                                                              style: AppStyles.rkRegularTextStyle(
                                                                  size: AppConstants
                                                                      .font_14,
                                                                  color: AppColors
                                                                      .textColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                        )
                                                  : state.image.path != ''
                                                      ? const SizedBox()
                                                      : Align(
                                                          child: Container(
                                                            width:
                                                                getScreenWidth(
                                                                    context),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .upload_photo,
                                                              style: AppStyles
                                                                  .rkRegularTextStyle(
                                                                size:
                                                                    AppConstants
                                                                        .font_14,
                                                                color: AppColors
                                                                    .textColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  50.height,
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
                                            if (_formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              bloc.add(MoreDetailsEvent
                                                  .registrationApiEvent(
                                                      context: context));
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

}
