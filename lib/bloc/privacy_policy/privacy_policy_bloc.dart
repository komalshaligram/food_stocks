import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../data/model/res_model/terms_condition_res/terms_condition_res_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_styles.dart';
import 'package:http_parser/http_parser.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  TermsConditionReqModel termsConditionReqModel = const TermsConditionReqModel();
  PrivacyPolicyBloc() : super(PrivacyPolicyState.initial()) {
    on<PrivacyPolicyEvent>((event, emit) async {
      if (event is _getPdfDataEvent) {
        termsConditionReqModel = event.termsConditionReqModel;
        emit(state.copyWith(
            isOwner2Available: (termsConditionReqModel.owner2FullName != '') ? true : false,
            isGuarantee1Available: (termsConditionReqModel.guarantee1FullName != '') ? true : false));
        emit(state.copyWith(pdfPath: base64Decode(event.pdfData)));
      } else if (event is _navigationEvent) {
        try {
          Map<String, dynamic> reqMap = {};
          reqMap = {
            AppStrings.userIdString: termsConditionReqModel.id,
            AppStrings.businessTypeIdString: termsConditionReqModel.businessTypeId,
            AppStrings.owner1FullNameString: termsConditionReqModel.owner1FullName,
            AppStrings.owner1IsraelIdString: termsConditionReqModel.owner1IsraelId,
            AppStrings.owner2FullNameString: termsConditionReqModel.owner2FullName != '' ? termsConditionReqModel.owner2FullName : '',
            AppStrings.owner2IsraelIdString: termsConditionReqModel.owner2IsraelId != '' ? termsConditionReqModel.owner2IsraelId : '',
            AppStrings.guarantee1FullNameString: termsConditionReqModel.guarantee1FullName,
            AppStrings.guarantee1IsraelIdString: termsConditionReqModel.guarantee1IsraelId,
            AppStrings.guarantee1AddressString: termsConditionReqModel.guarantee1Address,
            AppStrings.guarantee1PhoneNumberString: termsConditionReqModel.guarantee1PhoneNumber,
            AppStrings.guarantee2FullNameString: termsConditionReqModel.guarantee2FullName != '' ? termsConditionReqModel.guarantee2FullName : '',
            AppStrings.guarantee2IsraelIdString: termsConditionReqModel.guarantee2IsraelId != '' ? termsConditionReqModel.guarantee2IsraelId : '',
            AppStrings.guarantee2AddressString: termsConditionReqModel.guarantee2Address != '' ? termsConditionReqModel.guarantee2Address : '',
            AppStrings.guarantee2PhoneNumberString:
                termsConditionReqModel.guarantee2PhoneNumber != '' ? termsConditionReqModel.guarantee2PhoneNumber : '',
            AppStrings.paymentType: termsConditionReqModel.paymentType,
            AppStrings.accountNumberString: termsConditionReqModel.accountNumber,
            AppStrings.owner1SignatureString: await MultipartFile.fromFile(owner1Signature, contentType: MediaType('image', 'png')),
            AppStrings.owner2SignatureString:
                owner2Signature != '' ? await MultipartFile.fromFile(owner2Signature, contentType: MediaType('image', 'png')) : '',
            AppStrings.guarantee1SignatureString:
                guarantee1Signature != '' ? await MultipartFile.fromFile(guarantee1Signature, contentType: MediaType('image', 'png')) : '',
            AppStrings.guarantee2SignatureString:
                guarantee2Signature != '' ? await MultipartFile.fromFile(guarantee2Signature, contentType: MediaType('image', 'png')) : ''
          };
          if (termsConditionReqModel.paymentType != AppStrings.creditCard) {
            reqMap
                .addAll({AppStrings.bankIdString: termsConditionReqModel.bankId, AppStrings.branchNumberString: termsConditionReqModel.branchNumber});
          }
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context)
              .uploadFileProgressWithFormData(path: AppUrlEndPoints.termsConditionUrl, formData: FormData.fromMap(reqMap));
          TermsConditionResModel response = TermsConditionResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(isShimmering: false));
            Navigator.pushNamed(event.context, RouteDefine.fileUploadScreen.name, arguments: {AppStrings.isRegisterFileString: true});
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (e) {
          emit(state.copyWith(isShimmering: false));
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      } else if (event is _signatureEvent) {
        showCustomSignaturePadDialog(event.context, event.fieldName, event.fieldNameForSign);
      } else if (event is _signaturePadSavedEvent) {
        if (event.fieldName == AppStrings.owner1SignatureString) {
          owner1Signature = event.localImagePath;
          emit(state.copyWith(owner1SignaturePath: event.localImagePath));
        } else if (event.fieldName == AppStrings.owner2SignatureString) {
          owner2Signature = event.localImagePath;
          emit(state.copyWith(owner2SignaturePath: event.localImagePath));
        } else if (event.fieldName == AppStrings.guarantee1SignatureString) {
          guarantee1Signature = event.localImagePath;
          emit(state.copyWith(guarantee1SignaturePath: event.localImagePath));
        } else if (event.fieldName == AppStrings.guarantee2SignatureString) {
          guarantee2Signature = event.localImagePath;
        }

        final bool allSigned = owner1Signature != '' &&
            (!state.isOwner2Available || owner2Signature != '') &&
            (!state.isGuarantee1Available || guarantee1Signature != '');
        emit(state.copyWith(isNextEnable: allSigned));
      }
    });
  }

  Future<void> showCustomSignaturePadDialog(BuildContext context, String fieldName, String signaturePadName) async {
    isSign = false;
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext sheetContext) {
          return Container(
            decoration: BoxDecoration(
                color: AppColors.whiteColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
            padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 20 + MediaQuery.of(sheetContext).padding.bottom),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 46, height: 5, decoration: BoxDecoration(color: AppColors.borderColor, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 18),
              Text(signaturePadName, style: AppStyles.rkBoldTextStyle(size: 18, color: AppColors.blackColor, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(AppLocalizations.of(sheetContext)!.tap_to_sign,
                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13, color: AppColors.greyColor)),
              const SizedBox(height: 16),
              Container(
                height: 220,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: AppColors.pageColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderColor)),
                child: SfSignaturePad(
                    key: _signaturePadKey,
                    backgroundColor: Colors.transparent,
                    strokeColor: AppColors.blackColor,
                    onDrawStart: () {
                      isSign = true;
                      return false;
                    }),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        isSign = false;
                        _signaturePadKey.currentState?.clear();
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.redColor.withValues(alpha: 0.5))),
                        child: Text(AppLocalizations.of(sheetContext)!.remove,
                            style: AppStyles.rkBoldTextStyle(size: 16, color: AppColors.redColor, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 50,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(12)),
                    child: MaterialButton(
                      onPressed: () async {
                        if (isSign) {
                          await saveSignature(sheetContext, fieldName);
                          isSign = false;
                        }
                        if (sheetContext.mounted) Navigator.pop(sheetContext);
                      },
                      child: Text(AppLocalizations.of(sheetContext)!.save,
                          style: AppStyles.rkBoldTextStyle(size: 16, color: AppColors.whiteColor, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ]),
            ]),
          );
        });
  }

  Future<void> saveSignature(BuildContext context, String fieldName) async {
    ui.Image tempImage = await _signaturePadKey.currentState!.toImage();
    var data = await tempImage.toByteData(format: ui.ImageByteFormat.png);
    final imageInUnit8List = data!.buffer.asUint8List();
    directory = (await getApplicationDocumentsDirectory()).path;
    var path = '$directory/$fieldName.png';
    imagePath = await File(path).writeAsBytes(imageInUnit8List);

    add(PrivacyPolicyEvent.signaturePadSavedEvent(fieldName: fieldName, localImagePath: imagePath.path));
  }
}
