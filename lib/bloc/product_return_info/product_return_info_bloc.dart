import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/create_return_req_model/create_return_req_model.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/file_upload_model/file_upload_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'product_return_info_state.dart';
part 'product_return_info_event.dart';
part 'product_return_info_bloc.freezed.dart';

class ProductReturnInfoBloc extends Bloc<ProductReturnInfoEvent, ProductReturnInfoState> {
  ProductReturnInfoBloc() : super(ProductReturnInfoState.initial()) {
    on<ProductReturnInfoEvent>((event, emit) async {
      String imgUrl = '';
      Map map = {};
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _getArgumentEvent) {
        map = event.arguments;
        List<RadioModel> tempList = [];
        RadioModel model = RadioModel(id: 1,text: AppLocalizations.of(event.context)!.product_defective);
        RadioModel model1 = RadioModel(id: 2,text: AppLocalizations.of(event.context)!.product_expiration_date_issue);
        RadioModel model2 = RadioModel(id: 3,text: AppLocalizations.of(event.context)!.wrong_product);
        tempList.add(model);
        tempList.add(model1);
        tempList.add(model2);

        printData("arguments : ${event.arguments}");
        if(map.isNotEmpty){
          emit(state.copyWith(radioList: tempList,totalQty: map['numberOfUnit'],productName: map['productName'],productImg:map['mainImage']!=null?AppUrlEndPoints.baseFileUrl+map['mainImage']:''));
        }


        emit(state.copyWith(language: preferencesHelper.getAppLanguage(),));
      }else if(event is _navigateReturnEvent){
        ReturnProducts products = ReturnProducts(productName: state.productName,units: state.productQty,proofImages: [],notes: state.addNoteController.text.toString(),
        barcode: map['qrcode'],isApproved: false,totalRefund: 0,reason: '',productImg:state.productImg,);

        Navigator.pushNamed(event.context, RouteDefine.createProductReturnListScreen.name,arguments: products);
      }

      else if (event is _deleteEvent) {
      } else if (event is _pickDocumentEvent) {
        XFile? image = await openImagePicker(event.isFromCamera ? ImageSource.camera : ImageSource.gallery);
        if (image != null) {
          if (event.value == 1) {
            emit(state.copyWith(proofFile: File(image.path)));
          } else if (event.value == 2) {
            emit(state.copyWith(proofFile1: File(image.path)));
          } else if (event.value == 3) {
            emit(state.copyWith(proofFile2: File(image.path)));
          }
          // profileFile.value = File(image.path);
        }
      } else if (event is _deleteFileEvent) {
        if (event.index == 1) {
          emit(state.copyWith(proofFile: File('')));
        } else if (event.index == 2) {
          emit(state.copyWith(proofFile1: File('')));
        } else if (event.index == 3) {
          emit(state.copyWith(proofFile2: File('')));
        }
      }
      else if (event is _productIncrementEvent) {
        if (event.productQuantity < state.totalQty) {
          emit(state.copyWith(
            productQty: event.productQuantity.round() + 1,
          ));
        }
      else {
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.missing_quantity_not_more_than_original, type: SnackBarType.failure);
      }
      } else if (event is _productDecrementEvent) {
        if (event.productQuantity >= 1) {
          emit(state.copyWith(productQty: event.productQuantity.round() - 1,));
        }
      }else if (event is _radioButtonEvent) {
        emit(state.copyWith(selectedRadioTile: event.selectRadioTile,reason: event.reason));
      }else if(event is _uploadProofImagesEvent){
        try {

          if(state.proofFile!=null){
            CroppedFile? croppedImage = await cropImage(path: state.proofFile.path, shape: CropStyle.circle, quality: AppConstants.fileQuality);
            if (croppedImage?.path.isEmpty ?? true) {
              return;
            }
            String imageSize = getFileSizeString(bytes: croppedImage?.path.isNotEmpty ?? false ? await File(croppedImage!.path).length() : await state.proofFile.length());

            if (int.parse(imageSize.split(' ').first) == 0) {
              return;
            }
            final response =
            await DioClient(event.context).uploadFileProgressWithFormData(
              path: AppUrlEndPoints.fileUploadUrl,
              formData: FormData.fromMap(
                {
                  AppStrings.returnImagesString: await MultipartFile.fromFile(
                      croppedImage?.path ?? state.proofFile.path,
                      contentType: MediaType('image', 'png'))
                },
              ),
            );
            FileUploadModel signModel = FileUploadModel.fromJson(response);
            if (signModel.filepath != '') {
              imgUrl = signModel.filepath ?? '';
            }
            List<String> imgList = [];
            imgList.add(imgUrl);
            emit(state.copyWith(proofImagesList:imgList));
          }

        } on ServerException {}
      }
    });
  }
}
