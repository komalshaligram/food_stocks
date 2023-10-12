import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/file_upload/file_upload_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/button_widget.dart';
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
        ..add(FileUploadEvent.getFormsListEvent(context: context))
        ..add(FileUploadEvent.getFilesListEvent(context: context))
        ..add(FileUploadEvent.getProfileFilesAndFormsEvent(
            context: context,
            isUpdate: args?.containsKey(AppStrings.isUpdateParamString) ?? false
                ? true
                : false)),
      child: const FileUploadScreenWidget(),
    );
  }
}

class FileUploadScreenWidget extends StatelessWidget {
  const FileUploadScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    FileUploadBloc bloc = context.read<FileUploadBloc>();
    return BlocBuilder<FileUploadBloc, FileUploadState>(
      builder: (context, state) {
        return Scaffold(
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.1, right: screenWidth * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    state.isLoading
                        ? Container(
                            height: getScreenHeight(context) - 56,
                            width: getScreenWidth(context),
                            child: Center(
                              child: CupertinoActivityIndicator(
                                color: AppColors.blackColor,
                              ),
                            ),
                          )
                        : state.formsAndFilesList.isEmpty
                            ? Container(
                                height: getScreenHeight(context),
                                width: getScreenWidth(context),
                                child: Center(
                                  child: Text(
                                    'No Files And Forms available',
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.normalFont,
                                        color: AppColors.textColor),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.formsAndFilesList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return buildFormsAndFilesUploadFields(
                                    fileIndex: index,
                                    context: context,
                                    fileName:
                                        state.formsAndFilesList[index].name ??
                                            '',
                                    url: state.formsAndFilesList[index].url ??
                                        '',
                                    localUrl: state.formsAndFilesList[index]
                                            .localUrl ??
                                        '',
                                    isUploading: state.isUploadLoading,
                                    uploadIndex: state.uploadIndex,
                                    isDownloadable: state
                                            .formsAndFilesList[index]
                                            .isDownloadable ??
                                        false,
                                  );
                                },
                              ),
                    40.height,
                    CustomButtonWidget(
                      buttonText: state.isUpdate
                          ? AppLocalizations.of(context)!.save.toUpperCase()
                          : AppLocalizations.of(context)!.next.toUpperCase(),
                      fontColors: AppColors.whiteColor,
                      isLoading: state.isApiLoading,
                      onPressed: state.isApiLoading
                          ? null
                          : () {
                              bloc.add(FileUploadEvent.uploadApiEvent(
                                  context: context));
                            },
                      bGColor: AppColors.mainColor,
                    ),
                    20.height,
                    state.isUpdate
                        ? 0.width
                        : CustomButtonWidget(
                            buttonText: AppLocalizations.of(context)!.skip,
                            fontColors: AppColors.mainColor,
                            borderColor: AppColors.mainColor,
                            onPressed: () async {
                              // SharedPreferencesHelper preferencesHelper =
                              //     SharedPreferencesHelper(
                              //         prefs: await SharedPreferences
                              //             .getInstance());
                              // preferencesHelper.setUserLoggedIn(
                              //     isLoggedIn: true);
                              showSnackBar(
                                  context: context,
                                  title: AppStrings.registerSuccessString,
                                  bgColor: AppColors.mainColor);
                              Navigator.popUntil(
                                  context,
                                  (route) =>
                                      route.name ==
                                      RouteDefine.connectScreen.name);
                              Navigator.pushNamed(
                                  context, RouteDefine.bottomNavScreen.name);
                            },
                            bGColor: AppColors.whiteColor,
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
                  fileName,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w400),
                ),
                isDownloadable && url.isNotEmpty
                    ? ButtonWidget(
                  buttonText: AppLocalizations.of(context)!.download,
                        fontSize: AppConstants.smallFont,
                        radius: AppConstants.radius_5,
                        bGColor: AppColors.blueColor,
                        onPressed: () {
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
                                      onTap: () {
                                        context.read<FileUploadBloc>().add(
                                            FileUploadEvent.pickDocumentEvent(
                                                context: context,
                                                isFromCamera: true,
                                                fileIndex: fileIndex,
                                                isDocument: false));
                                        Navigator.pop(context1);
                                      }),
                                  Container(
                                    height: 1,
                                    width: getScreenWidth(context),
                                    color:
                                        AppColors.borderColor.withOpacity(0.5),
                                  ),
                                  FileSelectionOptionWidget(
                                      title:
                                          AppLocalizations.of(context)!.gallery,
                                      icon: Icons.photo,
                                      onTap: () {
                                        context.read<FileUploadBloc>().add(
                                            FileUploadEvent.pickDocumentEvent(
                                                context: context,
                                                isFromCamera: false,
                                                fileIndex: fileIndex,
                                                isDocument: false));
                                        Navigator.pop(context1);
                                      }),
                                  Container(
                                    height: 1,
                                    width: getScreenWidth(context),
                                    color:
                                        AppColors.borderColor.withOpacity(0.5),
                                  ),
                                  FileSelectionOptionWidget(
                                      title: "Document",
                                      icon: Icons.file_open_rounded,
                                      onTap: () {
                                        context.read<FileUploadBloc>().add(
                                            FileUploadEvent.pickDocumentEvent(
                                                context: context,
                                                isFromCamera: false,
                                                fileIndex: fileIndex,
                                                isDocument: true));
                                        Navigator.pop(context);
                                      }),
                                  Container(
                                    height: 1,
                                    width: getScreenWidth(context),
                                    color:
                                        AppColors.borderColor.withOpacity(0.5),
                                  ),
                                  FileSelectionOptionWidget(
                                      title:
                                          AppLocalizations.of(context)!.remove,
                                      icon: Icons.delete,
                                      onTap: () {
                                        context.read<FileUploadBloc>().add(
                                            FileUploadEvent.deleteFileEvent(
                                                context: context,
                                                index: fileIndex));
                                        Navigator.pop(context);
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
                                        Icon(
                                          Icons.file_copy_outlined,
                                          color: AppColors.blueColor,
                                          size: 30,
                                        ),
                                        5.height,
                                        Text(
                                          "${url.split('.').first.split('/').last}.${url.split('.').last}",
                                          style: AppStyles.rkRegularTextStyle(
                                              size: AppConstants.font_14,
                                              color: AppColors.textColor,
                                              fontWeight: FontWeight.w400),
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
                                      : Image.network(
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
                                        ),
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
