import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/profile_details_req_model/profile_details_req_model.dart';
import '../../data/model/req_model/profile_req_model/profile_model.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../data/model/res_model/bank_detail_model/bank_detail_model.dart';
import '../../data/model/res_model/business_name_model/business_name_model.dart';
import '../../data/model/res_model/file_upload_res_model/file_upload_res_model.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart';import '../../data/model/res_model/profile_details_update_res_model/profile_details_update_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' as p;

part 'client_form_details_event.dart';
part 'client_form_details_state.dart';
part 'client_form_details_bloc.freezed.dart';

class ClientFormDetailsBloc extends Bloc<ClientFormDetailsEvent, ClientFormDetailsState> {
  ProfileModel profileModel = const ProfileModel();
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  File imagePath = File('');
  String businessType = '';
  String businessTypeId = '';
  String bankId = '';
  String agentId = '';
  String directory = '';
  // String owner1Signature = '';
  // String owner2Signature = '';
  // String guarantee1Signature = '';
  // String guarantee2Signature = '';
  bool isSign = false;

  TermsConditionReqModel termsConditionReqModel = const TermsConditionReqModel();
  ClientFormDetailsBloc() : super(ClientFormDetailsState.initial()) {
    on<ClientFormDetailsEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      List<BusinessType> businessTypeList = [];

      if (event is _getProfileDetailsEvent) {
        try {
          final res = await DioClient(event.context).post(
            AppUrlEndPoints.getProfileDetailsUrl,
            data: ProfileDetailsReqModel(id: preferencesHelper.getUserId()).toJson(),
          );
          ProfileDetailsResModel response = ProfileDetailsResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {

            businessType = res['data']['clients'][0]['clientDetail']['businessType']['businessTypeName'];
            agentId = response.data?.clients?[0].clientDetail?.agent?.id ?? '';
            businessTypeId = res['data']['clients'][0]['clientDetail']['businessType']['_id'];
            bankId = response.data?.clients?[0].clientDetail?.bank?.id ?? '';
            // owner1Signature = response.data?.clients?[0].clientDetail?.owner1Signature ?? '';
            // owner2Signature = response.data?.clients?[0].clientDetail?.owner2Signature ?? '';
            // guarantee1Signature = response.data?.clients?[0].clientDetail?.guarantee1Signature ?? '';
            // guarantee2Signature = response.data?.clients?[0].clientDetail?.guarantee2Signature ?? '';

            emit(state.copyWith(
                agentCodeController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.agent?.agentCode ?? '',
                ),
                business: res['data']['clients'][0]['clientDetail']['businessType']['businessTypeName'],
                bankName: response.data?.clients?[0].clientDetail?.bank?.bankName ?? '',
                branchController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.branchNumber ?? '',
                ),
                accountNumberController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.accountNumber ?? '',
                ),
                owner1NameController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.owner1FullName ?? '',
                ),
                owner1israelIdController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.owner1IsraelId ?? '',
                ),
                guarantee1NameController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.guarantee1FullName ?? '',
                ),
                guarantee1idController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.guarantee1IsraelId ?? '',
                ),
                guarantee1addressController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.guarantee1Address ?? '',
                ),
                guarantee1PhoneController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.guarantee1PhoneNumber ?? '',
                ),
                owner2NameController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.owner2FullName ?? '',
                ),
                owner2israelIdController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.owner2IsraelId ?? '',
                ),
                guarantee2NameController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.guarantee2FullName ?? '',
                ),
                guarantee2idController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.guarantee2IsraelId ?? '',
                ),
                guarantee2addressController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.guarantee2Address ?? '',
                ),
                guarantee2PhoneController: TextEditingController(
                  text: response.data?.clients?[0].clientDetail?.guarantee2PhoneNumber ?? '',
                ),
                owner1Signature: response.data?.clients?[0].clientDetail?.owner1Signature ?? '',
                owner2Signature: response.data?.clients?[0].clientDetail?.owner2Signature ?? '',
                guarantee1Signature: response.data?.clients?[0].clientDetail?.guarantee1Signature ?? '',
                guarantee2Signature: response.data?.clients?[0].clientDetail?.guarantee2Signature ?? ''
                // bankName:
                ));
          } else {
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
          }
        } catch (e) {
        }
      } else if (event is _selectBusinessTypeEvent) {
        for (var element in state.businessTypeList) {
          if (element.businessTypeName == event.business) {
            debugPrint('element.haveMultiple${element.haveMultiple}');

            businessTypeId = element.id.toString();
            emit(state.copyWith(business: event.business, haveMultiple: element.haveMultiple ?? false, ownerList: state.ownerList, owner: state.ownerList.first));
          }
        }
      } else if (event is _selectOwnerNoEvent) {
        emit(state.copyWith(owner: state.haveMultiple ? event.owner : '1'));
      } else if (event is _getBusinessTypeEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).get(path: AppUrlEndPoints.getBusinessTypeUrl);
          BusinessNameModel response = BusinessNameModel.fromJson(res);

          businessTypeList.add(BusinessType(businessTypeName: AppLocalizations.of(event.context)!.type_of_business));
          businessTypeList.addAll(response.data?.businessType?.reversed ?? []);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(isShimmering: false, businessTypeList: businessTypeList, business: businessTypeList.first.businessTypeName.toString(), haveMultiple: response.data?.businessType?.reversed.first.haveMultiple ?? false));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _selectBankEvent) {
        emit(state.copyWith(bankName: event.bankName, bankId: event.bankId));
        bankId = event.bankId.toString();
      } else if (event is _getBankNameEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).get(path: AppUrlEndPoints.getBankDetailUrl);
          BankDetailModel response = BankDetailModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(
              isShimmering: false,
              bankList: response.data?.bankDetail ?? [],
              bankName: response.data?.bankDetail?.first.bankName ?? '',
            ));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _getPdfDataEvent) {
        termsConditionReqModel = event.termsConditionReqModel;
        emit(state.copyWith(isOwner2Available: (termsConditionReqModel.owner2FullName != '') ? true : false, isGuarantee1Available: (termsConditionReqModel.guarantee1FullName != '') ? true : false));
        emit(state.copyWith(pdfPath: base64Decode(event.pdfData)));
      } else if (event is _signatureEvent) {
        showCustomSignaturePadDialog(event.context, event.fieldName, event.fieldNameForSign);
      } else if (event is _updateClientDataEvent) {
        try {
          emit(state.copyWith(isLoading: true));
          Map<String, dynamic> reqMap = {};
          reqMap = {
            'clientDetail': {
              AppStrings.agentIdString: state.agentCodeController.text != '' ? state.agentCodeController.text : '',
              AppStrings.businessTypeIdString: businessTypeId ?? '',
              AppStrings.bankIdString: bankId ?? '',
              AppStrings.branchNumberString: state.branchController.text != '' ? state.branchController.text : '',
              AppStrings.accountNumberString: state.accountNumberController.text != '' ? state.accountNumberController.text : '',
              AppStrings.owner1FullNameString: state.owner1NameController.text != '' ? state.owner1NameController.text : '',
              AppStrings.owner1IsraelIdString: state.owner1israelIdController.text != '' ? state.owner1israelIdController.text : '',
              AppStrings.owner2FullNameString: state.owner2NameController.text != '' ? state.owner2NameController.text : '',
              AppStrings.owner2IsraelIdString: state.owner2israelIdController.text != '' ? state.owner2israelIdController.text : '',
              AppStrings.guarantee1FullNameString: state.guarantee1NameController.text != '' ? state.guarantee1NameController.text : '',
              AppStrings.guarantee1IsraelIdString: state.guarantee1idController.text != '' ? state.guarantee1idController.text : '',
              AppStrings.guarantee1AddressString: state.guarantee1addressController.text != '' ? state.guarantee1addressController.text : '',
              AppStrings.guarantee1PhoneNumberString: state.guarantee1PhoneController.text != '' ? state.guarantee1PhoneController.text : '',
              AppStrings.guarantee2FullNameString: state.guarantee2NameController.text != '' ? state.guarantee2NameController.text : '',
              AppStrings.guarantee2IsraelIdString: state.guarantee2idController.text != '' ? state.guarantee2idController.text : '',
              AppStrings.guarantee2AddressString: state.guarantee2addressController.text != '' ? state.guarantee2addressController.text : '',
              AppStrings.guarantee2PhoneNumberString: state.guarantee2PhoneController.text != '' ? state.guarantee2PhoneController.text : '',
              AppStrings.owner1SignatureString: state.owner1Signature != '' ? state.owner1Signature : '',
              AppStrings.owner2SignatureString: state.owner2Signature != '' ? state.owner2Signature : '',
              AppStrings.guarantee1SignatureString: state.guarantee1Signature != '' ? state.guarantee1Signature : '',
              AppStrings.guarantee2SignatureString: state.guarantee2Signature != '' ? state.guarantee2Signature : '',
            }
          };


          final res = await DioClient(event.context).post(
            "${AppUrlEndPoints.updateClientInfoDetailsUrl}/${preferencesHelper.getUserId()}",
            data: reqMap,
          );

          ProfileDetailsUpdateResModel response = ProfileDetailsUpdateResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppLocalizations.of(event.context)!.updated_successfully,
              type: SnackBarType.success,
            );

            emit(state.copyWith(isLoading: false));
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
        }
      } else if (event is _deleteFileEvent) {
        if(event.fieldName == AppStrings.owner1SignatureString) {
          emit(state.copyWith(
            owner1Signature: '',
            owner1SignatureLocal: '',
          ));
        }
        else if(event.fieldName == AppStrings.owner2SignatureString) {
          emit(state.copyWith(
            owner2Signature: '',
            owner2SignatureLocal: '',
          ));
        }
        else if(event.fieldName == AppStrings.guarantee1SignatureString) {
          emit(state.copyWith(
            guarantee1Signature: '',
            guarantee1SignatureLocal: '',
          ));
        }
        else if(event.fieldName == AppStrings.guarantee2SignatureString) {
          emit(state.copyWith(
            guarantee2Signature: '',
            guarantee2SignatureLocal: '',
          ));
        }
      }
    });
  }

  Future<void> showCustomSignaturePadDialog(BuildContext context, String fieldName, String signaturePadName) async {
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
              child: Text(
                AppLocalizations.of(context)!.remove,
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: AppColors.redColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                if (isSign) {
                  saveSignature(context, fieldName);
                  isSign = false;
                }
              },
              child: Text(
                AppLocalizations.of(context)!.save,
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

  void saveSignature(BuildContext context, String fieldName) async {
    ui.Image tempImage = await _signaturePadKey.currentState!.toImage();

    var data = await tempImage.toByteData(format: ui.ImageByteFormat.png);

    final imageInUnit8List = (data!.buffer.asUint8List());
    directory = (await getApplicationDocumentsDirectory()).path; // to get path of the file
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var path = '$directory/${fieldName}_$timestamp.png';
    imagePath = await File(path).writeAsBytes(imageInUnit8List);

    FormData formData;
    String? contentType = 'png';
    String type = 'image';
    String? extension = 'png';

    if (fieldName == AppStrings.owner1SignatureString) {
      emit(state.copyWith(owner1SignatureLocal: imagePath.path));

      final fileNameWithoutExtension = p.basenameWithoutExtension(state.owner1SignatureLocal);

      formData = FormData.fromMap({AppStrings.fileString: await MultipartFile.fromFile(state.owner1SignatureLocal, filename: "${fileNameWithoutExtension}_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}_${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}", contentType: MediaType(type, contentType))});

      final res = await DioClient(context).uploadFileProgressWithFormData(
        path: AppUrlEndPoints.fileUploadUrl,
        formData: formData,
      );
      FileUploadResModel response = FileUploadResModel.fromJson(res);

      emit(state.copyWith(owner1Signature: response.filepath.toString()));
    } else if (fieldName == AppStrings.owner2SignatureString) {
      emit(state.copyWith(owner2SignatureLocal: imagePath.path));

      final fileNameWithoutExtension = p.basenameWithoutExtension(state.owner2SignatureLocal);

      formData = FormData.fromMap({AppStrings.fileString: await MultipartFile.fromFile(state.owner2SignatureLocal, filename: "${fileNameWithoutExtension}_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}_${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}", contentType: MediaType(type, contentType))});

      final res = await DioClient(context).uploadFileProgressWithFormData(
        path: AppUrlEndPoints.fileUploadUrl,
        formData: formData,
      );
      FileUploadResModel response = FileUploadResModel.fromJson(res);

      emit(state.copyWith(owner2Signature: response.filepath.toString()));
    } else if (fieldName == AppStrings.guarantee1SignatureString) {
      emit(state.copyWith(guarantee1SignatureLocal: imagePath.path));

      final fileNameWithoutExtension = p.basenameWithoutExtension(state.guarantee1SignatureLocal);

      formData = FormData.fromMap({AppStrings.fileString: await MultipartFile.fromFile(state.guarantee1SignatureLocal, filename: "${fileNameWithoutExtension}_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}_${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}", contentType: MediaType(type, contentType))});

      final res = await DioClient(context).uploadFileProgressWithFormData(
        path: AppUrlEndPoints.fileUploadUrl,
        formData: formData,
      );
      FileUploadResModel response = FileUploadResModel.fromJson(res);

      emit(state.copyWith(guarantee1Signature: response.filepath.toString()));
    } else if (fieldName == AppStrings.guarantee2SignatureString) {
      emit(state.copyWith(guarantee2SignatureLocal: imagePath.path));

      final fileNameWithoutExtension = p.basenameWithoutExtension(state.guarantee2SignatureLocal);

      formData = FormData.fromMap({AppStrings.fileString: await MultipartFile.fromFile(state.guarantee2SignatureLocal, filename: "${fileNameWithoutExtension}_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}_${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}", contentType: MediaType(type, contentType))});

      final res = await DioClient(context).uploadFileProgressWithFormData(
        path: AppUrlEndPoints.fileUploadUrl,
        formData: formData,
      );
      FileUploadResModel response = FileUploadResModel.fromJson(res);

      emit(state.copyWith(guarantee2Signature: response.filepath.toString()));
    }

    // if (state.isOwner2Available) {
    //   if (state.owner1Signature != '' && owner2Signature != '' && guarantee1Signature != '' && guarantee2Signature != '') {
    //     emit(state.copyWith(isNextEnable: true));
    //   }
    // } else if (state.owner1Signature != '') {
    //   if (state.isGuarantee1Available && guarantee1Signature == '') {
    //     emit(state.copyWith(isNextEnable: false));
    //   } else {
    //     emit(state.copyWith(isNextEnable: true));
    //   }
    // }
  }
}
