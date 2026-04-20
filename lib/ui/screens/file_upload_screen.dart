import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/widget/file_upload_screen_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/file_upload/file_upload_bloc.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
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
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    bool isRegisterFile = args?[AppStrings.isRegisterFileString] ?? false;

    return BlocProvider(
      create: (context) => FileUploadBloc()
        ..add(FileUploadEvent.getFormsListEvent(
          context: context,
          isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false ? true : false,
        )),
      child: FileUploadScreenWidget(isRegisterFile: isRegisterFile),
    );
  }
}

class FileUploadScreenWidget extends StatelessWidget {
  final bool isRegisterFile;
  const FileUploadScreenWidget({required this.isRegisterFile, super.key});
  @override
  Widget build(BuildContext context) {
    FileUploadBloc bloc = context.read<FileUploadBloc>();
    return BlocListener<FileUploadBloc, FileUploadState>(
      listener: (context, state) {},
      child: BlocBuilder<FileUploadBloc, FileUploadState>(builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
            if (!preferences.getUserLoggedIn() || state.isUpdate) {
              return Future.value(true);
            } else {
              return Future.value(false);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: AppColors.whiteColor,
              elevation: 0,
              titleSpacing: 0,
              leadingWidth: 60,
              title: Align(
                alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.files,
                  style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, fontWeight: FontWeight.w400, color: AppColors.blackColor),
                ),
              ),
              leading: GestureDetector(
                  onTap: () async {
                    SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
                    if (!preferences.getUserLoggedIn() || state.isUpdate) {
                      Navigator.pop(context);
                    }
                  },
                  child: Icon(Icons.arrow_back_ios, color: AppColors.blackColor)),
            ),
            body: Stack(children: [
              state.isShimmering
                  ? const FileUploadScreenShimmerWidget()
                  : SafeArea(
                      child: state.isLoading
                          ? SizedBox(height: getScreenHeight(context), child: Center(child: CupertinoActivityIndicator(color: AppColors.mainColor)))
                          : SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_20),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  state.formsAndFilesList.isEmpty
                                      ? SizedBox(
                                          height: getScreenHeight(context),
                                          width: getScreenWidth(context),
                                          child: noDataWidget(AppLocalizations.of(context)!.forms_Files_not_available),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: state.formsAndFilesList.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return buildFormsAndFilesUploadFields(
                                              isForm: state.formsAndFilesList[index].isForm ?? false,
                                              updateState: state.isUpdate,
                                              directionality: state.language,
                                              fileIndex: index,
                                              context: context,
                                              fileName: state.formsAndFilesList[index].name ?? '',
                                              url: state.formsAndFilesList[index].url ?? '',
                                              localUrl: state.formsAndFilesList[index].localUrl ?? '',
                                              isUploading: state.isUploadLoading,
                                              uploadIndex: state.uploadIndex,
                                              isDownloadable: state.formsAndFilesList[index].isForm ?? false,
                                              isRemoveProcess: state.isRemoveProcess,
                                              isRegisterString: isRegisterFile,
                                            );
                                          }),
                                  SizedBox(height: getScreenHeight(context) * 0.05),
                                  Padding(
                                    padding: const EdgeInsets.all(AppConstants.padding_8),
                                    child: Column(children: [
                                      !state.isUpdate
                                          ? CustomButtonWidget(
                                              buttonText: AppLocalizations.of(context)!.next.toUpperCase(),
                                              fontColors: AppColors.whiteColor,
                                              isLoading: state.isApiLoading,
                                              onPressed: state.isApiLoading
                                                  ? null
                                                  : () {
                                                      if (state.formsAndFilesList[1].url != null) {
                                                        bloc.add(FileUploadEvent.uploadApiEvent(context: context));
                                                      } else {
                                                        CustomSnackBar.showSnackBar(
                                                          context: context,
                                                          title: AppLocalizations.of(context)!.upload_document,
                                                          type: SnackBarType.failure,
                                                        );
                                                      }
                                                    },
                                              bGColor: AppColors.mainColor,
                                            )
                                          : const SizedBox(),
                                      15.height,
                                    ]),
                                  )
                                ]),
                              ),
                            ),
                    ),
              state.isDownloading
                  ? Container(
                      height: getScreenHeight(context),
                      width: getScreenWidth(context),
                      color: const Color.fromARGB(20, 0, 0, 0),
                      alignment: Alignment.center,
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10))),
                        alignment: Alignment.center,
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          CupertinoActivityIndicator(color: AppColors.blackColor, radius: AppConstants.radius_10),
                          10.height,
                          Text('${state.downloadProgress}%', style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor)),
                        ]),
                      ),
                    )
                  : 0.width,
            ]),
          ),
        );
      }),
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
    required bool isRemoveProcess,
    required String directionality,
    required bool updateState,
    required bool isForm,
    required bool isRegisterString,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: AppConstants.padding_10),
      alignment: Alignment.center,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 35,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            fileName == AppStrings.textIdProof
                ? RichText(
                    text: TextSpan(
                      text: fileName.toTitleCase(),
                      style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor, fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(text: ' * ', style: AppStyles.rkRegularTextStyle(color: AppColors.redColor, size: AppConstants.smallFont, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  )
                : Text(fileName.toTitleCase(), style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor, fontWeight: FontWeight.w400)),
            isDownloadable
                ? ButtonWidget(
                    buttonText: AppLocalizations.of(context)!.download,
                    fontSize: AppConstants.smallFont,
                    radius: AppConstants.radius_5,
                    bGColor: AppColors.blueColor,
                    onPressed: () async {
                      Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
                      if (Platform.isAndroid) {
                        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

                        if (androidInfo.version.sdkInt < 33) {
                          if (!statuses[Permission.storage]!.isGranted) {
                            CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.storage_permission, type: SnackBarType.failure);
                            return;
                          }
                        }
                      }
                      context.read<FileUploadBloc>().add(FileUploadEvent.downloadFileEvent(context: context, fileIndex: fileIndex));
                    },
                    fontColors: AppColors.whiteColor,
                  )
                : 0.height,
          ]),
        ),
        10.height,
        DottedBorder(
          color: AppColors.borderColor,
          strokeWidth: 1,
          radius: const Radius.circular(AppConstants.radius_3),
          borderType: BorderType.RRect,
          dashPattern: const [3, 2],
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            GestureDetector(
              onTap: () {
                if (isRegisterString != true) {
                  if (isUploading) {
                    CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.wait_while_uploading, type: SnackBarType.failure);
                    return;
                  }
                  if (isForm) {
                    if (url.isNotEmpty) {
                      Navigator.pushNamed(context, RouteDefine.previewScreen.name, arguments: {AppStrings.privacyPolicyPdfString: url, AppStrings.clientFormString: fileName});
                    }
                  }
                } else {
                  if (isUploading && uploadIndex == fileIndex) {
                    CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.wait_while_uploading, type: SnackBarType.failure);
                    return;
                  }

                  if (isForm && url.isNotEmpty) {
                    Navigator.pushNamed(context, RouteDefine.previewScreen.name, arguments: {AppStrings.privacyPolicyPdfString: url, AppStrings.clientFormString: fileName});
                    return;
                  }
                  showModalBottomSheet(
                      context: context,
                      builder: (context1) => Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(AppConstants.radius_20), topLeft: Radius.circular(AppConstants.radius_20)),
                            ),
                            clipBehavior: Clip.hardEdge,
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_30, vertical: AppConstants.padding_20),
                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                              Text(
                                AppLocalizations.of(context)!.upload_photo,
                                style: AppStyles.rkRegularTextStyle(size: AppConstants.normalFont, color: AppColors.blackColor, fontWeight: FontWeight.w600),
                              ),
                              30.height,
                              FileSelectionOptionWidget(
                                  title: AppLocalizations.of(context)!.camera,
                                  icon: Icons.camera_alt_rounded,
                                  onTap: () async {
                                    Map<Permission, PermissionStatus> statuses = await [Permission.camera].request();
                                    if (Platform.isAndroid) {
                                      if (!statuses[Permission.camera]!.isGranted) {
                                        Navigator.pop(context);
                                        CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.camera_permission, type: SnackBarType.failure);
                                        return;
                                      }
                                    } else if (Platform.isIOS) {}
                                    context.read<FileUploadBloc>().add(FileUploadEvent.pickDocumentEvent(
                                          context: context,
                                          isFromCamera: true,
                                          fileIndex: fileIndex,
                                          isDocument: false,
                                        ));
                                    Navigator.pop(context1);
                                  }),
                              FileSelectionOptionWidget(
                                  title: AppLocalizations.of(context)!.gallery,
                                  icon: Icons.photo,
                                  onTap: () async {
                                    Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
                                    if (Platform.isAndroid) {
                                      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                                      if (androidInfo.version.sdkInt < 33) {
                                        if (!statuses[Permission.storage]!.isGranted) {
                                          Navigator.pop(context);
                                          CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.storage_permission, type: SnackBarType.failure);
                                          return;
                                        }
                                      }
                                    } else if (Platform.isIOS) {}
                                    context.read<FileUploadBloc>().add(FileUploadEvent.pickDocumentEvent(
                                          context: context,
                                          isFromCamera: false,
                                          fileIndex: fileIndex,
                                          isDocument: false,
                                        ));
                                    Navigator.pop(context1);
                                  }),
                              FileSelectionOptionWidget(
                                  title: AppLocalizations.of(context)!.document,
                                  icon: Icons.file_open_rounded,
                                  lastItem: url.isEmpty ? true : false,
                                  onTap: () async {
                                    Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
                                    if (Platform.isAndroid) {
                                      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                                      if (androidInfo.version.sdkInt < 33) {
                                        if (!statuses[Permission.storage]!.isGranted) {
                                          Navigator.pop(context);
                                          CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.storage_permission, type: SnackBarType.failure);
                                          return;
                                        }
                                      }
                                    } else if (Platform.isIOS) {}
                                    context.read<FileUploadBloc>().add(FileUploadEvent.pickDocumentEvent(
                                          context: context,
                                          isFromCamera: false,
                                          fileIndex: fileIndex,
                                          isDocument: true,
                                        ));
                                    Navigator.pop(context);
                                  }),
                              url.isEmpty
                                  ? 0.width
                                  : FileSelectionOptionWidget(
                                      title: AppLocalizations.of(context)!.remove,
                                      icon: Icons.delete,
                                      iconColor: AppColors.redColor,
                                      lastItem: true,
                                      onTap: () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (context2) => CommonAlertDialog(
                                              directionality: directionality,
                                              title: AppLocalizations.of(context)!.remove,
                                              subTitle: AppLocalizations.of(context)!.are_you_sure,
                                              positiveTitle: AppLocalizations.of(context)!.yes,
                                              negativeTitle: AppLocalizations.of(context)!.no,
                                              negativeOnTap: () {
                                                Navigator.pop(context2);
                                              },
                                              positiveOnTap: () async {
                                                context.read<FileUploadBloc>().add(FileUploadEvent.deleteFileEvent(context: context, index: fileIndex));
                                                Navigator.pop(context2);
                                              }),
                                        );
                                      }),
                            ]),
                          ),
                      backgroundColor: Colors.transparent);
                }
              },
              child: (isUploading && uploadIndex == fileIndex) || (isRemoveProcess && uploadIndex == fileIndex)
                  ? Container(height: 150, color: AppColors.whiteColor, width: getScreenWidth(context), alignment: Alignment.center, child: const CupertinoActivityIndicator())
                  : url.isNotEmpty
                      ? Container(
                          height: 150,
                          color: AppColors.whiteColor,
                          width: getScreenWidth(context),
                          alignment: Alignment.center,
                          child: url.split('.').last.contains('pdf') || url.split('.').last.contains('doc') || url.split('.').last.contains('docx')
                              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(context.rtl ? pi : 0),
                                    child: Icon(Icons.file_copy_outlined, color: AppColors.blueColor, size: AppConstants.font_30),
                                  ),
                                  5.height,
                                  Text(
                                    "${url.split('.').first.split('/').last}.${url.split('.').last}",
                                    style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.textColor, fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ])
                              : !updateState
                                  ? Image.file(File(localUrl), fit: BoxFit.cover, width: double.maxFinite)
                                  : CachedNetworkImage(
                                      imageUrl: "${AppUrlEndPoints.baseFileUrl}$url",
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.center,
                                      placeholder: (context, url) => Center(child: CupertinoActivityIndicator(color: AppColors.blackColor)),
                                      errorWidget: (context, url, error) {
                                        return Center(
                                          child: Text(AppStrings.failedToLoadString, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor)),
                                        );
                                      }),
                        )
                      : Container(
                          height: 150,
                          color: AppColors.whiteColor,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.camera_alt_rounded, color: AppColors.blueColor, size: AppConstants.font_30),
                            Text(
                              AppLocalizations.of(context)!.upload_photo,
                              style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.textColor, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                          ]),
                        ),
            ),
          ]),
        ),
      ]),
    );
  }
}
