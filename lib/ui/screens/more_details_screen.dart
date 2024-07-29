import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/profile_req_model/profile_model.dart';
import 'package:food_stock/ui/widget/more_details_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/more_details/more_details_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
      create: (context) => MoreDetailsBloc() ..add(MoreDetailsEvent.getProfileMoreDetailsEvent(
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
    return BlocListener<MoreDetailsBloc, MoreDetailsState>(
      listener: (context, state) {
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
              title: Align(
                alignment: context.rtl?Alignment.centerRight:Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.more_details,
                  style:
                      AppStyles.rkRegularTextStyle(size: 16, color: Colors.black),
                ),
              ),
              backgroundColor: AppColors.whiteColor,
              titleSpacing: 0,
              elevation: 0,
            ),
            body: state.isShimmering
                ? MoreDetailsScreenShimmerWidget()
                : SingleChildScrollView(
                  child: Column(
                      children: [
                        SafeArea(
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
                                                  child: SizedBox(
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
                                                            Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .city,
                                                                style: AppStyles.rkRegularTextStyle(
                                                                    size: AppConstants
                                                                        .mediumFont,
                                                                    color: AppColors
                                                                        .blackColor)),
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
                                        .street_name,
                                  ),
                                  CustomFormField(
                                    context: context,
                                    controller: state.streetNameController,
                                    inputformet: [
                                      /*FilteringTextInputFormatter.deny(
                                  RegExp(r'\s')),*/
                                      LengthLimitingTextInputFormatter(50)
                                    ],
                                    keyboardType: TextInputType.text,
                                    hint: '',
                                    fillColor: AppColors.whiteColor,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.streetNameValString,
                                  ),
                                  7.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!
                                        .street_number,
                                  ),
                                  CustomFormField(
                                    context: context,
                                    controller: state.streetNumberController,
                                    inputformet: [
                                      /*FilteringTextInputFormatter.deny(
                                  RegExp(r'\s')),*/
                                      LengthLimitingTextInputFormatter(50)
                                    ],
                                    keyboardType: TextInputType.number,
                                    hint: '',
                                    fillColor: AppColors.whiteColor,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.streetNumberValString,
                                  ),
                                  7.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!.email,
                                  ),
                                  CustomFormField(
                                    context: context,
                                    controller: state.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    hint: "",
                                    fillColor: AppColors.whiteColor,
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.emailValString,
                                  ),
                                  7.height,

                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!.zip,
                                    star: '*',
                                  ),
                                  CustomFormField(
                                    context: context,
                                    controller: state.zipController,
                                    inputformet: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    textDirection:
                                    context.rtl ? TextDirection.ltr : null,
                                    keyboardType: TextInputType.number,
                                    hint: AppLocalizations.of(context)!.zip,
                                    fillColor: AppColors.whiteColor,
                                    textInputAction: TextInputAction.done,
                                    validator: AppStrings.zipValString,

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
                                      if(state.selectCity != ''){
                                        if (_formKey.currentState?.validate() ?? false) {
                                          bloc.add(MoreDetailsEvent
                                              .registrationApiEvent(
                                              context: context));
                                        }
                                      }
                                      else{
                                        CustomSnackBar.showSnackBar(
                                            context: context,
                                            title: '${AppLocalizations.of(context)!.please_enter_city}',
                                            type: SnackBarType.FAILURE);
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
                ),
          );
        },
      ),
    );
  }
}
