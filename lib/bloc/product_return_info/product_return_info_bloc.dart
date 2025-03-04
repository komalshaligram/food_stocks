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
        emit(state.copyWith(language: preferencesHelper.getAppLanguage(), radioList: tempList,));
        if (map[AppStrings.idString] != null) {
          try {
            emit(state.copyWith(isShimmer: true));
            final response = await DioClient(event.context).get(
              path: AppUrlEndPoints.getReturnByIdUrl + map[AppStrings.idString],
            );
            GetReturnByIdResModel res = GetReturnByIdResModel.fromJson(response);
            if (res.status == AppConstants.code_200) {
              int index = tempList.indexWhere((e) => e.text.toLowerCase() == res.data?.returnProducts?.first.reasonToReturn?.toLowerCase()).toInt();
              emit(state.copyWith(
                  language: preferencesHelper.getAppLanguage(),
                  radioList: tempList,
                  selectedRadioTile: index + 1,
                  reason: res.data?.returnProducts?.first.reasonToReturn ?? '',
                  productName: res.data?.returnProducts?.first.productName ?? '',
                  productImg: '${res.data?.returnProducts!.first.productImg}' ?? '',
                  productQty: res.data?.returnProducts?.first.totalUnits ?? 0,
                  proofImagesList: res.data?.returnProducts?.first.proofImages ?? [],
                  barCode: res.data?.returnProducts?.first.barcode ?? '',
                  updateId: map[AppStrings.idString],
                  isShimmer: false,
                  statusId: res.data?.returnStatusId ?? '',
                  addNoteController: TextEditingController(
                    text: res.data?.returnProducts?.first.notes,
                  )));
              if (state.proofImagesList.isNotEmpty) {
                printData("length:${state.proofImagesList.length}");
                emit(state.copyWith(
                  proofFile: File(AppUrlEndPoints.baseFileUrl + state.proofImagesList[0]),
                  proofFile1: File(state.proofImagesList.length > 1 ? (AppUrlEndPoints.baseFileUrl + state.proofImagesList[1]) : ''),
                  proofFile2: File(state.proofImagesList.length > 2 ? (AppUrlEndPoints.baseFileUrl + state.proofImagesList[2]) : ''),
                ));
              }
            }
          } catch (e) {
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          }
        } else {
          if (map.isNotEmpty) {
            if(map['list']!=null){
              List<ReturnProduct> tempProductList = [];
              final List<ReturnProduct> myList = map['list'] as List<ReturnProduct>;
              printData('list :${myList}');
              for (int i = 0; i < myList.length; i++) {
                tempProductList.add(ReturnProduct(totalRefund: myList[i].totalRefund, proofImages: myList[i].proofImages, notes: myList[i].notes, productName: myList[i].productName, productImg: myList[i].productImg, barcode: myList[i].barcode, totalUnits: myList[i].totalUnits, isApproved: myList[i].isApproved, reasonToReturn: myList[i].reasonToReturn));
              }
              int index = map['index']??0;
              int radioIndex = tempList.indexWhere((e) => e.text.toLowerCase() == tempProductList[index].reasonToReturn?.toLowerCase()).toInt();

              emit(state.copyWith(selectedRadioTile: radioIndex+1,returnProductList:tempProductList,barCode: tempProductList.elementAt(index).barcode??'',totalQty:tempProductList.elementAt(index).totalUnits??0,
              productName: tempProductList.elementAt(index).productName??'',productImg: (tempProductList.elementAt(index).productImg??''),mainIndex:index,
                  proofImagesList: tempProductList.elementAt(index).proofImages??[],reason: tempProductList.elementAt(index).reasonToReturn??'',addNoteController: TextEditingController(text: tempProductList.elementAt(index).notes??'')));
              emit(state.copyWith(
                proofFile: File(AppUrlEndPoints.baseFileUrl + state.proofImagesList[0]),
                proofFile1: File(state.proofImagesList.length > 1 ? (AppUrlEndPoints.baseFileUrl + state.proofImagesList[1]) : ''),
                proofFile2: File(state.proofImagesList.length > 2 ? (AppUrlEndPoints.baseFileUrl + state.proofImagesList[2]) : ''),
              ));
            }
            if(map['data']!=null){
              emit(state.copyWith( barCode: map['data']['qrcode'], totalQty: map['data']['numberOfUnit'], productName: map['data']['productName'], productImg: map['data']['mainImage'] != null ? AppUrlEndPoints.baseFileUrl + map['data']['mainImage'] : ''));
            }
          }
        }
      } else if (event is _navigateReturnEvent) {
        if (state.productQty != 0) {
          if (state.selectedRadioTile != 0) {
            if (state.proofFile.path.isNotEmpty) {
              if (state.updateId.isNotEmpty) {
                /*try {
                  CreateReturnReqModel reqModel = CreateReturnReqModel(applicationName: AppStrings.appName, clientId: preferencesHelper.getUserId(), returnStatusId: state.statusId, returnProducts: [ReturnProducts(productImage: state.productImg, productName: state.productName, reasonToReturn: state.reason, isApproved: false, barcode: state.barCode, notes: state.addNoteController.text, proofImages: state.proofImagesList, totalUnits: state.productQty, totalRefund: 0)], subUserId: preferencesHelper.getSubUserId().isNotEmpty ? preferencesHelper.getSubUserId() : null);
                  final res = await DioClient(event.context).post(
                    AppUrlEndPoints.updateReturnUrl + state.updateId,
                    data: reqModel.toJson(),
                  );
                  CreateReturnResModel resModel = CreateReturnResModel.fromJson(res);
                  if (resModel.status == AppConstants.code_201) {
                    emit(state.copyWith(isLoading: false));
                    Navigator.pushNamedAndRemoveUntil(event.context, RouteDefine.returnListScreen.name, (Route route) => route.isFirst);
                  } else {
                    CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(resModel.message?.toLocalization() ?? resModel.message!, event.context), type: SnackBarType.failure);
                  }
                } catch (e) {
                  CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
                }*/
                // return;
              }

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
              );
            //  productList.add(products);
              if(state.mainIndex!=-1){
                List<ReturnProduct> returnList = state.returnProductList;
                //state.returnProductList
                state.returnProductList[state.mainIndex]=products;
                Navigator.pop(event.context,state.returnProductList);
                return;
              }else{
                state.returnProductList.add(products);
              }
              if (state.updateId.isNotEmpty) {
               // Navigator.pop(event.context, productList);
              } else {
                Navigator.pushNamed(event.context, RouteDefine.createProductReturnListScreen.name, arguments: {'list':state.returnProductList,AppStrings.isUpdateParamString:false});
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
        state.returnProductList.removeAt(state.mainIndex);
        Navigator.pop(event.context,state.returnProductList);
/*
        DeleteReturnReq req = DeleteReturnReq(ids: [state.updateId]);
        try {
          final res = await DioClient(event.context).post(
            AppUrlEndPoints.deleteReturnUrl,
            data: req.toJson(),
          );
          if (res[AppStrings.statusString] == AppConstants.code_200) {
            Navigator.pop(event.context);
          } else {
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(res[AppStrings.messageString], event.context), type: SnackBarType.failure);
          }
          printData('req:${req.toJson()}');
        } catch (e) {
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }*/
      } else if (event is _pickDocumentEvent) {
        XFile? image = await openImagePicker(event.isFromCamera ? ImageSource.camera : ImageSource.gallery);
        if (image != null) {
          CroppedFile? croppedImage = await cropImage(path: image.path, shape: CropStyle.circle, quality: AppConstants.fileQuality);
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
          /*if (event.productQuantity < state.totalQty) {
            emit(state.copyWith(
              productQty: event.productQuantity.round() + 1,
            ));
          } else {
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.missing_quantity_not_more_than_original, type: SnackBarType.failure);
          }*/
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
