import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/more_details/more_details_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';

import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
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
    Map<dynamic, dynamic>? data =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => MoreDetailsBloc()
        ..add(MoreDetailsEvent.getProfileModelEvent(
            profileModel: data?[AppStrings.profileParamString]))..add(MoreDetailsEvent.addFilterListEvent()),
      child: MoreDetailsScreenWidget(),
    );
  }
}

class MoreDetailsScreenWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
 String city='';
  MoreDetailsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    MoreDetailsBloc bloc = context.read<MoreDetailsBloc>();
    return BlocBuilder<MoreDetailsBloc, MoreDetailsState>(
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
                  left: getScreenWidth(context) * 0.1, right: screenWidth * 0.1),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.height,
                    CustomContainerWidget(
                      name: AppLocalizations.of(context)!.city,
                    ),
                    GestureDetector(
                      onTap: (){
                               showModalBottomSheet(
                            context: context,
                                 isScrollControlled: true,
                            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            builder: (c1) {
                              return BlocBuilder<MoreDetailsBloc, MoreDetailsState>(
                                   builder: (context, state) {
                                return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height: getScreenHeight(context) * 0.9,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      7.height,
                                      Container(
                                        child: Text(AppLocalizations.of(context)!.city,style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont,color: AppColors.blackColor,fontWeight: FontWeight.w400)),
                                      ),
                                      15.height,
                                      CustomFormField(
                                        prefixIcon: Icon(Icons.search,color: AppColors.mainColor),
                                        onChangeValue: (value){
                                          context.read<MoreDetailsBloc>()
                                              .add(MoreDetailsEvent.citySearchEvent(
                                            search: value,
                                          ));
                                        },
                                        controller: state.cityController,
                                        keyboardType: TextInputType.text,
                                        hint: AppLocalizations.of(context)!.life_grocery_store,
                                        fillColor: Colors.transparent,
                                        textInputAction: TextInputAction.next,
                                        validator: '',
                                          textCapitalization: TextCapitalization.words,
                                        autofocus: true,
                                        cursorColor: AppColors.mainColor,
                                      ),
                                      7.height,
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: state.filterList.length,
                                        itemBuilder: (context, index) {
                                          city = state.city;
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: GestureDetector(
                                              onTap: (){
                                                context.read<MoreDetailsBloc>()
                                                  .add(MoreDetailsEvent.selectCityEvent(
                                                  city: state.filterList[index],
                                                  context: c1
                                                ));
                                              },
                                              child: Text(state.filterList[index],
                                              style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont),
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
                            },);
                      },
                      child: Container(
                        height: 42,
                        width: getScreenWidth(context),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 8),
                          child: Text(city,
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont,
                            color: AppColors.blackColor,fontWeight: FontWeight.w400
                          ),
                          ),
                        ) ,
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
                      fillColor: Colors.transparent,
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
                      fillColor: Colors.transparent,
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
                      fillColor: Colors.transparent,
                      textInputAction: TextInputAction.done,
                      validator: AppStrings.faxValString,
                    ),
                    7.height,
                    CustomContainerWidget(
                      name: AppLocalizations.of(context)!.logo_image,
                      star: '',
                    ),
                    Container(
                      height: screenHeight * 0.2,
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
                                  // alertDialog(context);
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      AppConstants.radius_20),
                                                  topLeft: Radius.circular(
                                                      AppConstants.radius_20)),
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
                                                  AppLocalizations.of(context)!
                                                      .upload_photo,
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                          size: AppConstants
                                                              .normalFont,
                                                          color: AppColors
                                                              .blackColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                30.height,
                                                FileSelectionOptionWidget(
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .camera,
                                                    icon: Icons.camera,
                                                    onTap: () {
                                                      bloc.add(MoreDetailsEvent
                                                          .pickLogoImageEvent(
                                                              context: context,
                                                              isFromCamera:
                                                                  true));
                                                      Navigator.pop(context);
                                                    }),
                                                FileSelectionOptionWidget(
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .gallery,
                                                    icon: Icons.photo,
                                                    onTap: () {
                                                      bloc.add(MoreDetailsEvent
                                                          .pickLogoImageEvent(
                                                              context: context,
                                                              isFromCamera:
                                                                  false));
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                            ),
                                          ),
                                      backgroundColor: Colors.transparent);
                                },
                                child: state.isImagePick
                                    ? SizedBox(
                                        height: 130,
                                        width: screenWidth,
                                        child: Image.file(
                                          File(state.image.path),
                                          fit: BoxFit.cover,
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
                                        AppLocalizations.of(context)!
                                            .upload_photo,
                                        style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.font_14,
                                            color: AppColors.textColor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    50.height,
                    CustomButtonWidget(
                      buttonText: AppLocalizations.of(context)!.continued,
                      bGColor: AppColors.mainColor,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                            bloc.add(MoreDetailsEvent
                                .navigateToOperationTimeScreenEvent(
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
