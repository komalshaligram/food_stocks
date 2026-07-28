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
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/common_alert_dialog.dart';
import '../widget/common_app_bar.dart';
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
    bool isRegisterFile = args?[AppStrings.isRegisterFileString] ?? false;

    return BlocProvider(
      create: (context) => FileUploadBloc()
        ..add(FileUploadEvent.getFormsListEvent(
            context: context,
            isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false
                ? true
                : false)),
      child: FileUploadScreenWidget(isRegisterFile: isRegisterFile),
    );
  }
}

class FileUploadScreenWidget extends StatelessWidget {
  final bool isRegisterFile;

  const FileUploadScreenWidget({required this.isRegisterFile, super.key});

  static const double _horizontalPadding = 16;
  static const double _uploadRadius = 12;

  @override
  Widget build(BuildContext context) {
    FileUploadBloc bloc = context.read<FileUploadBloc>();
    return BlocListener<FileUploadBloc, FileUploadState>(
      listener: (context, state) {},
      child: BlocBuilder<FileUploadBloc, FileUploadState>(
          builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            SharedPreferencesHelper preferences = SharedPreferencesHelper(
                prefs: await SharedPreferences.getInstance());
            if (!preferences.getUserLoggedIn() || state.isUpdate) {
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: AppLocalizations.of(context)!.files,
                iconData: Icons.arrow_back_ios_new_rounded,
                trailingWidget: _buildAppBarIcon(),
                onTap: () async {
                  SharedPreferencesHelper preferences = SharedPreferencesHelper(
                      prefs: await SharedPreferences.getInstance());
                  if (!preferences.getUserLoggedIn() || state.isUpdate) {
                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
            ),
            body: Stack(
              children: [
                state.isShimmering
                    ? const FileUploadScreenShimmerWidget()
                    : state.isLoading
                        ? Center(
                            child: CupertinoActivityIndicator(
                                color: AppColors.mainColor,
                                radius: AppConstants.radius_20))
                        : SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(
                                _horizontalPadding, 8, _horizontalPadding, 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (state.formsAndFilesList.isEmpty)
                                  SizedBox(
                                    height: getScreenHeight(context) * 0.5,
                                    child: noDataWidget(
                                        AppLocalizations.of(context)!
                                            .forms_Files_not_available),
                                  )
                                else
                                  ...List.generate(
                                      state.formsAndFilesList.length, (index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: index <
                                                  state.formsAndFilesList
                                                          .length -
                                                      1
                                              ? 12
                                              : 0),
                                      child: buildFormsAndFilesUploadFields(
                                        isForm: state.formsAndFilesList[index]
                                                .isForm ??
                                            false,
                                        updateState: state.isUpdate,
                                        directionality: state.language,
                                        fileIndex: index,
                                        context: context,
                                        fileName: state.formsAndFilesList[index]
                                                .name ??
                                            '',
                                        url: state
                                                .formsAndFilesList[index].url ??
                                            '',
                                        localUrl: state.formsAndFilesList[index]
                                                .localUrl ??
                                            '',
                                        isUploading: state.isUploadLoading,
                                        uploadIndex: state.uploadIndex,
                                        isDownloadable: state
                                                .formsAndFilesList[index]
                                                .isForm ??
                                            false,
                                        isRemoveProcess: state.isRemoveProcess,
                                        isRegisterString: isRegisterFile,
                                      ),
                                    );
                                  }),
                                if (!state.isUpdate &&
                                    state.formsAndFilesList.isNotEmpty) ...[
                                  24.height,
                                  CustomButtonWidget(
                                    buttonText: AppLocalizations.of(context)!
                                        .next
                                        .toUpperCase(),
                                    fontColors: AppColors.whiteColor,
                                    isLoading: state.isApiLoading,
                                    radius: 14,
                                    onPressed: state.isApiLoading
                                        ? null
                                        : () {
                                            if (state
                                                    .formsAndFilesList[1].url !=
                                                null) {
                                              bloc.add(FileUploadEvent
                                                  .uploadApiEvent(
                                                      context: context));
                                            } else {
                                              CustomSnackBar.showSnackBar(
                                                  context: context,
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .upload_document,
                                                  type: SnackBarType.failure);
                                            }
                                          },
                                    bGColor: AppColors.mainColor,
                                  ),
                                ],
                              ],
                            ),
                          ),
                if (state.isDownloading)
                  Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.04),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowColor
                                    .withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CupertinoActivityIndicator(
                                  color: AppColors.mainColor,
                                  radius: AppConstants.radius_10),
                              12.height,
                              Text(
                                '${state.downloadProgress}%',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.font_14,
                                    color: AppColors.blackColor
                                        .withValues(alpha: 0.7)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAppBarIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.mainColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.folder_open_outlined,
          size: 21, color: AppColors.mainColor),
    );
  }

  Widget _buildFormCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildDownloadButton(
      {required BuildContext context, required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.mainColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_rounded,
                  size: 16, color: AppColors.mainColor),
              const SizedBox(width: 4),
              Text(
                AppLocalizations.of(context)!.download,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_13,
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
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
    required bool isRemoveProcess,
    required String directionality,
    required bool updateState,
    required bool isForm,
    required bool isRegisterString,
  }) {
    return _buildFormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: fileName == AppStrings.textIdProof
                    ? RichText(
                        text: TextSpan(
                          text: fileName.toTitleCase(),
                          style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_14,
                            color: AppColors.blackColor.withValues(alpha: 0.88),
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: AppStyles.rkRegularTextStyle(
                                  color: AppColors.redColor,
                                  size: AppConstants.font_14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        fileName.toTitleCase(),
                        style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.font_14,
                          color: AppColors.blackColor.withValues(alpha: 0.88),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
              if (isDownloadable)
                _buildDownloadButton(
                  context: context,
                  onPressed: () async {
                    Map<Permission, PermissionStatus> statuses =
                        await [Permission.storage].request();
                    if (Platform.isAndroid) {
                      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      AndroidDeviceInfo androidInfo =
                          await deviceInfo.androidInfo;

                      if (androidInfo.version.sdkInt < 33) {
                        if (!statuses[Permission.storage]!.isGranted) {
                          CustomSnackBar.showSnackBar(
                              context: context,
                              title: AppLocalizations.of(context)!
                                  .storage_permission,
                              type: SnackBarType.failure);
                          return;
                        }
                      }
                    }
                    context.read<FileUploadBloc>().add(
                        FileUploadEvent.downloadFileEvent(
                            context: context, fileIndex: fileIndex));
                  },
                ),
            ],
          ),
          12.height,
          DottedBorder(
            color: AppColors.mainColor.withValues(alpha: 0.35),
            strokeWidth: 1.2,
            radius: const Radius.circular(_uploadRadius),
            borderType: BorderType.RRect,
            dashPattern: const [6, 4],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_uploadRadius),
              child: Material(
                color: AppColors.pageColor,
                child: InkWell(
                  onTap: () => _onUploadAreaTap(
                    context: context,
                    fileIndex: fileIndex,
                    fileName: fileName,
                    url: url,
                    isUploading: isUploading,
                    uploadIndex: uploadIndex,
                    isForm: isForm,
                    isRegisterString: isRegisterString,
                    directionality: directionality,
                  ),
                  child: _buildUploadContent(
                    context: context,
                    url: url,
                    localUrl: localUrl,
                    updateState: updateState,
                    isUploading: isUploading,
                    uploadIndex: uploadIndex,
                    fileIndex: fileIndex,
                    isRemoveProcess: isRemoveProcess,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onUploadAreaTap({
    required BuildContext context,
    required int fileIndex,
    required String fileName,
    required String url,
    required bool isUploading,
    required int uploadIndex,
    required bool isForm,
    required bool isRegisterString,
    required String directionality,
  }) {
    if (isRegisterString != true) {
      if (isUploading) {
        CustomSnackBar.showSnackBar(
            context: context,
            title: AppLocalizations.of(context)!.wait_while_uploading,
            type: SnackBarType.failure);
        return;
      }
      if (isForm && url.isNotEmpty) {
        Navigator.pushNamed(context, RouteDefine.previewScreen.name,
            arguments: {
              AppStrings.privacyPolicyPdfString: url,
              AppStrings.clientFormString: fileName
            });
      }
      return;
    }

    if (isUploading && uploadIndex == fileIndex) {
      CustomSnackBar.showSnackBar(
          context: context,
          title: AppLocalizations.of(context)!.wait_while_uploading,
          type: SnackBarType.failure);
      return;
    }

    if (isForm && url.isNotEmpty) {
      Navigator.pushNamed(context, RouteDefine.previewScreen.name, arguments: {
        AppStrings.privacyPolicyPdfString: url,
        AppStrings.clientFormString: fileName
      });
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context1) => Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.padding_20,
            vertical: AppConstants.padding_20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.upload_photo,
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.font_17, color: AppColors.blackColor),
            ),
            20.height,
            FileSelectionOptionWidget(
              title: AppLocalizations.of(context)!.camera,
              icon: Icons.camera_alt_rounded,
              onTap: () async {
                Map<Permission, PermissionStatus> statuses =
                    await [Permission.camera].request();
                if (Platform.isAndroid) {
                  if (!statuses[Permission.camera]!.isGranted) {
                    Navigator.pop(context1);
                    CustomSnackBar.showSnackBar(
                        context: context,
                        title: AppLocalizations.of(context)!.camera_permission,
                        type: SnackBarType.failure);
                    return;
                  }
                }
                context.read<FileUploadBloc>().add(
                    FileUploadEvent.pickDocumentEvent(
                        context: context,
                        isFromCamera: true,
                        fileIndex: fileIndex,
                        isDocument: false));
                Navigator.pop(context1);
              },
            ),
            FileSelectionOptionWidget(
              title: AppLocalizations.of(context)!.gallery,
              icon: Icons.photo,
              onTap: () async {
                Map<Permission, PermissionStatus> statuses =
                    await [Permission.storage].request();
                if (Platform.isAndroid) {
                  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                  if (androidInfo.version.sdkInt < 33) {
                    if (!statuses[Permission.storage]!.isGranted) {
                      Navigator.pop(context1);
                      CustomSnackBar.showSnackBar(
                          context: context,
                          title:
                              AppLocalizations.of(context)!.storage_permission,
                          type: SnackBarType.failure);
                      return;
                    }
                  }
                }
                context.read<FileUploadBloc>().add(
                    FileUploadEvent.pickDocumentEvent(
                        context: context,
                        isFromCamera: false,
                        fileIndex: fileIndex,
                        isDocument: false));
                Navigator.pop(context1);
              },
            ),
            FileSelectionOptionWidget(
              title: AppLocalizations.of(context)!.document,
              icon: Icons.file_open_rounded,
              lastItem: url.isEmpty,
              onTap: () async {
                Map<Permission, PermissionStatus> statuses =
                    await [Permission.storage].request();
                if (Platform.isAndroid) {
                  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                  if (androidInfo.version.sdkInt < 33) {
                    if (!statuses[Permission.storage]!.isGranted) {
                      Navigator.pop(context1);
                      CustomSnackBar.showSnackBar(
                          context: context,
                          title:
                              AppLocalizations.of(context)!.storage_permission,
                          type: SnackBarType.failure);
                      return;
                    }
                  }
                }
                context.read<FileUploadBloc>().add(
                    FileUploadEvent.pickDocumentEvent(
                        context: context,
                        isFromCamera: false,
                        fileIndex: fileIndex,
                        isDocument: true));
                Navigator.pop(context1);
              },
            ),
            if (url.isNotEmpty)
              FileSelectionOptionWidget(
                title: AppLocalizations.of(context)!.remove,
                icon: Icons.delete,
                iconColor: AppColors.redColor,
                lastItem: true,
                onTap: () {
                  Navigator.pop(context1);
                  showDialog(
                    context: context,
                    builder: (context2) => CommonAlertDialog(
                      directionality: directionality,
                      title: AppLocalizations.of(context)!.remove,
                      subTitle: AppLocalizations.of(context)!.are_you_sure,
                      positiveTitle: AppLocalizations.of(context)!.yes,
                      negativeTitle: AppLocalizations.of(context)!.no,
                      negativeOnTap: () => Navigator.pop(context2),
                      positiveOnTap: () async {
                        context.read<FileUploadBloc>().add(
                            FileUploadEvent.deleteFileEvent(
                                context: context, index: fileIndex));
                        Navigator.pop(context2);
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadContent({
    required BuildContext context,
    required String url,
    required String localUrl,
    required bool updateState,
    required bool isUploading,
    required int uploadIndex,
    required int fileIndex,
    required bool isRemoveProcess,
  }) {
    if ((isUploading && uploadIndex == fileIndex) ||
        (isRemoveProcess && uploadIndex == fileIndex)) {
      return SizedBox(
        height: 150,
        width: double.infinity,
        child: Center(
            child: CupertinoActivityIndicator(color: AppColors.mainColor)),
      );
    }

    if (url.isNotEmpty) {
      final isDocument = url.split('.').last.contains('pdf') ||
          url.split('.').last.contains('doc') ||
          url.split('.').last.contains('docx');
      if (isDocument) {
        return SizedBox(
          height: 150,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(context.rtl ? pi : 0),
                child: Icon(Icons.insert_drive_file_outlined,
                    color: AppColors.mainColor, size: 36),
              ),
              8.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "${url.split('.').first.split('/').last}.${url.split('.').last}",
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_13,
                      color: AppColors.blackColor.withValues(alpha: 0.65)),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }

      return !updateState
          ? _buildFullWidthImage(
              Image.file(
                File(localUrl),
                width: double.infinity,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            )
          : _buildFullWidthImage(
              CachedNetworkImage(
                imageUrl: "${AppUrlEndPoints.baseFileUrl}$url",
                width: double.infinity,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                placeholder: (context, url) => _buildImagePlaceholder(),
                errorWidget: (context, url, error) {
                  return _buildImageError();
                },
              ),
            );
    }

    return _buildEmptyUploadPlaceholder(context);
  }

  Widget _buildFullWidthImage(Widget image) {
    return SizedBox(
      width: double.infinity,
      child: image,
    );
  }

  Widget _buildImagePlaceholder() {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child:
          Center(child: CupertinoActivityIndicator(color: AppColors.mainColor)),
    );
  }

  Widget _buildImageError() {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Center(
        child: Text(AppStrings.failedToLoadString,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont, color: AppColors.textColor)),
      ),
    );
  }

  Widget _buildEmptyUploadPlaceholder(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.mainColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.add_photo_alternate_outlined,
                color: AppColors.mainColor, size: 26),
          ),
          10.height,
          Text(
            AppLocalizations.of(context)!.upload_photo,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.font_13,
                color: AppColors.blackColor.withValues(alpha: 0.55),
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
