import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/file_upload/file_upload_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/button_widget.dart';
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
          backgroundColor: AppColors.pageColor,
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
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.1, right: screenWidth * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.height,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(AppLocalizations.of(context)!.promissory_note,
                    //         style: AppStyles.rkRegularTextStyle(
                    //             size: AppConstants.smallFont,
                    //             color: AppColors.textColor,
                    //             fontWeight: FontWeight.w400)),
                    //     // ButtonWidget(
                    //     //   buttonText: AppLocalizations.of(context)!.taken_down,
                    //     //   height: 30,
                    //     //   fontSize: AppConstants.smallFont,
                    //     //   radius: AppConstants.radius_5,
                    //     //   bGColor: AppColors.blueColor,
                    //     //   onPressed: () {
                    //     //     bloc.add(FileUploadEvent.deleteFileEvent(
                    //     //         fileIndex: 1,));
                    //     //   },
                    //     //   fontColors: AppColors.whiteColor,
                    //     // ),
                    //   ],
                    // ),
                    // 10.height,
                    // ContainerWidget(fileIndex: 1),
                    buildFileUploadFields(
                      fileIndex: 1,
                      context: context,
                      title: AppLocalizations.of(context)!.promissory_note,
                      state: state,
                    ),
                    30.height,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(AppLocalizations.of(context)!.personal_guarantee,
                    //         style: AppStyles.rkRegularTextStyle(
                    //             size: AppConstants.smallFont,
                    //             color: AppColors.textColor,
                    //             fontWeight: FontWeight.w400)),
                    //     // ButtonWidget(
                    //     //   buttonText: AppLocalizations.of(context)!.taken_down,
                    //     //   height: 30,
                    //     //   fontSize: AppConstants.smallFont,
                    //     //   radius: AppConstants.radius_5,
                    //     //   bGColor: AppColors.blueColor,
                    //     //   onPressed: () {
                    //     //     bloc.add(FileUploadEvent.deleteFileEvent(
                    //     //         fileIndex: 2,));
                    //     //   },
                    //     //   fontColors: AppColors.whiteColor,
                    //     // ),
                    //   ],
                    // ),
                    // 10.height,
                    buildFileUploadFields(
                      fileIndex: 2,
                      context: context,
                      title: AppLocalizations.of(context)!.personal_guarantee,
                      state: state,
                    ),
                    // ContainerWidget(fileIndex: 2),
                    30.height,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(AppLocalizations.of(context)!.photo_tz,
                    //         style: AppStyles.rkRegularTextStyle(
                    //             size: AppConstants.smallFont,
                    //             color: AppColors.textColor,
                    //             fontWeight: FontWeight.w400)),
                    //     ButtonWidget(
                    //       buttonText: AppLocalizations.of(context)!.taken_down,
                    //       height: 30,
                    //       fontSize: AppConstants.smallFont,
                    //       radius: AppConstants.radius_5,
                    //       bGColor: AppColors.blueColor,
                    //       onPressed: () {
                    //         bloc.add(FileUploadEvent.deleteFileEvent(
                    //             fileIndex: 3,));
                    //       },
                    //       fontColors: AppColors.whiteColor,
                    //     ),
                    //   ],
                    // ),
                    // 10.height,
                    buildFileUploadFields(
                      fileIndex: 3,
                      context: context,
                      title: AppLocalizations.of(context)!.photo_tz,
                      state: state,
                    ),
                    // ContainerWidget(fileIndex: 3),
                    30.height,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(AppLocalizations.of(context)!.business_certificate,
                    //         style: AppStyles.rkRegularTextStyle(
                    //             size: AppConstants.smallFont,
                    //             color: AppColors.textColor,
                    //             fontWeight: FontWeight.w400)),
                    //     // ButtonWidget(
                    //     //   buttonText: AppLocalizations.of(context)!.taken_down,
                    //     //   height: 30,
                    //     //   fontSize: AppConstants.smallFont,
                    //     //   radius: AppConstants.radius_5,
                    //     //   bGColor: AppColors.blueColor,
                    //     //   onPressed: () {
                    //     //     bloc.add(FileUploadEvent.deleteFileEvent(
                    //     //         fileIndex: 4,));
                    //     //   },
                    //     //   fontColors: AppColors.whiteColor,
                    //     // ),
                    //   ],
                    // ),
                    // 10.height,
                    buildFileUploadFields(
                      fileIndex: 4,
                      context: context,
                      title: AppLocalizations.of(context)!.business_certificate,
                      state: state,
                    ),
                    // ContainerWidget(fileIndex: 4),
                    40.height,
                    ButtonWidget(
                      buttonText: state.isUpdate
                          ? AppLocalizations.of(context)!.save
                          : AppLocalizations.of(context)!.continued,
                      fontColors: AppColors.whiteColor,
                      width: double.maxFinite,
                      onPressed: () {
                        bloc.add(
                            FileUploadEvent.uploadApiEvent(context: context));
                      },
                      bGColor: AppColors.mainColor,
                    ),
                    10.height,
                    state.isUpdate
                        ? 0.width
                        : ButtonWidget(
                            buttonText: AppLocalizations.of(context)!.skip,
                            fontColors: AppColors.mainColor,
                            borderColor: AppColors.mainColor,
                            width: double.maxFinite,
                            onPressed: () {
                              showSnackBar(
                                  context: context,
                                  title: AppStrings.registerSuccessString,
                                  bgColor: AppColors.mainColor);
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

  Widget buildFileUploadFields(
      {required int fileIndex,
      required String title,
      required BuildContext context,
      required FileUploadState state}) {
    return Container(
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
                  title,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w400),
                ),
                fileIndex == 4 && state.businessCertificate.path.isNotEmpty
                    ? ButtonWidget(
                        buttonText: AppLocalizations.of(context)!.taken_down,
                        fontSize: AppConstants.smallFont,
                        radius: AppConstants.radius_5,
                        bGColor: AppColors.blueColor,
                        onPressed: () {
                          context.read<FileUploadBloc>().add(
                              FileUploadEvent.downloadFileEvent(
                                  context: context, fileIndex: 4));
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                  30.height,
                                  FileSelectionOptionWidget(
                                      title:
                                          AppLocalizations.of(context)!.camera,
                                      icon: Icons.camera,
                                      onTap: () {
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
                                      onTap: () {
                                        context.read<FileUploadBloc>().add(
                                            FileUploadEvent.pickDocumentEvent(
                                                context: context,
                                                isFromCamera: false,
                                                fileIndex: fileIndex,
                                                isDocument: false));
                                        Navigator.pop(context1);
                                      }),
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
                                  FileSelectionOptionWidget(
                                      title: AppLocalizations.of(context)!
                                          .taken_down,
                                      icon: Icons.delete,
                                      onTap: () {
                                        context.read<FileUploadBloc>().add(
                                            FileUploadEvent.deleteFileEvent(
                                                fileIndex: fileIndex));
                                        Navigator.pop(context);
                                      }),
                                ],
                              ),
                            ),
                        backgroundColor: Colors.transparent);
                    // showAlertDialogBox(context, fileIndex);
                  },
                  child: state.promissoryNote.path != "" && fileIndex == 1
                      ? Container(
                          height: 150,
                          color: AppColors.whiteColor,
                          width: getScreenWidth(context),
                          alignment: Alignment.center,
                          child: state.isPromissoryNoteDocument
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.file_copy_outlined,
                                      color: AppColors.blueColor,
                                      size: 30,
                                    ),
                                    5.height,
                                    Text(
                                      state.promissoryNote.path.split('/').last,
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.font_14,
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )
                              : Image.file(
                                  state.promissoryNote,
                                  fit: BoxFit.cover,
                                  width: double.maxFinite,
                                ))
                      : state.personalGuarantee.path != "" && fileIndex == 2
                          ? Container(
                              height: 150,
                              width: getScreenWidth(context),
                              alignment: Alignment.center,
                              color: AppColors.whiteColor,
                              child: state.isPersonalGuaranteeDocument
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
                                          state.personalGuarantee.path
                                              .split('/')
                                              .last,
                                          style: AppStyles.rkRegularTextStyle(
                                              size: AppConstants.font_14,
                                              color: AppColors.textColor,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    )
                                  : Image.file(
                                      state.personalGuarantee,
                                      fit: BoxFit.cover,
                                      width: double.maxFinite,
                                    ))
                          : state.photoOfTZ.path != "" && fileIndex == 3
                              ? Container(
                                  height: 150,
                                  width: getScreenWidth(context),
                                  color: AppColors.whiteColor,
                                  alignment: Alignment.center,
                                  child: state.isPhotoOfTZDocument
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
                                              state.photoOfTZ.path
                                                  .split('/')
                                                  .last,
                                              style:
                                                  AppStyles.rkRegularTextStyle(
                                                      size:
                                                          AppConstants.font_14,
                                                      color:
                                                          AppColors.textColor,
                                                      fontWeight:
                                                          FontWeight.w400),
                                            ),
                                          ],
                                        )
                                      : Image.file(
                                          state.photoOfTZ,
                                          fit: BoxFit.cover,
                                          width: double.maxFinite,
                                        ))
                              : state.businessCertificate.path != "" &&
                                      fileIndex == 4
                                  ? Container(
                                      height: 150,
                                      width: getScreenWidth(context),
                                      color: AppColors.whiteColor,
                                      alignment: Alignment.center,
                                      child: state.isBusinessCertificateDocument
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
                                                  state.businessCertificate.path
                                                      .split('/')
                                                      .last,
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                          size: AppConstants
                                                              .font_14,
                                                          color: AppColors
                                                              .textColor,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              ],
                                            )
                                          : Image.file(
                                              state.businessCertificate,
                                              fit: BoxFit.cover,
                                              width: double.maxFinite,
                                            ))
                                  : Container(
                                      height: 150,
                                      color: AppColors.whiteColor,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt_rounded,
                                            color: AppColors.blueColor,
                                            size: 30,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .upload_photo,
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

class ContainerWidget extends StatelessWidget {
  final int fileIndex;

  ContainerWidget({super.key, required this.fileIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileUploadBloc, FileUploadState>(
      builder: (context, state) {
        return Container(
          height: getScreenHeight(context) * 0.2,
          alignment: Alignment.center,
          child: DottedBorder(
            color: state.promissoryNote.path == "" && fileIndex == 1
                ? AppColors.borderColor
                : state.personalGuarantee.path == "" && fileIndex == 2
                    ? AppColors.borderColor
                    : state.photoOfTZ.path == "" && fileIndex == 3
                        ? AppColors.borderColor
                        : state.businessCertificate.path == "" && fileIndex == 4
                            ? AppColors.borderColor
                            : AppColors.whiteColor,
            strokeWidth: state.promissoryNote.path == "" && fileIndex == 1
                ? 2
                : state.personalGuarantee.path == "" && fileIndex == 2
                    ? 2
                    : state.photoOfTZ.path == "" && fileIndex == 3
                        ? 2
                        : state.businessCertificate.path == "" && fileIndex == 4
                            ? 2
                            : 0,
            dashPattern: state.promissoryNote.path == "" && fileIndex == 1
                ? [5, 3]
                : state.personalGuarantee.path == "" && fileIndex == 2
                    ? [5, 3]
                    : state.photoOfTZ.path == "" && fileIndex == 3
                        ? [5, 3]
                        : state.businessCertificate.path == "" && fileIndex == 4
                            ? [5, 3]
                            : [1, 0],
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
                                          AppConstants.radius_20),
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
                                      AppLocalizations.of(context)!
                                          .upload_photo,
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.normalFont,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    30.height,
                                    FileSelectionOptionWidget(
                                        title: AppLocalizations.of(context)!
                                            .camera,
                                        icon: Icons.camera,
                                        onTap: () {
                                          context.read<FileUploadBloc>().add(
                                              FileUploadEvent.pickDocumentEvent(
                                                  context: context,
                                                  isFromCamera: true,
                                                  fileIndex: fileIndex,
                                                  isDocument: false));
                                          Navigator.pop(context);
                                        }),
                                    FileSelectionOptionWidget(
                                        title: AppLocalizations.of(context)!
                                            .gallery,
                                        icon: Icons.photo,
                                        onTap: () {
                                          context.read<FileUploadBloc>().add(
                                              FileUploadEvent.pickDocumentEvent(
                                                  context: context,
                                                  isFromCamera: false,
                                                  fileIndex: fileIndex,
                                                  isDocument: false));
                                          Navigator.pop(context);
                                        }),
                                    FileSelectionOptionWidget(
                                        title: AppLocalizations.of(context)!
                                            .gallery,
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
                                  ],
                                ),
                              ),
                          backgroundColor: Colors.transparent);
                      // showAlertDialogBox(context, fileIndex);
                    },
                    child: state.promissoryNote.path != "" && fileIndex == 1
                        ? SizedBox(
                            height: 130,
                            width: getScreenWidth(context),
                            child: state.isPromissoryNoteDocument
                                ? Text(
                                    state.promissoryNote.path.split('/').last)
                                : Image.file(
                                    File(state.promissoryNote.path),
                                    fit: BoxFit.fill,
                                  ))
                        : state.personalGuarantee.path != "" && fileIndex == 2
                            ? SizedBox(
                                height: 130,
                                width: getScreenWidth(context),
                                child: state.isPersonalGuaranteeDocument
                                    ? Text(state.personalGuarantee.path
                                        .split('/')
                                        .last)
                                    : Image.file(
                                        File(state.personalGuarantee.path),
                                        fit: BoxFit.fill,
                                      ))
                            : state.photoOfTZ.path != "" && fileIndex == 3
                                ? SizedBox(
                                    height: 130,
                                    width: getScreenWidth(context),
                                    child: state.isPhotoOfTZDocument
                                        ? Text(state.photoOfTZ.path
                                            .split('/')
                                            .last)
                                        : Image.file(
                                            File(state.photoOfTZ.path),
                                            fit: BoxFit.fill,
                                          ))
                                : state.businessCertificate.path != "" &&
                                        fileIndex == 4
                                    ? SizedBox(
                                        height: 130,
                                        width: getScreenWidth(context),
                                        child:
                                            state.isBusinessCertificateDocument
                                                ? Text(state
                                                    .businessCertificate.path
                                                    .split('/')
                                                    .last)
                                                : Image.file(
                                                    File(state
                                                        .businessCertificate
                                                        .path),
                                                    fit: BoxFit.fill,
                                                  ))
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt_rounded,
                                            color: AppColors.blueColor,
                                            size: 30,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .upload_photo,
                                            style: AppStyles.rkRegularTextStyle(
                                                size: AppConstants.font_14,
                                                color: AppColors.textColor,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      )),
                // state.promissoryNote.path == "" && fileIndex == 1
                //     ? Container(
                //         width: screenWidth,
                //         alignment: Alignment.center,
                //         child: Text(
                //           AppLocalizations.of(context)!.upload_photo,
                //           style: AppStyles.rkRegularTextStyle(
                //               size: AppConstants.font_14,
                //               color: AppColors.textColor,
                //               fontWeight: FontWeight.w400),
                //         ),
                //       )
                //     : state.personalGuarantee.path == "" && fileIndex == 2
                //         ? Container(
                //             width: screenWidth,
                //             alignment: Alignment.center,
                //             child: Text(
                //               AppLocalizations.of(context)!.upload_photo,
                //               style: AppStyles.rkRegularTextStyle(
                //                   size: AppConstants.font_14,
                //                   color: AppColors.textColor,
                //                   fontWeight: FontWeight.w400),
                //             ),
                //           )
                //         : state.photoOfTZ.path == "" && fileIndex == 3
                //             ? Container(
                //                 width: screenWidth,
                //                 alignment: Alignment.center,
                //                 child: Text(
                //                   AppLocalizations.of(context)!.upload_photo,
                //                   style: AppStyles.rkRegularTextStyle(
                //                       size: AppConstants.font_14,
                //                       color: AppColors.textColor,
                //                       fontWeight: FontWeight.w400),
                //                 ),
                //               )
                //             : state.businessCertificate.path == "" &&
                //                     fileIndex == 4
                //                 ? Container(
                //                     width: screenWidth,
                //                     alignment: Alignment.center,
                //                     child: Text(
                //                       AppLocalizations.of(context)!
                //                           .upload_photo,
                //                       style: AppStyles.rkRegularTextStyle(
                //                           size: AppConstants.font_14,
                //                           color: AppColors.textColor,
                //                           fontWeight: FontWeight.w400),
                //                     ),
                //                   )
                //                 : const SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }

// void showAlertDialogBox(BuildContext context, int fileIndex) {
//   showDialog(
//     context: context,
//     builder: (c1) {
//       return BlocBuilder<FileUploadBloc, FileUploadState>(
//         builder: (c1, state) {
//           return AlertDialog(
//             actionsPadding: EdgeInsets.only(
//                 left: AppConstants.padding_15,
//                 right: AppConstants.padding_15,
//                 top: AppConstants.padding_15,
//                 bottom: AppConstants.padding_30),
//             title: Align(
//                 alignment: Alignment.center,
//                 child: Text(AppLocalizations.of(context)!.upload_photo)),
//             actions: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   GestureDetector(
//                       onTap: () {
//                         context.read<FileUploadBloc>().add(
//                             FileUploadEvent.pickDocumentEvent(
//                                 context: context,
//                                 fileIndex: fileIndex,
//                                 isFromCamera: true));
//                         Navigator.pop(c1);
//                       },
//                       child: Icon(Icons.camera_alt_rounded)),
//                   GestureDetector(
//                       onTap: () {
//                         context.read<FileUploadBloc>().add(
//                             FileUploadEvent.pickDocumentEvent(
//                                 context: context,
//                                 fileIndex: fileIndex,
//                                 isFromCamera: false));
//                         Navigator.pop(c1);
//                       },
//                       child: Icon(Icons.photo)),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Text(AppLocalizations.of(context)!.camera),
//                   Text(AppLocalizations.of(context)!.gallery),
//                 ],
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }
}
