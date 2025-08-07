import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/model/req_model/delete_return_req/delete_return_req.dart';
import '/data/model/res_model/get_return_by_id_res_model/get_return_by_id_res_model.dart';
import '/ui/utils/constants/app_strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/req_model/create_return_req_model/create_return_req_model.dart' as req;
import '../../data/model/res_model/create_return_res_model/create_return_res_model.dart';
import '../../data/model/res_model/file_upload_model/file_upload_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_urls.dart';
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
          if (map['list'] != null) {
            List<ReturnProduct> tempProductList = [];
            final List<ReturnProduct> myList = map['list'] as List<ReturnProduct>;
            for (int i = 0; i < myList.length; i++) {
              tempProductList.add(ReturnProduct(
                returnId: myList[i].returnId,
                supplierName: myList[i].supplierName,
                totalRefund: myList[i].totalRefund,
                supplierId: myList[i].supplierId,
                proofImages: myList[i].proofImages,
                notes: myList[i].notes,
                productName: myList[i].productName,
                productImg: myList[i].productImg,
                barcode: myList[i].barcode,
                totalUnits: myList[i].totalUnits,
                isApproved: myList[i].isApproved,
                reasonToReturn: myList[i].reasonToReturn,
              ));
            }
            int index = map['index'] ?? 0;
            int radioIndex = tempList.indexWhere((e) => e.text.toLowerCase() == tempProductList[index].reasonToReturn?.toLowerCase()).toInt();
            emit(state.copyWith(selectedRadioTile: radioIndex + 1, returnId: tempProductList.elementAt(index).returnId ?? '', supplierName: tempProductList.elementAt(index).supplierName ?? '', supplierId: tempProductList.elementAt(index).supplierId ?? '', returnProductList: tempProductList, barCode: tempProductList.elementAt(index).barcode ?? '', totalQty: tempProductList.elementAt(index).totalUnits ?? 0, productName: tempProductList.elementAt(index).productName ?? '', productImg: (tempProductList.elementAt(index).productImg ?? ''), mainIndex: tempProductList[index].proofImages == null ? -1 : index, productQty: tempProductList[index].totalUnits ?? 1, proofImagesList: tempProductList.elementAt(index).proofImages ?? [], reason: tempProductList.elementAt(index).reasonToReturn ?? '', addNoteController: TextEditingController(text: tempProductList.elementAt(index).notes ?? '')));
            emit(state.copyWith(
              isFromPending: map['status'] ?? false,
              language: preferencesHelper.getAppLanguage(),
              radioList: tempList,
              proofFile: File(state.proofImagesList.isNotEmpty ? AppUrlEndPoints.baseFileUrl + state.proofImagesList[0] : ''),
              proofFile1: File(state.proofImagesList.length > 1 ? (AppUrlEndPoints.baseFileUrl + state.proofImagesList[1]) : ''),
              proofFile2: File(state.proofImagesList.length > 2 ? (AppUrlEndPoints.baseFileUrl + state.proofImagesList[2]) : ''),
            ));
          }
        }
      }
      else if (event is _navigateReturnEvent) {
        if (state.productQty != 0) {
          if (state.selectedRadioTile != 0) {

            if (state.proofFile.path.isNotEmpty || state.proofFile1.path.isNotEmpty || state.proofFile2.path.isNotEmpty) {


              ReturnProduct products = ReturnProduct(productName: state.productName, totalUnits: state.productQty, proofImages: state.proofImagesList,
                  notes: state.addNoteController.text.toString(), barcode: state.barCode, isApproved: false, totalRefund: 0, reasonToReturn: state.reason,
                  productImg: state.productImg, supplierName: state.supplierName, supplierId: state.supplierId, returnId: state.returnId,);
              if (state.mainIndex != -1) {

                //for update
                List<ReturnProduct> returnList = [];
                returnList.addAll(state.returnProductList);
                emit(state.copyWith(returnProductList: []));
                returnList.removeAt(state.mainIndex);
                returnList.insert(state.mainIndex, products);
                emit(state.copyWith(returnProductList: returnList));
                add(ProductReturnInfoEvent.updateReturnEvent(context: event.context));
                // Navigator.pop(event.context, returnList);
                // return;
              } else {
                //for create

                List<ReturnProduct> returnList = [];
                returnList.addAll(state.returnProductList);
                returnList.removeAt(0);
                returnList.add(products);
                emit(state.copyWith(returnProductList: returnList));
                if (state.returnProductList.length == 1) {

                  add(ProductReturnInfoEvent.createReturnEvent(context: event.context, supplierId: state.supplierId));
                } else {

                  add(ProductReturnInfoEvent.updateReturnEvent(context: event.context));
                }
                // Navigator.pushNamed(event.context, RouteDefine.createProductReturnListScreen.name, arguments: {'list': state.returnProductList, AppStrings.isUpdateParamString: false});
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
      } else if (event is _updateReturnEvent) {
        emit(state.copyWith(isShimmer: true));
        try {
          List<req.ReturnProduct> list = [];
          for (int i = 0; i < state.returnProductList.length; i++) {
            list.add(req.ReturnProduct(totalRefund: state.returnProductList[i].totalRefund, proofImages: state.returnProductList[i].proofImages,
                supplierId: state.returnProductList[i].supplierId, notes: state.returnProductList[i].notes, productName: state.returnProductList[i].productName,
                productImage: state.returnProductList[i].productImg, barcode: state.returnProductList[i].barcode, totalUnits: state.returnProductList[i].totalUnits,
                isApproved: state.returnProductList[i].isApproved, reasonToReturn: state.returnProductList[i].reasonToReturn,),);
          }
          req.CreateReturnReqModel reqModel = req.CreateReturnReqModel(
            applicationName: AppStrings.appName,
            supplierId: '',
            isDraft: !state.isFromPending,
            clientId: preferencesHelper.getUserId(),
            returnProducts: list,
            subUserId: preferencesHelper.getSubUserId().isNotEmpty ? preferencesHelper.getSubUserId() : null,
          );
          final res = await DioClient(event.context).post(
            '${AppUrlEndPoints.updateReturnUrl}${state.returnProductList.first.returnId}',
            data: reqModel.toJson(),
          );
          CreateReturnResModel resModel = CreateReturnResModel.fromJson(res);
          if (resModel.status == AppConstants.code_201) {
            List<ReturnProduct> list = [];
            if (resModel.data!.first.returnproducts != null) {
              List<Returnproduct> tempList = [];
              tempList.addAll(resModel.data!.first.returnproducts as Iterable<Returnproduct>);
              for (var i in tempList) {
                list.add(ReturnProduct(
                  returnId: i.returnId,
                  supplierName: i.supplierName,
                  totalUnits: i.totalUnits,
                  reasonToReturn: i.reasonToReturn,
                  barcode: i.barcode,
                  notes: i.notes,
                  proofImages: i.proofImages ?? [],
                  productName: i.productName,
                  productImg: i.productImage,
                  supplierId: i.supplierId,
                ));
              }
            }

            emit(state.copyWith(returnProductList: list, isShimmer: false, returnId: state.returnProductList.first.returnId ?? '', ));

            Navigator.pushReplacementNamed(event.context, RouteDefine.createProductReturnListScreen.name, arguments: {'list': list, //state.returnProductList,
              AppStrings.isUpdateParamString: false,'status':state.isFromPending,});


          } else {
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(res[AppStrings.messageString], event.context),
                type: SnackBarType.failure);
            emit(state.copyWith(isShimmer: false));
          }
        } catch (e) {}
      } else if (event is _deleteEvent) {
        List<ReturnProduct> list = [];
        list.addAll(state.returnProductList);
        list.removeAt(state.mainIndex);
        if (list.isNotEmpty) {
          Navigator.pop(event.context, list);
        } else {
          DeleteReturnReq req = DeleteReturnReq(ids: [state.returnProductList.first.returnId ?? '']);
          try {
            final res = await DioClient(event.context).post(
              AppUrlEndPoints.deleteReturnUrl,
              data: req.toJson(),
            );
            if (res[AppStrings.statusString] == AppConstants.code_200) {
              emit(state.copyWith(returnProductList: []));
              Navigator.of(event.context).popUntil((route) => route.isFirst);
              Navigator.pushNamedAndRemoveUntil(event.context, RouteDefine.returnListScreen.name, ModalRoute.withName(RouteDefine.returnListScreen.name));
            } else {
              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(res[AppStrings.messageString], event.context), type: SnackBarType.failure);
            }
          } catch (e) {
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          }
        }
      }
      else if (event is _pickDocumentEvent) {
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
      }
      else if (event is _deleteFileEvent) {
        if (event.index == 1) {
          emit(state.copyWith(proofFile: File('')));
        } else if (event.index == 2) {
          emit(state.copyWith(proofFile1: File('')));
        } else if (event.index == 3) {
          emit(state.copyWith(proofFile2: File('')));
        }
      }
      else if (event is _productIncrementEvent) {
        if (state.updateId.isEmpty) {
          emit(state.copyWith(
            productQty: event.productQuantity.round() + 1,
          ));
        } else {
          emit(state.copyWith(
            productQty: event.productQuantity.round() + 1,
          ));
        }
      }
      else if (event is _productDecrementEvent) {
        if (event.productQuantity >= 1) {
          emit(state.copyWith(
            productQty: event.productQuantity.round() - 1,
          ));
        }
      }
      else if (event is _radioButtonEvent) {
        emit(state.copyWith(selectedRadioTile: event.selectRadioTile, reason: event.reason));
      }
      else if (event is _createReturnEvent) {
        emit(state.copyWith(isShimmer: true));
        try {
          List<req.ReturnProduct> list = [];
          for (int i = 0; i < state.returnProductList.length; i++) {
            list.add(req.ReturnProduct(totalRefund: state.returnProductList[i].totalRefund, proofImages: state.returnProductList[i].proofImages, notes: state.returnProductList[i].notes, productName: state.returnProductList[i].productName, productImage: state.returnProductList[i].productImg, barcode: state.returnProductList[i].barcode, totalUnits: state.returnProductList[i].totalUnits, isApproved: state.returnProductList[i].isApproved, reasonToReturn: state.returnProductList[i].reasonToReturn, supplierId: event.supplierId));
          }
          req.CreateReturnReqModel reqModel = req.CreateReturnReqModel(applicationName: AppStrings.appName, clientId: preferencesHelper.getUserId(), returnProducts: list, subUserId: preferencesHelper.getSubUserId().isNotEmpty ? preferencesHelper.getSubUserId() : null, supplierId: '', isDraft: true);
          final res = await DioClient(event.context).post(
            AppUrlEndPoints.createReturnUrl,
            data: reqModel.toJson(),
          );
          CreateReturnResModel resModel = CreateReturnResModel.fromJson(res);
          if (resModel.status == AppConstants.code_201) {
            List<ReturnProduct> list = [];
            if (resModel.data!.first.returnproducts != null) {
              List<Returnproduct> tempList = [];
              tempList.add(resModel.data!.first.returnproducts!.first);
              for (var i in tempList) {
                list.add(ReturnProduct(
                  returnId: i.returnId,
                  supplierName: i.supplierName,
                  totalUnits: i.totalUnits,
                  reasonToReturn: i.reasonToReturn,
                  barcode: i.barcode,
                  notes: i.notes,
                  proofImages: i.proofImages ?? [],
                  productName: i.productName,
                  productImg: i.productImage,
                  supplierId: i.supplierId,
                ));
              }
            }
            emit(state.copyWith(returnProductList: list, isShimmer: false, returnId: resModel.data!.first.id.toString()));
            Navigator.pushReplacementNamed(event.context, RouteDefine.createProductReturnListScreen.name, arguments: {'list': state.returnProductList,
              AppStrings.isUpdateParamString: false,'status':state.isFromPending,});
          } else {
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(res[AppStrings.messageString], event.context),
                type: SnackBarType.failure);
            emit(state.copyWith(isShimmer: false));
          }
        } catch (e) {}
      }
    });
  }
}
