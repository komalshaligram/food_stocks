import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../data/model/res_model/terms_condition_res/terms_condition_res_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_styles.dart';
import 'package:http_parser/http_parser.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:bloc/src/bloc.dart';


part 'privacy_policy_state.dart';
part 'privacy_policy_event.dart';
part 'privacy_policy_bloc.freezed.dart';


class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  File imagePath = File('');

   String directory = '';
  String owner1Signature = '';
  String owner2Signature = '';
  String guarantee1Signature = '';
  String guarantee2Signature = '';
  bool isSign = false;

  TermsConditionReqModel termsConditionReqModel = TermsConditionReqModel();
  PrivacyPolicyBloc() : super(PrivacyPolicyState.initial()) {

    on<PrivacyPolicyEvent>((event, emit)   async {
       if(event is _getPdfDataEvent){
        termsConditionReqModel = event.termsConditionReqModel;
         emit(state.copyWith(isOwner2Available: (termsConditionReqModel.owner2FullName != '') ? true : false,pdfPath: base64Decode(event.pdfData),
       isGuarantee1Available: termsConditionReqModel.guarantee1FullName!=''?true:false  ));
      }
      else if(event is _navigationEvent){
          debugPrint('owner1Signature___${owner1Signature}');
          debugPrint('ownerSignature___${owner2Signature}');
          debugPrint('guarantee1Signature___${guarantee1Signature}');
          debugPrint('guarantee2Signature___${guarantee2Signature}');
          debugPrint('id  ____${termsConditionReqModel.id}');
          try {
            emit(state.copyWith(isShimmering: true));
            final res =
            await DioClient(event.context).uploadFileProgressWithFormData(
              path: AppUrls.termsConditionUrl,
              formData: FormData.fromMap(
                {
                  AppStrings.userIdString : termsConditionReqModel.id,
                  AppStrings.agentIdString : termsConditionReqModel.agentId,
                  AppStrings.businessTypeIdString : termsConditionReqModel.businessTypeId,
                  AppStrings.owner1FullNameString : termsConditionReqModel.owner1FullName,
                  AppStrings.owner1IsraelIdString : termsConditionReqModel.owner1IsraelId,
                  AppStrings.owner2FullNameString :termsConditionReqModel.owner2FullName!= '' ?  termsConditionReqModel.owner2FullName : '',
                  AppStrings.owner2IsraelIdString : termsConditionReqModel.owner2IsraelId != ''? termsConditionReqModel.owner2IsraelId : '',
                  AppStrings.guarantee1FullNameString : termsConditionReqModel.guarantee1FullName,
                  AppStrings.guarantee1IsraelIdString : termsConditionReqModel.guarantee1IsraelId,
                  AppStrings.guarantee1AddressString : termsConditionReqModel.guarantee1Address,
                  AppStrings.guarantee1PhoneNumberString : termsConditionReqModel.guarantee1PhoneNumber,
                  AppStrings.guarantee2FullNameString : termsConditionReqModel.guarantee2FullName != '' ? termsConditionReqModel.guarantee2FullName : '',
                  AppStrings.guarantee2IsraelIdString : termsConditionReqModel.guarantee2IsraelId != '' ? termsConditionReqModel.guarantee2IsraelId : '',
                  AppStrings.guarantee2AddressString :termsConditionReqModel.guarantee2Address != '' ?  termsConditionReqModel.guarantee2Address : '',
                  AppStrings.guarantee2PhoneNumberString : termsConditionReqModel.guarantee2PhoneNumber != '' ? termsConditionReqModel.guarantee2PhoneNumber : '',
                  AppStrings.bankIdString : termsConditionReqModel.bankId,
                  AppStrings.branchNumberString : termsConditionReqModel.branchNumber,
                  AppStrings.accountNumberString : termsConditionReqModel.accountNumber,
                  AppStrings.owner1SignatureString : await MultipartFile.fromFile(
                      owner1Signature,
                      contentType: MediaType('image', 'png')),
                  AppStrings.owner2SignatureString:  owner2Signature != '' ? await MultipartFile.fromFile(
                       owner2Signature ,
                      contentType: MediaType('image', 'png')) : '',
                  AppStrings.guarantee1SignatureString: await MultipartFile.fromFile(
                      guarantee1Signature,
                      contentType: MediaType('image', 'png')),
                  AppStrings.guarantee2SignatureString: guarantee2Signature != '' ? await MultipartFile.fromFile(
                       guarantee2Signature ,
                      contentType: MediaType('image', 'png')) : '',
                },
              ),
            );
            debugPrint('fileUpload url = ${AppUrls.baseUrl}${AppUrls.termsConditionUrl}');
            debugPrint('termCondition response ____${res}');

            TermsConditionResModel response =
            TermsConditionResModel.fromJson(res);
            if(response.status == 200){
              emit(state.copyWith(isShimmering: false));
              Navigator.pushNamed(event.context, RouteDefine.fileUploadScreen.name);
            }
            else{
              emit(state.copyWith(isShimmering: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } on ServerException {
            emit(state.copyWith(isShimmering: false));
          }
          catch(e){
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: e.toString(),
                type: SnackBarType.FAILURE);
          }
      }

      else if(event is _signatureEvent) {
        showCustomSignaturePadDialog(event.context, event.fieldName,event.fieldNameForSign);
      }
    });
  }

  Future<void> showCustomSignaturePadDialog(
      BuildContext context , String fieldName , String signaturePadName) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            signaturePadName,
            textAlign: TextAlign.center,
            style: AppStyles.rkRegularTextStyle(
              size: AppConstants.smallFont,
              color: Colors.black,
            ),
          ),
          titlePadding: const EdgeInsets.all(8),
          contentPadding: const EdgeInsets.all(12),
          content: Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: SfSignaturePad(
              key: _signaturePadKey,
              onDrawStart: () {
                isSign = true;
                return false;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                isSign = false;
                _signaturePadKey.currentState!.clear();
              },
              child: Text('${AppLocalizations.of(context)!.remove}',
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: AppColors.redColor,
                ),),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                if(isSign){
                  saveSignature(context , fieldName);
                  isSign = false;
                }
              },
              child: Text('${AppLocalizations.of(context)!.save}',
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  void saveSignature(
      BuildContext context , String fieldName) async {
    ui.Image tempImage =
    await _signaturePadKey.currentState!.toImage();

    var data = await tempImage.toByteData(
        format: ui.ImageByteFormat.png);

    final imageInUnit8List = (data!.buffer.asUint8List());
     directory = (await getApplicationDocumentsDirectory()).path; // to get path of the file
    var path = '${directory}/${fieldName}.png';
    imagePath = await File(path).writeAsBytes(imageInUnit8List);

     if(fieldName == AppStrings.owner1SignatureString){
      owner1Signature = imagePath.path;
    }
    else if(fieldName == AppStrings.owner2SignatureString){
      owner2Signature = imagePath.path;
    }
   else if(fieldName == AppStrings.guarantee1SignatureString){
      guarantee1Signature = imagePath.path;
    }
   else if(fieldName == AppStrings.guarantee2SignatureString){
      guarantee2Signature = imagePath.path;
    }

    debugPrint('owner1Signature___${owner1Signature}');
    debugPrint('guarantee1Signature___${guarantee1Signature}');
    debugPrint('guarantee2Signature___${guarantee2Signature}');
    debugPrint('owner2Signature ____${owner2Signature}');

    if(state.isOwner2Available ){
      debugPrint('owner1Signature___${owner1Signature}');
      debugPrint('guarantee1Signature___${guarantee1Signature}');
      debugPrint('guarantee2Signature___${guarantee2Signature}');
      debugPrint('owner2Signature ____${owner2Signature}');
      if(owner1Signature != '' &&  owner2Signature != ''
          && guarantee1Signature != '' && guarantee2Signature !=''){
        emit(state.copyWith(isNextEnable: true));
      }
    }
    else if(owner1Signature != '' && guarantee1Signature != '' ){
      debugPrint('owner1Signature___${owner1Signature}');
      debugPrint('guarantee1Signature___${guarantee1Signature}');
      emit(state.copyWith(isNextEnable: true));
    }






  }

}