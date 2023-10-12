import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/profile_req_model/profile_model.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/more_details/more_details_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
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
        ..add(MoreDetailsEvent.addFilterListEvent())
        ..add(MoreDetailsEvent.getProfileMoreDetailsEvent(
            context: context,
            isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false
                ? true
                : false))
        ..add(MoreDetailsEvent.getProfileModelEvent(
          profileModel: args?[AppStrings.profileParamString] ?? ProfileModel(),
          context: context,
        )),
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
    return BlocBuilder<MoreDetailsBloc, MoreDetailsState>(
      builder: (context, state) {
        if (list.isEmpty) {
          list = [...state.cityList];
        }
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
            title: Text(
              AppLocalizations.of(context)!.more_details,
              style: AppStyles.rkRegularTextStyle(
                  size: 16, color: Colors.black, fontWeight: FontWeight.w400),
            ),
            backgroundColor: Colors.transparent,
            titleSpacing: 0,
            elevation: 0,
          ),
          body: SafeArea(
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
                            context: context,
                            isScrollControlled: true,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topRight:
                                        Radius.circular(AppConstants.radius_20),
                                    topLeft: Radius.circular(
                                        AppConstants.radius_20)),
                                borderSide: BorderSide.none),
                            builder: (context1) {
                              return ValueListenableBuilder(
                                  valueListenable: listNotifier,
                                  builder: (context, _content, child) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        height: getScreenHeight(context) * 0.9,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                      style: AppStyles
                                                          .rkRegularTextStyle(
                                                              size: AppConstants
                                                                  .mediumFont,
                                                              color: AppColors
                                                                  .blackColor)),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context1);
                                                    },
                                                    child: Icon(Icons.close))
                                              ],
                                            ),
                                            15.height,
                                            CustomFormField(
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: AppColors.borderColor,
                                              ),
                                              onChangeValue: (value) {
                                                bloc.add(MoreDetailsEvent
                                                    .citySearchEvent(
                                                  search: value,
                                                ));
                                                list = state.cityList
                                                    .where((city) =>
                                                        city.contains(value))
                                                    .toList();
                                                print('length:${list.length}');
                                                listNotifier.value = list;
                                              },
                                              controller: state.cityController,
                                              keyboardType: TextInputType.text,
                                              hint:
                                                  AppLocalizations.of(context)!
                                                      .life_grocery_store,
                                              fillColor: AppColors.whiteColor,
                                              textInputAction:
                                                  TextInputAction.next,
                                              validator: '',
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              autofocus: true,
                                              cursorColor: AppColors.mainColor,
                                            ),
                                            7.height,
                                            list.isEmpty
                                                ? Expanded(
                                                    child: Center(
                                                      child: Text(
                                                        'Cities not available',
                                                        style: AppStyles
                                                            .rkRegularTextStyle(
                                                                size: AppConstants
                                                                    .smallFont,
                                                                color: AppColors
                                                                    .textColor),
                                                      ),
                                                    ),
                                                  )
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: list.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            bloc.add(MoreDetailsEvent
                                                                .selectCityEvent(
                                                                    city: list[
                                                                        index],
                                                                    context:
                                                                        context));
                                                            Navigator.pop(
                                                                context1);
                                                          },
                                                          child: Text(
                                                            list[index]
                                                                .toString(),
                                                            style: AppStyles
                                                                .rkRegularTextStyle(
                                                                    size: AppConstants
                                                                        .mediumFont),
                                                          ),
                                                        ),
                                                      );
                                                    },
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
                            border: Border.all(color: AppColors.borderColor),
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppConstants.radius_3)),
                          ),
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.padding_10),
                            child: Text(
                              state.selectCity,
                              style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.mediumFont,
                                  color: AppColors.blackColor),
                              // textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ),
                      7.height,
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.full_address,
                      ),
                      CustomFormField(
                        controller: state.addressController,
                        keyboardType: TextInputType.text,
                        hint: AppLocalizations.of(context)!.life_grocery_store,
                        fillColor: AppColors.whiteColor,
                        textInputAction: TextInputAction.next,
                        validator: AppStrings.addressValString,
                      ),
                      7.height,
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.email,
                      ),
                      CustomFormField(
                        controller: state.emailController,
                        keyboardType: TextInputType.emailAddress,
                        hint: "test2gmail.com",
                        fillColor: AppColors.whiteColor,
                        textInputAction: TextInputAction.next,
                        validator: AppStrings.emailValString,
                      ),
                      7.height,
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.fax,
                      ),
                      CustomFormField(
                        controller: state.faxController,
                        keyboardType: TextInputType.number,
                        hint: AppLocalizations.of(context)!.fax,
                        fillColor: AppColors.whiteColor,
                        textInputAction: TextInputAction.done,
                        validator: AppStrings.faxValString,
                      ),
                      7.height,
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.logo_image,
                        star: '',
                      ),
                      Container(
                        height: getScreenHeight(context) * 0.2,
                        alignment: Alignment.center,
                        child: DottedBorder(
                          color: state.isImagePick
                              ? AppColors.whiteColor
                              : AppColors.borderColor,
                          radius: Radius.circular(AppConstants.radius_3),
                          borderType: BorderType.RRect,
                          strokeWidth: state.isImagePick ? 0 : 1,
                          dashPattern: state.isImagePick ? [1, 0] : [3, 2],
                          child: Container(
                            color: AppColors.whiteColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.whiteColor,
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(
                                                          AppConstants
                                                              .radius_20),
                                                      topLeft: Radius.circular(
                                                          AppConstants
                                                              .radius_20)),
                                                ),
                                                clipBehavior: Clip.hardEdge,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        AppConstants.padding_30,
                                                    vertical: AppConstants
                                                        .padding_20),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                                      .bold),
                                                    ),
                                                    30.height,
                                                    FileSelectionOptionWidget(
                                                        title:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .camera,
                                                        icon: Icons.camera,
                                                        onTap: () {
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
                                                        title:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .gallery,
                                                        icon: Icons.photo,
                                                        onTap: () {
                                                          bloc.add(MoreDetailsEvent
                                                              .pickLogoImageEvent(
                                                                  context:
                                                                      context,
                                                                  isFromCamera:
                                                                      false));
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  ],
                                                ),
                                              ),
                                          backgroundColor: Colors.transparent);
                                    },
                                    child: state.isUpdate
                                        ? state.companyLogo.isNotEmpty
                                            ? state.image.path != ''
                                                ? SizedBox(
                                                    height: getScreenHeight(
                                                            context) *
                                                        0.18,
                                                    width:
                                                        getScreenWidth(context),
                                                    child: Image.file(
                                                      File(state.image.path),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: getScreenHeight(
                                                            context) *
                                                        0.19,
                                                    width:
                                                        getScreenWidth(context),
                                                    child: Image.network(
                                                      '${AppUrls.baseFileUrl}' +
                                                          '${state.companyLogo}',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                            : Icon(
                                                Icons.camera_alt_rounded,
                                                color: AppColors.blueColor,
                                                size: 30,
                                              )
                                        : state.isImagePick
                                            ? SizedBox(
                                                height:
                                                    getScreenHeight(context) *
                                                        0.18,
                                                width: getScreenWidth(context),
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
                                state.isUpdate
                                    ? state.companyLogo.isNotEmpty
                                        ? SizedBox()
                                        : Align(
                                            child: Container(
                                              width: getScreenWidth(context),
                                              alignment: Alignment.center,
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .upload_photo,
                                                style: AppStyles
                                                    .rkRegularTextStyle(
                                                        size: AppConstants
                                                            .font_14,
                                                        color:
                                                            AppColors.textColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ),
                                          )
                                    : state.isImagePick
                                        ? const SizedBox()
                                        : Align(
                                            child: Container(
                                              width: getScreenWidth(context),
                                              alignment: Alignment.center,
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .upload_photo,
                                                style: AppStyles
                                                    .rkRegularTextStyle(
                                                        size: AppConstants
                                                            .font_14,
                                                        color:
                                                            AppColors.textColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ),
                                          ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      50.height,
                      CustomButtonWidget(
                        buttonText: state.isUpdate
                            ? AppLocalizations.of(context)!.save
                            : AppLocalizations.of(context)!.next,
                        bGColor: AppColors.mainColor,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            bloc.add(MoreDetailsEvent.registrationApiEvent(
                                context: context));

                            /*      if (state.isUpdate) {
                              if (state.image.path.isNotEmpty) {
                                bloc.add(MoreDetailsEvent
                                    .registrationApiEvent(
                                        context: context));
                              } else {
                                showSnackBar(
                                    context: context,
                                    title: AppStrings.selectCompanyLogoString,
                                    bgColor: AppColors.redColor);
                              }
                            }*/
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
    );
  }

  void alertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (c1) {
        return AlertDialog(
          actionsPadding: EdgeInsets.only(
              left: AppConstants.padding_15,
              right: AppConstants.padding_15,
              top: AppConstants.padding_15,
              bottom: AppConstants.padding_30),
          title: Align(
              alignment: Alignment.center,
              child: Text(AppLocalizations.of(context)!.upload_photo)),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap: () {
                      context.read<MoreDetailsBloc>().add(
                          MoreDetailsEvent.pickLogoImageEvent(
                              context: context, isFromCamera: true));
                      Navigator.pop(c1);
                    },
                    child: Icon(Icons.camera_alt_rounded)),
                GestureDetector(
                    onTap: () {
                      context.read<MoreDetailsBloc>().add(
                          MoreDetailsEvent.pickLogoImageEvent(
                              context: context, isFromCamera: false));
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
  }
}
