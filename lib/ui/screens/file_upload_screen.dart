import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/file_upload_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../bloc/file_upload/file_upload_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/button_widget.dart';
import '../widget/common_alert_dialog.dart';
import '../widget/custom_button_widget.dart';
import '../widget/file_selection_option_widget.dart';

class FileUploadScreenRoute {
  static Widget get route => const FileUploadScreen();
}

class FileUploadScreen extends StatelessWidget {
  const FileUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    debugPrint(
        "isUpdate : ${args?.containsKey(AppStrings.isUpdateParamString)}");
    return BlocProvider(
      create: (context) => FileUploadBloc()
        ..add(FileUploadEvent.getFormsListEvent(
            context: context,
            isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false
                ? true
                : false))
      // ..add(FileUploadEvent.getFilesListEvent(context: context))
      /*..add(FileUploadEvent.getProfileFilesAndFormsEvent(
            context: context,
            isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false
                ? true
                : false))*/
      ,
      child: const FileUploadScreenWidget(),
    );
  }
}

class FileUploadScreenWidget extends StatelessWidget {
  const FileUploadScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FileUploadBloc bloc = context.read<FileUploadBloc>();
    return BlocListener<FileUploadBloc, FileUploadState>(
      listener: (context, state) {
        if (state.isFileSizeExceeds) {
          CustomSnackBar.showSnackBar(
              context: context,
              title:
                  '${AppLocalizations.of(context)!.file_size_must_be_less_then}',
              type: SnackBarType.FAILURE);
        }
        ;
      },
      child: BlocBuilder<FileUploadBloc, FileUploadState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              // if (state.isDownloading) {
              //   return Future.value(false);
              // } else {
              return Future.value(true);
              // }
            },
            child: Scaffold(
              backgroundColor: AppColors.whiteColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                titleSpacing: 0,
                leadingWidth: 60,
                title: Text(AppLocalizations.of(context)!.forms_files,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.smallFont,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor)),
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.blackColor,
                    )),
              ),
              body: Stack(
                children: [
                  state.isShimmering
                      ? FileUploadScreenShimmerWidget()
                      : SafeArea(
                          child: state.isLoading
                              ? Container(
                                  height: getScreenHeight(context),
                                  child: Center(
                                    child: CupertinoActivityIndicator(
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppConstants.padding_20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        state.formsAndFilesList.isEmpty
                                            ? Container(
                                                height:
                                                    getScreenHeight(context),
                                                width: getScreenWidth(context),
                                                child: Center(
                                                  child: Text(
                                                    '${AppLocalizations.of(context)!.forms_Files_not_available}',
                                                    style: AppStyles
                                                        .rkRegularTextStyle(
                                                            size: AppConstants
                                                                .normalFont,
                                                            color: AppColors
                                                                .textColor),
                                                  ),
                                                ),
                                              )
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: state
                                                    .formsAndFilesList.length,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return buildFormsAndFilesUploadFields(
                                                    fileIndex: index,
                                                    context: context,
                                                    fileName: state
                                                            .formsAndFilesList[
                                                                index]
                                                            .name ??
                                                        '',
                                                    url: state
                                                            .formsAndFilesList[
                                                                index]
                                                            .url ??
                                                        '',
                                                    localUrl: state
                                                            .formsAndFilesList[
                                                                index]
                                                            .localUrl ??
                                                        '',
                                                    isUploading:
                                                        state.isUploadLoading,
                                                    uploadIndex:
                                                        state.uploadIndex,
                                                    isDownloadable: state
                                                            .formsAndFilesList[
                                                                index]
                                                            .isForm ??
                                                        false,
                                                  );
                                                },
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
                                          fontColors: AppColors.whiteColor,
                                          isLoading: state.isApiLoading,
                                          onPressed: state.isApiLoading
                                              ? null
                                              : () {
                                                  bloc.add(FileUploadEvent
                                                      .uploadApiEvent(
                                                          context: context));
                                                },
                                          bGColor: AppColors.mainColor,
                                        ),
                                        20.height,
                                        state.isUpdate
                                            ? 0.width
                                            : CustomButtonWidget(
                                                buttonText: AppLocalizations.of(
                                                        context)!
                                                    .skip,
                                                fontColors: AppColors.mainColor,
                                                borderColor:
                                                    AppColors.mainColor,
                                                onPressed: () async {
                                                  CustomSnackBar.showSnackBar(
                                                      context: context,
                                                      title:
                                                          '${AppLocalizations.of(context)!.registered_successfully}',
                                                      type:
                                                          SnackBarType.SUCCESS);
                                                  Navigator.popUntil(
                                                      context,
                                                      (route) =>
                                                          route.name ==
                                                          RouteDefine
                                                              .connectScreen
                                                              .name);
                                                  Navigator.pushNamed(
                                                      context,
                                                      RouteDefine
                                                          .bottomNavScreen
                                                          .name);
                                                },
                                                bGColor: AppColors.whiteColor,
                                              ),
                                        20.height,
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                  state.isDownloading
                      ? Container(
                    height: getScreenHeight(context),
                          width: getScreenWidth(context),
                          color: Color.fromARGB(20, 0, 0, 0),
                          alignment: Alignment.center,
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(AppConstants.radius_10))),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CupertinoActivityIndicator(
                                  color: AppColors.blackColor,
                                  radius: AppConstants.radius_10,
                                ),
                                10.height,
                                Text(
                                  '${state.downloadProgress}%',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.font_14,
                                      color: AppColors.blackColor),
                                )
                              ],
                            ),
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

  Widget buildFormsAndFilesUploadFields({
    required int fileIndex,
    required String fileName,
    required BuildContext context,
    required String url,
    required bool isDownloadable,
    required bool isUploading,
    required int uploadIndex,
    required String localUrl,
  }) {
    return Container(
      margin: EdgeInsets.only(top: AppConstants.padding_10),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 35,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fileName.toTitleCase(),
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w400),
                ),
                isDownloadable /* && url.isNotEmpty*/
                    ? ButtonWidget(
                  buttonText: AppLocalizations.of(context)!.download,
                        fontSize: AppConstants.smallFont,
                        radius: AppConstants.radius_5,
                        bGColor: AppColors.blueColor,
                        onPressed: () async {
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.storage,
                          ].request();
                          if (Platform.isAndroid) {
                            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                            AndroidDeviceInfo androidInfo =
                                await deviceInfo.androidInfo;
                            debugPrint(
                                'Running on android version ${androidInfo.version.sdkInt}');
                            if (androidInfo.version.sdkInt < 33) {
                              if (!statuses[Permission.storage]!.isGranted) {
                                debugPrint('Dont go');
                                CustomSnackBar.showSnackBar(
                                    context: context,
                                    title:
                                        '${AppLocalizations.of(context)!.storage_permission}',
                                    type: SnackBarType.FAILURE);
                                return;
                              }
                            }
                          } else {
                            //for ios permission
                          }
                          context.read<FileUploadBloc>().add(
                              FileUploadEvent.downloadFileEvent(
                                  context: context, fileIndex: fileIndex));
                        },
                        fontColors: AppColors.whiteColor,
                      )
                    : 0.height,
              ],
            ),
          ),
          10.height,
          DottedBorder(
            color: AppColors.borderColor,
            strokeWidth: 1,
            radius: Radius.circular(AppConstants.radius_3),
            borderType: BorderType.RRect,
            dashPattern: [3, 2],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (isUploading) {
                      CustomSnackBar.showSnackBar(
                          context: context,
                          title: AppStrings.uploadingMsgString,
                          type: SnackBarType.FAILURE);
                      return;
                    }
                    showModalBottomSheet(
                        context: context,
                        builder: (context1) => Container(
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.only(
                                    topRight:
                                        Radius.circular(AppConstants.radius_20),
                                    topLeft: Radius.circular(
                                        AppConstants.radius_20)),
                              ),
                              clipBehavior: Clip.hardEdge,
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppConstants.padding_30,
                                  vertical: AppConstants.padding_20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.upload_photo,
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.normalFont,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  30.height,
                                  FileSelectionOptionWidget(
                                      title:
                                          AppLocalizations.of(context)!.camera,
                                      icon: Icons.camera_alt_rounded,
                                      onTap: () async {
                                        Map<Permission, PermissionStatus>
                                            statuses = await [
                                          Permission.camera,
                                        ].request();
                                        if (Platform.isAndroid) {
                                          if (!statuses[Permission.camera]!
                                              .isGranted) {
                                            Navigator.pop(context);
                                            CustomSnackBar.showSnackBar(
                                                context: context,
                                                title:
                                                    '${AppLocalizations.of(context)!.camera_permission}',
                                                type: SnackBarType.FAILURE);
                                            return;
                                          }
                                        } else if (Platform.isIOS) {
                                          // Navigator.pop(context);
                                        }
                                        context.read<FileUploadBloc>().add(
                                            FileUploadEvent.pickDocumentEvent(
                                                context: context,
                                                isFromCamera: true,
                                                fileIndex: fileIndex,
                                                isDocument: false));
                                        Navigator.pop(context1);
                                      }),
                                  FileSelectionOptionWidget(
                                      title:
                                          AppLocalizations.of(context)!.gallery,
                                      icon: Icons.photo,
                                      onTap: () async {
                                        Map<Permission, PermissionStatus>
                                            statuses = await [
                                          Permission.storage,
                                        ].request();
                                        if (Platform.isAndroid) {
                                          DeviceInfoPlugin deviceInfo =
                                              DeviceInfoPlugin();
                                          AndroidDeviceInfo androidInfo =
                                              await deviceInfo.androidInfo;
                                          if (androidInfo.version.sdkInt < 33) {
                                            if (!statuses[Permission.storage]!
                                                .isGranted) {
                                              Navigator.pop(context);
                                              CustomSnackBar.showSnackBar(
                                                  context: context,
                                                  title:
                                                      '${AppLocalizations.of(context)!.storage_permission}',
                                                  type: SnackBarType.FAILURE);
                                              return;
                                            }
                                          }
                                        } else if (Platform.isIOS) {
                                          // Navigator.pop(context);
                                        }
                                        context.read<FileUploadBloc>().add(
                                            FileUploadEvent.pickDocumentEvent(
                                                context: context,
                                                isFromCamera: false,
                                                fileIndex: fileIndex,
                                                isDocument: false));
                                        Navigator.pop(context1);
                                      }),
                                  FileSelectionOptionWidget(
                                      title: '${AppLocalizations.of(context)!.document}',
                                      icon: Icons.file_open_rounded,
                                      lastItem: url.isEmpty ? true : false,
                                      onTap: () async {
                                        Map<Permission, PermissionStatus>
                                            statuses = await [
                                          Permission.storage,
                                        ].request();
                                        if (Platform.isAndroid) {
                                          DeviceInfoPlugin deviceInfo =
                                              DeviceInfoPlugin();
                                          AndroidDeviceInfo androidInfo =
                                              await deviceInfo.androidInfo;
                                          if (androidInfo.version.sdkInt < 33) {
                                            if (!statuses[Permission.storage]!
                                                .isGranted) {
                                              Navigator.pop(context);
                                              CustomSnackBar.showSnackBar(
                                                  context: context,
                                                  title:
                                                      '${AppLocalizations.of(context)!.storage_permission}',
                                                  type: SnackBarType.FAILURE);
                                              return;
                                            }
                                          }
                                        } else if (Platform.isIOS) {
                                          // Navigator.pop(context);
                                        }
                                        context.read<FileUploadBloc>().add(
                                            FileUploadEvent.pickDocumentEvent(
                                                context: context,
                                                isFromCamera: false,
                                                fileIndex: fileIndex,
                                                isDocument: true));
                                        Navigator.pop(context);
                                      }),
                                  url.isEmpty
                                      ? 0.width
                                      : FileSelectionOptionWidget(
                                          title: AppLocalizations.of(context)!
                                              .remove,
                                          icon: Icons.delete,
                                          iconColor: AppColors.redColor,
                                          lastItem: true,
                                          onTap: () {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context2) =>
                                                  CommonAlertDialog(
                                                title: '${AppLocalizations.of(context)!.remove}',
                                                subTitle: '${AppLocalizations.of(context)!.are_you_sure}',
                                                positiveTitle: '${AppLocalizations.of(context)!.yes}',
                                                negativeTitle: '${AppLocalizations.of(context)!.no}',
                                                negativeOnTap: () {
                                                  Navigator.pop(context2);
                                                },
                                                positiveOnTap: () async {
                                                  context
                                                      .read<FileUploadBloc>()
                                                      .add(FileUploadEvent
                                                          .deleteFileEvent(
                                                              context: context,
                                                              index:
                                                                  fileIndex));
                                                  Navigator.pop(context2);
                                                },
                                              ),
                                            );
                                          }),
                                ],
                              ),
                            ),
                        backgroundColor: Colors.transparent);
                  },
                  child: isUploading && uploadIndex == fileIndex
                      ? Container(
                          height: 150,
                          color: AppColors.whiteColor,
                          width: getScreenWidth(context),
                          alignment: Alignment.center,
                          child: CupertinoActivityIndicator(),
                        )
                      : url.isNotEmpty
                          ? Container(
                              height: 150,
                              color: AppColors.whiteColor,
                              width: getScreenWidth(context),
                              alignment: Alignment.center,
                              child: url.split('.').last.contains('pdf') ||
                                      url.split('.').last.contains('doc') ||
                                      url.split('.').last.contains('docx')
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(
                                              context.rtl ? pi : 0),
                                          child: Icon(
                                            Icons.file_copy_outlined,
                                            color: AppColors.blueColor,
                                            size: 30,
                                          ),
                                        ),
                                        5.height,
                                        Text(
                                          "${url.split('.').first.split('/').last}.${url.split('.').last}",
                                          style: AppStyles.rkRegularTextStyle(
                                              size: AppConstants.font_14,
                                              color: AppColors.textColor,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )
                                  : url.contains(AppStrings.tempString)
                                      ? Image.file(
                                          File(localUrl),
                                          fit: BoxFit.cover,
                                          width: double.maxFinite,
                                        )
                                      :CachedNetworkImage(
                                imageUrl: "${AppUrls.baseFileUrl}$url",
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                                placeholder: (context, url) =>Center(
                                  child:
                                  CupertinoActivityIndicator(
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Text(
                                    AppStrings.failedToLoadString,
                                    style: AppStyles
                                        .rkRegularTextStyle(
                                        size: AppConstants
                                            .smallFont,
                                        color: AppColors
                                            .textColor),
                                  ),
                                ),
                              ),
                             /* Image.network(
                                          "${AppUrls.baseFileUrl}$url",
                                          fit: BoxFit.cover,
                                          width: double.maxFinite,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                  color: AppColors.blackColor,
                                                ),
                                              );
                                            }
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                              child: Text(
                                                AppStrings.failedToLoadString,
                                                style: AppStyles
                                                    .rkRegularTextStyle(
                                                        size: AppConstants
                                                            .smallFont,
                                                        color: AppColors
                                                            .textColor),
                                              ),
                                            );
                                          },
                                        ),*/
                            )
                          : Container(
                              height: 150,
                              color: AppColors.whiteColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_rounded,
                                    color: AppColors.blueColor,
                                    size: 30,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.upload_photo,
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.font_14,
                                        color: AppColors.textColor,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
