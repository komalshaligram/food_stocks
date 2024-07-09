
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/profile_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/sub_users_profile/sub_users_profile_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_alert_dialog.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';


class SubUsersProfileRoute {
  static Widget get route => SubUserProfileScreen();
}

class SubUserProfileScreen extends StatelessWidget {
  const SubUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    debugPrint("isUpdate : ${args?[AppStrings.isUpdateParamString] ?? ''}");
    debugPrint("subUserId : ${args?[AppStrings.subUserIdString] ?? ''} ");


    return BlocProvider(
      create: (context) => SubUsersProfileBloc()..add(SubUsersProfileEvent.getSubUserByIdEvent(context: context,
        isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false
            ? true
            : false,
        subUserId: args?[AppStrings.subUserIdString] ?? '',
      ))..add(SubUsersProfileEvent.getAppLanguageEvent(context: context)),
      child: SubUserProfileScreenWidget(),
    );
  }
}

class SubUserProfileScreenWidget extends StatelessWidget {
  SubUserProfileScreenWidget({super.key});

  final _formKey = GlobalKey<FormState>();

  String email = '';

  @override
  Widget build(BuildContext context) {
    SubUsersProfileBloc bloc = context.read<SubUsersProfileBloc>();
    return BlocBuilder<SubUsersProfileBloc, SubUsersProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.new_sub_user,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: state.isShimmering && state.isUpdate
                ? ProfileScreenShimmerWidget(isProfileImage: false,)
                : Padding(
                    padding: EdgeInsets.only(
                        left: getScreenWidth(context) * 0.1,
                        right: getScreenWidth(context) * 0.1),
                    child: SafeArea(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            /*Center(
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context1) => Container(
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
                                                  AppLocalizations.of(context1)!
                                                      .upload_photo,
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                          size: AppConstants
                                                              .normalFont,
                                                          color: AppColors
                                                              .blackColor,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                                30.height,
                                                FileSelectionOptionWidget(
                                                    title: AppLocalizations.of(
                                                            context1)!
                                                        .camera,
                                                    icon: Icons
                                                        .camera_alt_rounded,
                                                    onTap: () async {
                                                      Map<Permission,
                                                              PermissionStatus>
                                                          statuses = await [
                                                        Permission.camera,
                                                      ].request();
                                                      if (Platform.isAndroid) {
                                                        if (!statuses[Permission
                                                                .camera]!
                                                            .isGranted) {
                                                          Navigator.pop(
                                                              context1);
                                                          CustomSnackBar.showSnackBar(
                                                              context: context,
                                                              title: AppLocalizations
                                                                      .of(
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
                                                      bloc.add(SubUsersProfileEvent
                                                          .pickProfileImageEvent(
                                                              context: context,
                                                              isFromCamera:
                                                                  true));
                                                      Navigator.pop(context1);
                                                    }),
                                                FileSelectionOptionWidget(
                                                    title: AppLocalizations.of(
                                                            context1)!
                                                        .gallery,
                                                    icon: Icons.photo,
                                                    lastItem: state
                                                            .subUserProfileImage
                                                            .isEmpty
                                                        ? true
                                                        : false,
                                                    onTap: () async {
                                                      Map<Permission,
                                                              PermissionStatus>
                                                          statuses = await [
                                                        Permission.storage,
                                                      ].request();
                                                      if (Platform.isAndroid) {
                                                        DeviceInfoPlugin
                                                            deviceInfo =
                                                            DeviceInfoPlugin();
                                                        AndroidDeviceInfo
                                                            androidInfo =
                                                            await deviceInfo
                                                                .androidInfo;
                                                        if (androidInfo.version
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
                                                      bloc.add(SubUsersProfileEvent
                                                          .pickProfileImageEvent(
                                                              context: context,
                                                              isFromCamera:
                                                                  false));
                                                      Navigator.pop(context);
                                                    }),
                                                state.subUserProfileImage
                                                        .isEmpty
                                                    ? 0.width
                                                    : FileSelectionOptionWidget(
                                                        title:
                                                            AppLocalizations.of(
                                                                    context1)!
                                                                .remove,
                                                        icon: Icons.delete,
                                                        iconColor:
                                                            AppColors.redColor,
                                                        lastItem: true,
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context1);
                                                          showDialog(
                                                            context: context,
                                                            builder: (context2) =>
                                                                CommonAlertDialog(
                                                              directionality:
                                                                  state
                                                                      .language,
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
                                                                bloc.add(SubUsersProfileEvent
                                                                    .deleteFileEvent(
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
                                      backgroundColor: Colors.transparent);
                                },
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
                                        border: Border.all(
                                            width: 0.5,
                                            color: state.subUserProfileImage
                                                    .isNotEmpty
                                                ? AppColors.lightBorderColor
                                                : Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        color:
                                            state.subUserProfileImage.isNotEmpty
                                                ? AppColors.whiteColor
                                                : AppColors.mainColor
                                                    .withOpacity(0.1),
                                      ),
                                      child: state.isUploadingProcess
                                          ? CupertinoActivityIndicator()
                                          : state.isUpdate
                                              ? state.subUserProfileImage
                                                      .isNotEmpty
                                                  ? state.image.path != ''
                                                      ? SizedBox(
                                                          height:
                                                              getScreenHeight(
                                                                      context) *
                                                                  0.18,
                                                          width: getScreenWidth(
                                                              context),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            child: Image.file(
                                                              state.image,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ))
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(40),
                                                          child: Image.network(
                                                            '${AppUrls.baseFileUrl}${state.subUserProfileImage}',
                                                            fit: BoxFit.contain,
                                                            loadingBuilder:
                                                                (context, child,
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
                                                                (context, error,
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
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    AppImagePath
                                                                        .placeholderProfile,
                                                                    width: 80,
                                                                    height: 80,
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                  ));
                                                            },
                                                          ),
                                                        )
                                                  : SvgPicture.asset(
                                                      AppImagePath
                                                          .placeholderProfile,
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.scaleDown,
                                                    )
                                              : state.image.path != ''
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      child: Image.file(
                                                        File(state.image.path),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    )
                                                  : SvgPicture.asset(
                                                      AppImagePath
                                                          .placeholderProfile,
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.scaleDown,
                                                    ),
                                    ),
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
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color:
                                                      AppColors.borderColor)),
                                          child: SvgPicture.asset(
                                              AppImagePath.camera,
                                              colorFilter: ColorFilter.mode(
                                                  AppColors.mainColor,
                                                  BlendMode.srcIn),
                                              fit: BoxFit.scaleDown)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            3.height,
                            Container(
                              width: getScreenWidth(context),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!.profile_picture,
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.font_14,
                                    color: AppColors.textColor),
                              ),
                            ),
                            7.height,*/
                            CustomContainerWidget(
                              name: AppLocalizations.of(context)!.full_name,
                              star: '*',
                            ),
                            CustomFormField(
                              context: context,
                              controller: state.nameController,
                              keyboardType: TextInputType.text,
                              hint: "",
                              fillColor: Colors.white,
                              textInputAction: TextInputAction.next,
                              validator: AppStrings.subUserValString,
                            ),
                            7.height,
                            CustomContainerWidget(
                              name: AppLocalizations.of(context)!.phone_number,
                              star: '*',
                            ),
                            CustomFormField(
                              context: context,
                              controller: state.phoneNumberController,
                              keyboardType: TextInputType.number,
                              hint: "",
                              fillColor: Colors.white,
                              textInputAction: TextInputAction.next,
                              validator: AppStrings.mobileValString,
                            ),
                            7.height,
                            CustomContainerWidget(
                              name: AppLocalizations.of(context)!.email,
                              star: '',
                            ),
                            CustomFormField(
                              context: context,
                              controller: state.emailController,
                              keyboardType: TextInputType.emailAddress,
                              hint: "",
                              fillColor: Colors.white,
                              textInputAction: TextInputAction.next,
                              validator: email.isEmpty
                                  ? ''
                                  : AppStrings.emailValString,
                              onChangeValue: (value) {
                                email = value;
                              },
                            ),
                            7.height,
                            CustomContainerWidget(
                              name: AppLocalizations.of(context)!.israel_id,
                              star: '*',
                            ),
                            CustomFormField(
                              context: context,
                              controller: state.israelIdController,
                              keyboardType: TextInputType.number,
                              hint: "",
                              fillColor: Colors.white,
                              textInputAction: TextInputAction.done,
                              validator: AppStrings.idValString,
                            ),
                            20.height,
                          state.isUpdate || state.isEnable ?  CustomButtonWidget(
                              buttonText: AppLocalizations.of(context)!
                                  .save
                                  .toUpperCase(),
                              bGColor: AppColors.mainColor,
                              isLoading: state.isLoading,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (!state.isUpdate && !state.isEnable) {
                                    bloc.add(
                                        SubUsersProfileEvent.createSubUserEvent(
                                          context: context,
                                        ));
                                  }
                                  else if(state.isUpdate || state.isEnable) {
                                    bloc.add(
                                        SubUsersProfileEvent.updateSubUserEvent(
                                            context: context));
                                  }
                                }
                              },
                              fontColors: AppColors.whiteColor,
                            ) : 0.width,
                            10.height,
                            state.isEnable ?  profileMenuTiles(
                                title:
                                AppLocalizations.of(context)!.account_permission.toCapitalized(),
                                onTap: () {
                                  if(state.isUpdate || state.isEnable){
                                    Navigator.pushNamed(context,
                                        RouteDefine.accountPermissionScreen.name,
                                        arguments: {
                                          AppStrings.subUserIdString:
                                          state.subUserId
                                        });
                                  }

                                }):0.width,

                            10.height,
                            state.isEnable ? profileMenuTiles(
                                title:
                                AppLocalizations.of(context)!.categories_permissions.toCapitalized(),
                                onTap: () {
                                  if(state.isUpdate || state.isEnable){
                                    Navigator.pushNamed(context,
                                        RouteDefine.categoriesPermissionScreen.name,
                                        arguments: {
                                          AppStrings.subUserIdString:
                                          state.subUserId
                                        });
                                  }
                                }) : 0.width,

                            10.height,
                          state.isEnable ?  profileMenuTiles(
                                title:
                                AppLocalizations.of(context)!.brand_permissions.toCapitalized(),
                                onTap: () {
                                  if(state.isUpdate|| state.isEnable){
                                    Navigator.pushNamed(context,
                                        RouteDefine.brandPermissionScreen.name,
                                        arguments: {
                                          AppStrings.subUserIdString:
                                          state.subUserId
                                        });
                                  }
                                }) : 0.width,

                            10.height,
                           state.isEnable ? profileMenuTiles(
                                title:
                                AppLocalizations.of(context)!.supplier_permissions.toCapitalized(),
                                onTap: () {
                                  if(state.isUpdate || state.isEnable){
                                    Navigator.pushNamed(context,
                                        RouteDefine.supplierPermissionScreen.name,
                                        arguments: {
                                          AppStrings.subUserIdString:
                                          state.subUserId
                                        });
                                  }
                                }): 0.width,

                            15.height,
                            state.isEnable ? GestureDetector(
                              onTap: (){
                                deleteConfirmDialog(
                                    bloc: bloc,
                                    context: context,
                                    directionality: state.language,
                                    isDeleteProcess: state.isDeleteProcess);
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .delete_sub_user_account
                                    .toUpperCase(),
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.mediumFont,
                                    color: AppColors.redColor,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ) : 0.width,

                            20.height,
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          bottomNavigationBar:  !state.isUpdate && !state.isEnable ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 20),
            child: CustomButtonWidget(
              buttonText: AppLocalizations.of(context)!
                  .save
                  .toUpperCase(),
              bGColor: AppColors.mainColor,
              isLoading: state.isLoading,
              onPressed: () {
                if (_formKey.currentState!.validate()) {

                  if (!state.isUpdate && !state.isEnable) {
                    bloc.add(
                        SubUsersProfileEvent.createSubUserEvent(
                          context: context,
                        ));
                  }
                  else if(state.isUpdate) {
                    bloc.add(
                        SubUsersProfileEvent.updateSubUserEvent(
                            context: context));
                  }
                }
              },
              fontColors: AppColors.whiteColor,
            ),
          ) : 0.width,
        );
      },
    );
  }

  Widget profileMenuTiles({required title, required void Function() onTap,bool isDelete = false}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
          BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.15),
                blurRadius: AppConstants.blur_10)
          ]),
      margin: EdgeInsets.symmetric(
          vertical: AppConstants.padding_3,
          horizontal: AppConstants.padding_3),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15,vertical: AppConstants.padding_10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont,
                    color: isDelete?AppColors.redColor:AppColors.blackColor),
              ),
              Icon(
                isDelete?Icons.delete:Icons.arrow_forward_ios,
                color:  isDelete?AppColors.redColor:AppColors.blackColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteConfirmDialog({
    required SubUsersProfileBloc bloc,
    required BuildContext context,
    required String directionality,
    required bool isDeleteProcess,
  }) {
    showDialog(
        context: context,
        builder: (context1) {
          return BlocProvider.value(
            value: context.read<SubUsersProfileBloc>(),
            child: BlocBuilder<SubUsersProfileBloc, SubUsersProfileState>(
              builder: (context, state) {
                return CommonAlertDialog(
                  isLogOutProcess: state.isDeleteProcess,
                  directionality: directionality,
                  title: '${AppLocalizations.of(context)!.delete_account}',
                  subTitle: '${AppLocalizations.of(context)!.are_you_sure}',
                  positiveTitle: '${AppLocalizations.of(context)!.yes}',
                  negativeTitle: '${AppLocalizations.of(context)!.no}',
                  negativeOnTap: () {
                    Navigator.pop(context);
                  },
                  positiveOnTap: () async {
                    bloc.add(SubUsersProfileEvent.deleteAccountEvent(
                        context: context, dialogContext: context1));
                  },
                );
              },
            ),
          );
        });
  }

}
