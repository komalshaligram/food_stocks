import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/file_upload/file_upload_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/button_widget.dart';

class FileUploadScreenRoute {
  static Widget get route => const FileUploadScreen();
}

class FileUploadScreen extends StatelessWidget {
  const FileUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileUploadBloc(),
      child: const FileUploadScreenWidget(),
    );
  }
}


class FileUploadScreenWidget extends StatelessWidget {
  const FileUploadScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<FileUploadBloc, FileUploadState>(
  builder: (context, state) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
   appBar: AppBar(
     backgroundColor: AppColors.whiteColor,
     elevation: 0,
     titleSpacing: 0,
     leadingWidth: 60,
     title: Text(AppLocalizations.of(context)!.forms_files,style: AppStyles.rkRegularTextStyle(size: 16,fontWeight: FontWeight.w400,color: AppColors.blackColor)),
     leading:  GestureDetector(
         onTap: (){
           Navigator.pop(context);
         },
         child: Icon(Icons.arrow_back_ios ,color: AppColors.blackColor,)),
   ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.1, right: screenWidth * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height:30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.promissory_note ,
                      style: AppStyles.rkRegularTextStyle(size: 16,color: AppColors.textColor ,fontWeight: FontWeight.w400)),

                    ButtonWidget(
                      buttonText: AppLocalizations.of(context)!.taken_down,
                       height: 30,
                       width: 85,
                      fontSize: 16,
                      radius: 5,
                      bGColor: AppColors.blueColor,
                      onPressed: (){},
                      fontColors: AppColors.whiteColor,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 134,
                  alignment: Alignment.center,
                  child: DottedBorder(
                    color: state.promissoryNote.path == ""
                        ? AppColors.borderColor
                        : AppColors.whiteColor,
                    strokeWidth:state.promissoryNote.path == "" ? 2 : 0,
                    dashPattern:state.promissoryNote.path == "" ? [5,3] : [1, 0],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              context
                                  .read<FileUploadBloc>()
                                  .add(FileUploadEvent.uploadFromCameraEvent(
                                fileIndex: 1
                              ));
                            },
                            child:  state.promissoryNote.path == ""
                                ? Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.blueColor,
                              size: 30,
                            ) :SizedBox(
                              height: 130,
                              width: screenWidth,
                              child: Image.file(
                                File(state.promissoryNote.path),
                                fit: BoxFit.fill,
                              ),
                            )
                                 ),
                        state.promissoryNote.path == ""
                            ? Align(
                          child: Container(
                            width: screenWidth,
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.upload_photo,
                              style: AppStyles.rkRegularTextStyle(
                                  size: 14,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ):const SizedBox()

                      ],
                    ),
                  ),
                ),

                 const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.personal_guarantee,
                        style: AppStyles.rkRegularTextStyle(size: 16,color: AppColors.textColor ,fontWeight: FontWeight.w400)),
                    ButtonWidget(
                      buttonText: AppLocalizations.of(context)!.taken_down,
                      height: 30,
                      width: 85,
                      fontSize: 16,
                      radius: 5,
                      bGColor: AppColors.blueColor,
                      onPressed: (){},
                      fontColors: AppColors.whiteColor,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 134,
                  alignment: Alignment.center,
                  child: DottedBorder(
                    color: state.personalGuarantee.path == ""
                        ? AppColors.borderColor
                        : AppColors.whiteColor,
                    strokeWidth:state.personalGuarantee.path == "" ? 2 : 0,
                    dashPattern:state.personalGuarantee.path == "" ? [5,3] : [1, 0],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              context
                                  .read<FileUploadBloc>()
                                  .add(FileUploadEvent.uploadFromCameraEvent(
                                  fileIndex: 2
                              ));
                            },
                            child:  state.personalGuarantee.path == ""
                                ? Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.blueColor,
                              size: 30,
                            ) :SizedBox(
                              height: 130,
                              width: screenWidth,
                              child: Image.file(
                                File(state.personalGuarantee.path),
                                fit: BoxFit.fill,
                              ),
                            )
                        ),
                        state.personalGuarantee.path == ""
                            ? Align(
                          child: Container(
                            width: screenWidth,
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.upload_photo,
                              style: AppStyles.rkRegularTextStyle(
                                  size: 14,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ):const SizedBox()

                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
             Text(AppLocalizations.of(context)!.photo_tz,
                    style: AppStyles.rkRegularTextStyle(size: 16,color: AppColors.textColor ,fontWeight: FontWeight.w400)),
              const SizedBox(
                height: 10,
              ),
                Container(
                  height: 134,
                  alignment: Alignment.center,
                  child: DottedBorder(
                    color: state.photoOfTZ.path == ""
                        ? AppColors.borderColor
                        : AppColors.whiteColor,
                    strokeWidth:state.photoOfTZ.path == "" ? 2 : 0,
                    dashPattern:state.photoOfTZ.path == "" ? [5,3] : [1, 0],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              context
                                  .read<FileUploadBloc>()
                                  .add(FileUploadEvent.uploadFromCameraEvent(
                                  fileIndex: 3
                              ));
                            },
                            child:  state.photoOfTZ.path == ""
                                ? Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.blueColor,
                              size: 30,
                            ) :SizedBox(
                              height: 130,
                              width: screenWidth,
                              child: Image.file(
                                File(state.photoOfTZ.path),
                                fit: BoxFit.fill,
                              ),
                            )
                        ),
                        state.photoOfTZ.path == ""
                            ? Align(
                          child: Container(
                            width: screenWidth,
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.upload_photo,
                              style: AppStyles.rkRegularTextStyle(
                                  size: 14,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ):const SizedBox()

                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),
                Text(AppLocalizations.of(context)!.business_certificate,
                    style: AppStyles.rkRegularTextStyle(size: 16,color: AppColors.textColor ,fontWeight: FontWeight.w400)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 134,
                  alignment: Alignment.center,
                  child: DottedBorder(
                    color: state.businessCertificate.path == ""
                        ? AppColors.borderColor
                        : AppColors.whiteColor,
                    strokeWidth:state.businessCertificate.path == "" ? 2 : 0,
                    dashPattern:state.businessCertificate.path == "" ? [5,3] : [1, 0],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              context
                                  .read<FileUploadBloc>()
                                  .add(FileUploadEvent.uploadFromCameraEvent(
                                  fileIndex: 4
                              ));
                            },
                            child:  state.businessCertificate.path == ""
                                ? Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.blueColor,
                              size: 30,
                            ) :SizedBox(
                              height: 130,
                              width: screenWidth,
                              child: Image.file(
                                File(state.businessCertificate.path),
                                fit: BoxFit.fill,
                              ),
                            )
                        ),
                        state.businessCertificate.path == ""
                            ? Align(
                          child: Container(
                            width: screenWidth,
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.upload_photo,
                              style: AppStyles.rkRegularTextStyle(
                                  size: 14,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ):const SizedBox()

                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),
                ButtonWidget(
                  buttonText:AppLocalizations.of(context)!.continued,
                  fontColors: AppColors.whiteColor,
                  onPressed: (){
                    Navigator.pushNamed(context, RouteDefine.fileUploadScreen.name);
                  },
                  bGColor: AppColors.mainColor,
                ),
                const SizedBox(
                  height: 30,
                ),

                ButtonWidget(
                  buttonText:AppLocalizations.of(context)!.skip,
                  fontColors: AppColors.mainColor,
                  borderColor: AppColors.mainColor,
                  onPressed: (){
                    Navigator.pushNamed(context, RouteDefine.fileUploadScreen.name);
                  },
                  bGColor: AppColors.whiteColor,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  },
);
  }
}





 

      