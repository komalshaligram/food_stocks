import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
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
    FileUploadBloc bloc = context.read<FileUploadBloc>();
    return BlocBuilder<FileUploadBloc, FileUploadState>(
  builder: (context, state) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
   appBar: AppBar(
     backgroundColor: AppColors.whiteColor,
     elevation: 0,
     titleSpacing: 0,
     leadingWidth: 60,
     title: Text(AppLocalizations.of(context)!.forms_files,style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont,fontWeight: FontWeight.w400,color: AppColors.blackColor)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height:10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.promissory_note ,
                      style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont,color: AppColors.textColor ,fontWeight: FontWeight.w400)),

                    ButtonWidget(
                      buttonText: AppLocalizations.of(context)!.taken_down,
                       height: 30,
                       width: 70,
                      fontSize: AppConstants.smallFont,
                      radius: AppConstants.radius_5,
                      bGColor: AppColors.blueColor,
                      onPressed: (){
                        bloc.add(FileUploadEvent.deleteFileEvent(fileIndex: 1,documentPath: state.promissoryNote.path));
                      },
                      fontColors: AppColors.whiteColor,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ContainerWidget(fileIndex: 1),
                 const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.personal_guarantee,
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont,color: AppColors.textColor ,fontWeight: FontWeight.w400)),
                    ButtonWidget(
                      buttonText: AppLocalizations.of(context)!.taken_down,
                      height: 30,
                      width: 70,
                      fontSize: AppConstants.smallFont,
                      radius: AppConstants.radius_5,
                      bGColor: AppColors.blueColor,
                      onPressed: (){
                        bloc.add(FileUploadEvent.deleteFileEvent(fileIndex: 2,documentPath: state.personalGuarantee.path));
                      },
                      fontColors: AppColors.whiteColor,
                    ),

                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ContainerWidget(fileIndex: 2),
                const SizedBox(
                  height: 30,
                ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(AppLocalizations.of(context)!.photo_tz,
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont,color: AppColors.textColor ,fontWeight: FontWeight.w400)),
                 ButtonWidget(
                   buttonText: AppLocalizations.of(context)!.taken_down,
                   height: 30,
                   width: 70,
                   fontSize: AppConstants.smallFont,
                   radius: AppConstants.radius_5,
                   bGColor: AppColors.blueColor,
                   onPressed: (){
                     bloc.add(FileUploadEvent.deleteFileEvent(fileIndex: 3,documentPath: state.photoOfTZ.path));
                   },
                   fontColors: AppColors.whiteColor,
                 ),
               ],
             ),
              const SizedBox(
                height: 10,
              ),
                ContainerWidget(fileIndex: 3),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.business_certificate,
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont,color: AppColors.textColor ,fontWeight: FontWeight.w400)),
                    ButtonWidget(
                      buttonText: AppLocalizations.of(context)!.taken_down,
                      height: 30,
                      width: 70,
                      fontSize: AppConstants.smallFont,
                      radius: AppConstants.radius_5,
                      bGColor: AppColors.blueColor,
                      onPressed: (){
                        bloc.add(FileUploadEvent.deleteFileEvent(fileIndex: 4,documentPath: state.businessCertificate.path));
                      },
                      fontColors: AppColors.whiteColor,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ContainerWidget(fileIndex: 4),
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



class ContainerWidget extends StatelessWidget {
 final int fileIndex;
   ContainerWidget({super.key , required this.fileIndex});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<FileUploadBloc, FileUploadState>(
  builder: (context, state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
                  height: screenHeight * 0.2,
                  alignment: Alignment.center,
                  child: DottedBorder(
                    color: state.promissoryNote.path == ""  && fileIndex == 1?
                         AppColors.borderColor : state.personalGuarantee.path == ""  && fileIndex == 2?  AppColors.borderColor :
                    state.photoOfTZ.path == "" && fileIndex == 3 ?  AppColors.borderColor :
                    state.businessCertificate.path == "" && fileIndex == 4?  AppColors.borderColor :
                         AppColors.whiteColor ,

                 strokeWidth: state.promissoryNote.path == "" && fileIndex == 1?
                 2 : state.personalGuarantee.path == "" && fileIndex == 2?  2 :
                 state.photoOfTZ.path == "" && fileIndex == 3 ?  2 :
                 state.businessCertificate.path == "" && fileIndex == 4 ?  2 :
                 0,

                    dashPattern: state.promissoryNote.path == "" && fileIndex == 1?
                    [5,3]  : state.personalGuarantee.path == "" && fileIndex == 2?  [5,3]  :
                    state.photoOfTZ.path == "" && fileIndex == 3?  [5,3]  :
                    state.businessCertificate.path == "" && fileIndex == 4?  [5,3]  :
                    [1,0] ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              alertDialog(context,fileIndex);
                            },
                            child: state.promissoryNote.path != "" && fileIndex == 1
                                ? SizedBox(
                              height: 130,
                              width: screenWidth,
                              child: Image.file(
                                File(state.promissoryNote.path),
                                fit: BoxFit.fill,
                              )
                            ) :   state.personalGuarantee.path != "" && fileIndex == 2?
                            SizedBox(
                                height: 130,
                                width: screenWidth,
                                child: Image.file(
                                  File(state.personalGuarantee.path),
                                  fit: BoxFit.fill,
                                )
                            ):  state.photoOfTZ.path != "" && fileIndex == 3 ?
                            SizedBox(
                                height: 130,
                                width: screenWidth,
                                child: Image.file(
                                  File(state.photoOfTZ.path),
                                  fit: BoxFit.fill,
                                )
                            ) :  state.businessCertificate.path != "" && fileIndex == 4 ? SizedBox(
                                height: 130,
                                width: screenWidth,
                                child: Image.file(
                                  File(state.businessCertificate.path),
                                  fit: BoxFit.fill,
                                )
                            )
                                : Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.blueColor,
                              size: 30,
                            )
                                 ),

                        state.promissoryNote.path == "" &&  fileIndex == 1
                            ? Container(
                              width: screenWidth,
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!.upload_photo,
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.font_14,
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w400),
                              ),
                            ) : state.personalGuarantee.path == "" &&  fileIndex == 2 ? Container(
                          width: screenWidth,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)!.upload_photo,
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w400),
                          ),
                        ) :  state.photoOfTZ.path == "" &&  fileIndex == 3 ?
                        Container(
                          width: screenWidth,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)!.upload_photo,
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w400),
                          ),
                        ) :state.businessCertificate.path == "" &&  fileIndex == 4 ?
                        Container(
                          width: screenWidth,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)!.upload_photo,
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                            :const SizedBox()

                      ],
                    ),
                  ) ,
                );
  },
);
  }
  void alertDialog(BuildContext context , int fileIndex){
    showDialog(
      context: context,
      builder:(c1) {
        return BlocBuilder<FileUploadBloc, FileUploadState>(
          builder: (c1, state) {
            return AlertDialog(
              title: Align(
                  alignment: Alignment.center,
                  child: Text(AppLocalizations.of(context)!.upload_photo)),

              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: (){
                          context
                              .read<FileUploadBloc>()
                              .add(FileUploadEvent.uploadDocumentEvent(fileIndex: fileIndex ,imageSourceIndex: 1 ));
                          Navigator.pop(c1);
                        },
                        child: Icon(Icons.camera_alt_rounded)),
                    GestureDetector(
                        onTap: (){
                          context
                              .read<FileUploadBloc>()
                              .add(FileUploadEvent.uploadDocumentEvent(fileIndex: fileIndex,imageSourceIndex: 2));
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
      }, );

  }
}





/* Container(
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
                            //  alertDialog(context,4);
                           *//*   context
                                  .read<FileUploadBloc>()
                                  .add(FileUploadEvent.uploadFromCameraEvent(
                                  fileIndex: 4
                              ));*//*
                            },
                            child: state.businessCertificate.path == ""
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
                ),*/


 

      