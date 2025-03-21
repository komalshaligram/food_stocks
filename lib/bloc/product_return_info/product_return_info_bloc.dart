import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/create_return_req_model/create_return_req_model.dart' as req;
import 'package:food_stock/data/model/req_model/delete_return_req/delete_return_req.dart';
import 'package:food_stock/data/model/res_model/get_return_by_id_res_model/get_return_by_id_res_model.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      List<String> imgList = [];
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _getArgumentEvent) {
        map = event.arguments;
        List<RadioModel> tempList = [];
        RadioModel model = RadioModel(id: 1, text: AppLocalizations.of(event.context)!.product_defective);
        RadioModel model1 = RadioModel(id: 2, text: AppLocalizations.of(event.context)!.product_expiration_date_issue);
        RadioModel model2 = RadioModel(id: 3, text: AppLocalizations.of(event.context)!.wrong_product);
        tempList.add(model);
        tempList.add(model1);
        tempList.add(model2);
        if (map.isNotEmpty) {
          if (map['data'] != null) {
            emit(state.copyWith(barCode: map['data']['qrcode'], totalQty: map['data']['numberOfUnit'], productName: map['data']['productName'], productImg: map['data']['mainImage'] != null ? AppUrlEndPoints.baseFileUrl + map['data']['mainImage'] : '',language: preferencesHelper.getAppLanguage(),
              radioList: tempList,supplierId: map['data']['supplierId']??'',supplierName: map['data']['supplierName']));
          }
          if (map['list'] != null) {
            List<ReturnProduct> tempProductList = [];
            final List<ReturnProduct> myList = map['list'] as List<ReturnProduct>;
            printData('list :${myList}');
            for (int i = 0; i < myList.length; i++) {
              tempProductList.add(ReturnProduct(supplierName:myList[i].supplierName,totalRefund: myList[i].totalRefund, supplierId: myList[i].supplierId,proofImages: myList[i].proofImages, notes: myList[i].notes, productName: myList[i].productName, productImg: myList[i].productImg, barcode: myList[i].barcode, totalUnits: myList[i].totalUnits, isApproved: myList[i].isApproved, reasonToReturn: myList[i].reasonToReturn));
            }
            int index = map['index'] ?? 0;
            int radioIndex = tempList.indexWhere((e) => e.text.toLowerCase() == tempProductList[index].reasonToReturn?.toLowerCase()).toInt();
            if (map['data'] == null) {
              emit(state.copyWith(selectedRadioTile: radioIndex + 1,
                  supplierName: tempProductList.elementAt(index).supplierName??'',
                  supplierId: tempProductList.elementAt(index).supplierId??'', returnProductList: tempProductList, barCode: tempProductList.elementAt(index).barcode ?? '', totalQty: tempProductList.elementAt(index).totalUnits ?? 0, productName: tempProductList.elementAt(index).productName ?? '', productImg: (tempProductList.elementAt(index).productImg ?? ''), mainIndex: index, productQty: tempProductList[index].totalUnits ?? 0, proofImagesList: tempProductList.elementAt(index).proofImages ?? [], reason: tempProductList.elementAt(index).reasonToReturn ?? '', addNoteController: TextEditingController(text: tempProductList.elementAt(index).notes ?? '')));
              emit(state.copyWith(
                language: preferencesHelper.getAppLanguage(),
                radioList: tempList,
                proofFile: File(state.proofImagesList.isNotEmpty?AppUrlEndPoints.baseFileUrl + state.proofImagesList[0]:''),
                proofFile1: File(state.proofImagesList.length > 1 ? (AppUrlEndPoints.baseFileUrl + state.proofImagesList[1]) : ''),
                proofFile2: File(state.proofImagesList.length > 2 ? (AppUrlEndPoints.baseFileUrl + state.proofImagesList[2]) : ''),
              ));
            }else{
              emit(state.copyWith(returnProductList: tempProductList));
            }
          }
        }
      } else if (event is _navigateReturnEvent) {
        if (state.productQty != 0) {
          if (state.selectedRadioTile != 0) {
            if (state.proofFile.path.isNotEmpty) {
              ReturnProduct products = ReturnProduct(
                productName: state.productName,
                totalUnits: state.productQty,
                proofImages: state.proofImagesList,
                notes: state.addNoteController.text.toString(),
                barcode: state.barCode,
                isApproved: false,
                totalRefund: 0,
                reasonToReturn: state.reason,
                productImg: state.productImg,
                supplierName: state.supplierName,
                supplierId: state.supplierId
              );
              if (state.mainIndex != -1) {
                List<ReturnProduct> returnList = [];
                returnList.addAll(state.returnProductList);
                emit(state.copyWith(returnProductList: []));
                returnList.removeAt(state.mainIndex);
                returnList.insert(state.mainIndex, products);
                Navigator.pop(event.context, returnList);
                return;
              } else {
                List<ReturnProduct> returnList = [];
                returnList.addAll(state.returnProductList);
                returnList.add(products);
                emit(state.copyWith(returnProductList: returnList));
                Navigator.pushNamed(event.context, RouteDefine.createProductReturnListScreen.name, arguments: {'list': state.returnProductList, AppStrings.isUpdateParamString: false});
              }
            } else {
              CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.add_one_proof_img, type: SnackBarType.failure);
            }
          } else {
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.select_one_option, type: SnackBarType.failure);
          }
        } else {
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.enter_units, type: SnackBarType.failure);
        }
      } else if (event is _deleteEvent) {
        List<ReturnProduct> list = [];
        list.addAll(state.returnProductList);
        list.removeAt(state.mainIndex);
        if(list.isNotEmpty){
          Navigator.pop(event.context, list);
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.record_deleted_successfully, type: SnackBarType.success);
        }else{
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.record_deleted_successfully, type: SnackBarType.success);
          Navigator.pop(event.context, list);
          Navigator.pushNamedAndRemoveUntil(event.context, RouteDefine.returnListScreen.name, (Route route) => route.isFirst);
        }
      } else if (event is _pickDocumentEvent) {
        XFile? image = await openImagePicker(event.isFromCamera ? ImageSource.camera : ImageSource.gallery);
        if (image != null) {
          CroppedFile? croppedImage = await cropImage(path: image.path, shape: CropStyle.rectangle, quality: AppConstants.fileQuality);
          if (croppedImage?.path.isEmpty ?? true) {
            return;
          }
          String imageSize = getFileSizeString(bytes: croppedImage?.path.isNotEmpty ?? false ? await File(croppedImage!.path).length() : await image.length());

          if (int.parse(imageSize.split(' ').first) == 0) {
            return;
          }
          imgList.addAll(state.proofImagesList);
          final response = await DioClient(event.context).uploadFileProgressWithFormData(
            path: AppUrlEndPoints.fileUploadUrl,
            formData: FormData.fromMap(
              {AppStrings.returnImagesString: await MultipartFile.fromFile(croppedImage?.path ?? image.path, contentType: MediaType('image', 'png'))},
            ),
          );
          FileUploadModel signModel = FileUploadModel.fromJson(response);
          if (signModel.filepath != '') {
            imgUrl = '${signModel.filepath}' ?? '';
          }
          imgList.add(imgUrl);
          if (event.value == 1) {
            emit(state.copyWith(proofFile: File(croppedImage?.path ?? image.path)));
          } else if (event.value == 2) {
            emit(state.copyWith(proofFile1: File(croppedImage?.path ?? image.path)));
          } else if (event.value == 3) {
            emit(state.copyWith(proofFile2: File(croppedImage?.path ?? image.path)));
          }
          emit(state.copyWith(proofImagesList: imgList));
        }
      } else if (event is _deleteFileEvent) {
        if (event.index == 1) {
          emit(state.copyWith(proofFile: File('')));
        } else if (event.index == 2) {
          emit(state.copyWith(proofFile1: File('')));
        } else if (event.index == 3) {
          emit(state.copyWith(proofFile2: File('')));
        }
      } else if (event is _productIncrementEvent) {
        if (state.updateId.isEmpty) {
          emit(state.copyWith(
            productQty: event.productQuantity.round() + 1,
          ));
        } else {
          emit(state.copyWith(
            productQty: event.productQuantity.round() + 1,
          ));
        }
      } else if (event is _productDecrementEvent) {
        if (event.productQuantity >= 1) {
          emit(state.copyWith(
            productQty: event.productQuantity.round() - 1,
          ));
        }
      } else if (event is _radioButtonEvent) {
        emit(state.copyWith(selectedRadioTile: event.selectRadioTile, reason: event.reason));
      }
    });
  }
}