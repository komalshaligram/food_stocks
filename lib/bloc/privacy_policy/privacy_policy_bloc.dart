import 'dart:convert';
import 'dart:typed_data';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../data/model/res_model/terms_condition_res/terms_condition_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_styles.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http_parser/http_parser.dart';
import '../../ui/utils/themes/app_urls.dart';
part 'privacy_policy_state.dart';
part 'privacy_policy_event.dart';
part 'privacy_policy_bloc.freezed.dart';


class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  ui.Image? image;
  File imagePath = File('');
  Uint8List? documentByte;
   PdfFormField? formField;
  File file = File('');
  List<String>signPathList = [];

  TermsConditionReqModel termsConditionReqModel = TermsConditionReqModel();
  PrivacyPolicyBloc() : super(PrivacyPolicyState.initial()) {
    Uint8List? documentBytes;

    on<PrivacyPolicyEvent>((event, emit)   async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());


      if(event is _onFormFieldFocusChangeEvent){

           formField = event.details.formField;

          print('formField.name:${formField?.name}');
      /*    if(formField != null){
            final PdfSignatureFormField signatureFormField =
            formField as PdfSignatureFormField;
            final imageInUnit8List = (signatureFormField.signature);
            final directory =
                (await getApplicationDocumentsDirectory()).path;
            var path = '$directory/${formField?.name}.png';
            imagePath = await File(path).writeAsBytes(imageInUnit8List as List<int>);
            signPathList.add(imagePath.path);

          }*/

          if (event.details.hasFocus) {
            if(formField?.name=='Sign'){
         //    showCustomSignaturePadDialog(signatureFormField ,event.context);

            }
          }

      }

      else if(event is _getPdfDataEvent){
        termsConditionReqModel = event.termsConditionReqModel;
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }

        Directory dir;
        String filePath = '';
        if (defaultTargetPlatform == TargetPlatform.android) {
          dir = Directory('/storage/emulated/0/Documents');
        } else {
          dir = await getApplicationDocumentsDirectory();
        }
        filePath =
        '${dir.path}/${preferencesHelper.getUserName()}${'.'}${(DateTime.now()).hour}${'.'}${(DateTime.now()).minute}${'.pdf'}';
        file = File(filePath);

         documentBytes = base64.decode(event.pdfData);
        PdfDocument document = PdfDocument(inputBytes: documentBytes);

        document.form.fields.add(PdfSignatureField(document.pages[6],'sign',
            backColor: PdfColor(255,255,255),
            bounds: Rect.fromLTWH(135, 310, 100, 50)));

        document.form.fields.add(PdfSignatureField(document.pages[9], 'Sign1',
            backColor: PdfColor(255,255,255),
            bounds: Rect.fromLTWH(360, 390, 100, 40)));

       file.writeAsBytes(await document.save());

        print('file____${file}');
        emit(state.copyWith(filePath: filePath));


      }
      else if(event is _navigationEvent){

        if(formField != null){
          final PdfSignatureFormField signatureFormField =
          formField as PdfSignatureFormField;
          final imageInUnit8List = (signatureFormField.signature);
          final directory =
              (await getApplicationDocumentsDirectory()).path;
          var path = '$directory/${formField?.name}.png';
          imagePath = await File(path).writeAsBytes(imageInUnit8List as List<int>);
        //  signPathList.add(imagePath.path);
        }
        else{
          CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppLocalizations.of(event.context)!.signature_missing,
              type: SnackBarType.FAILURE);
        }

        if(imagePath.path.isNotEmpty){
          emit(state.copyWith(isShimmering: true));
          try {
            final res =
            await DioClient(event.context).uploadFileProgressWithFormData(
              path: AppUrls.termsConditionUrl,
              formData: FormData.fromMap(
                {
                  AppStrings.userIdString : preferencesHelper.getUserId(),
                  AppStrings.agentIdString : termsConditionReqModel.agentId,
                  AppStrings.businessTypeIdString : termsConditionReqModel.businessTypeId,
                  AppStrings.owner1FullNameString : termsConditionReqModel.owner1FullName,
                  AppStrings.owner1IsraelIdString : termsConditionReqModel.owner1IsraelId,
                  AppStrings.owner2FullNameString : termsConditionReqModel.owner2FullName,
                  AppStrings.owner2IsraelIdString : termsConditionReqModel.owner2IsraelId,
                  AppStrings.guarantee1FullNameString : termsConditionReqModel.guarantee1FullName,
                  AppStrings.guarantee1IsraelIdString : termsConditionReqModel.guarantee1IsraelId,
                  AppStrings.guarantee1AddressString : termsConditionReqModel.guarantee1Address,
                  AppStrings.guarantee1PhoneNumberString : termsConditionReqModel.guarantee1PhoneNumber,
                  AppStrings.guarantee2FullNameString : termsConditionReqModel.guarantee2FullName,
                  AppStrings.guarantee2IsraelIdString : termsConditionReqModel.guarantee2IsraelId,
                  AppStrings.guarantee2AddressString : termsConditionReqModel.guarantee2Address,
                  AppStrings.guarantee2PhoneNumberString : termsConditionReqModel.guarantee2PhoneNumber,
                  AppStrings.bankIdString : termsConditionReqModel.bankId,
                  AppStrings.branchNumberString : termsConditionReqModel.branchNumber,
                  AppStrings.accountNumberString : termsConditionReqModel.accountNumber,
                  AppStrings.signatureString: await MultipartFile.fromFile(
                      imagePath.path,
                      contentType: MediaType('image', 'png')),
                },
              ),
            );
            debugPrint('fileUpload url = ${AppUrls.baseUrl}${AppUrls.termsConditionUrl}');
            print('termCondition response ____${res}');

            TermsConditionResModel response =
            TermsConditionResModel.fromJson(res);
            if(response.status == 200){
              emit(state.copyWith(isShimmering: false));
              Navigator.pushNamed(event.context, RouteDefine.fileUploadScreen.name);
              file.deleteSync(recursive: true);
            }

          } on ServerException {emit(state.copyWith(isShimmering: false));}
        }
        else{
          CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppLocalizations.of(event.context)!.signature_missing,
              type: SnackBarType.FAILURE);
        }


    /*    if(signUrl.isNotEmpty){
          termsConditionReqModel = TermsConditionReqModel(
              id: preferencesHelper.getUserId(),
              agentId: termsConditionReqModel.agentId,
              businessTypeId: termsConditionReqModel.businessTypeId,
              owner1FullName: termsConditionReqModel.owner1FullName,
              owner1IsraelId: termsConditionReqModel.owner1IsraelId,
              owner2FullName: termsConditionReqModel.owner2FullName,
              owner2IsraelId: termsConditionReqModel.owner2IsraelId,
              guarantee1FullName: termsConditionReqModel.guarantee1FullName,
              guarantee1IsraelId: termsConditionReqModel.guarantee1IsraelId,
              guarantee1Address: termsConditionReqModel.guarantee1Address,
              guarantee1PhoneNumber: termsConditionReqModel.guarantee1PhoneNumber,
              guarantee2FullName: termsConditionReqModel.guarantee2FullName,
              guarantee2IsraelId: termsConditionReqModel.guarantee2IsraelId,
              guarantee2Address: termsConditionReqModel.guarantee2Address,
              guarantee2PhoneNumber: termsConditionReqModel.guarantee2PhoneNumber,
              bankId: termsConditionReqModel.bankId,
              accountNumber: termsConditionReqModel.accountNumber,
              branchNumber: termsConditionReqModel.branchNumber,
              signature: signUrl,
          );
          Map<String, dynamic> req = termsConditionReqModel.toJson();
          req.removeWhere((key, value) {
            if (value != null) {
              debugPrint("[$key] = $value");
            }
            return value == null;
          });
          print('termsConditionReqModel____${req}');
          try {
            emit(state.copyWith(isShimmering: true));
            final res = await DioClient(event.context).post(
              AppUrls.termsConditionUrl,
              data: req,
            );


            print('termCondition response ____${res}');

            TermsConditionResModel response =
            TermsConditionResModel.fromJson(res);


            if (response.status == 200) {
              if(res != null){
                emit(state.copyWith(isShimmering: false,));
                Navigator.pushNamed(event.context, RouteDefine.privacyPolicyScreen.name,
                    arguments: {
                      AppStrings.privacyPolicyPdfString : response.data ?? '',
                      AppStrings.termsConditionParamString :termsConditionReqModel
                    }
                );
              }
            } else {
              emit(state.copyWith(isShimmering: false));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.FAILURE,
              );
            }
          } on ServerException {
            emit(state.copyWith(isShimmering: false));
          }
          catch (e) {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: e.toString(),
              type: SnackBarType.FAILURE,
            );
          }


        }*/

      }


    });
  }



  Future<void> showCustomSignaturePadDialog(PdfSignatureFormField formField,
      BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${AppLocalizations.of(context)!.signature}',
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
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Clears the strokes in the signature pad.
                _signaturePadKey.currentState!.clear();
              },
              child: Text('${AppLocalizations.of(context)!.close}',
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: AppColors.redColor,
                ),),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                 _saveSignature(formField, context);
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


  void _saveSignature(PdfSignatureFormField formField,
      BuildContext context) async {

    ui.Image tempImage =
    await _signaturePadKey.currentState!.toImage();

    PdfDocument document = PdfDocument(inputBytes: documentByte);

    var data = await tempImage.toByteData(
        format: ui.ImageByteFormat.png);
    final imageInUnit8List = (data!.buffer.asUint8List());
    final directory =
        (await getApplicationDocumentsDirectory())
            .path; // to get path of the file
    var path = '$directory/fileName.png';
    imagePath = await File(path).writeAsBytes(imageInUnit8List);

    print('imagepath____${imagePath}');



  }




}