import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/res_model/status_info_res_model/status_info_res_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/req_model/delete_return_req/delete_return_req.dart';
import '../../data/model/req_model/remove_issue/remove_issue_req_model.dart';
import '../../data/model/res_model/create_return_res_model/create_return_res_model.dart';
import '../../data/model/res_model/file_upload_model/file_upload_model.dart';
import '../../data/model/res_model/get_return_by_id_res_model/get_return_by_id_res_model.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/constants/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';

import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/req_model/create_issue/create_issue_req_model.dart' as create;
import '../../data/model/req_model/create_return_req_model/create_return_req_model.dart' as req;

import '../../data/model/res_model/account_permission/account_permission_res_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';

import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../product_return_info/product_return_info_bloc.dart';

part 'product_details_event.dart';

part 'product_details_state.dart';

part 'product_details_bloc.freezed.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(ProductDetailsState.initial()) {
    on<ProductDetailsEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      String imgUrl = '';
      List<String> imgList = [];

      if (event is _getOrderByIdEvent) {
        emit(
          state.copyWith(
            isShimmering: true,
            isLoading: true,
            language: preferencesHelper.getAppLanguage(),
            isSubUserCreateDuplicateOrder: preferencesHelper.getCanDuplicateOrder(),
            isIncludedVat: preferencesHelper.getIsIncludedVat(),
          ),
        );
        try {
          final res = await DioClient(event.context).get(
            path: '${AppUrlEndPoints.getOrderById}${preferencesHelper.getOrderId()}',
          );

          GetOrderByIdModel response = GetOrderByIdModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            emit(
              state.copyWith(
                orderBySupplierProduct: response.data?.ordersBySupplier?.first ?? const OrdersBySupplier(),
                orderData: response.data?.orderData?.first ?? const OrderDatum(),
                isShimmering: false,
                isLoading: false,
                isRefresh: !state.isRefresh,
                driverDeliveryProofImagesList: response.data?.orderData!.first.driverDeliveryDocumentsImages ?? [],
                userId: preferencesHelper.getUserId(),
              ),
            );

            emit(state.copyWith(
              driverDeliveryProofFile: File(state.driverDeliveryProofImagesList.isNotEmpty ? AppUrlEndPoints.baseFileUrl + state.driverDeliveryProofImagesList[0] : ''),
              driverDeliveryProofFile1: File(state.driverDeliveryProofImagesList.length > 1 ? (AppUrlEndPoints.baseFileUrl + state.driverDeliveryProofImagesList[1]) : ''),
              driverDeliveryProofFile2: File(state.driverDeliveryProofImagesList.length > 2 ? (AppUrlEndPoints.baseFileUrl + state.driverDeliveryProofImagesList[2]) : ''),
            ));

            add(ProductDetailsEvent.getReturnListEvent(context: event.context));
          } else {
            emit(state.copyWith(isShimmering: false, isLoading: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false, isLoading: false));
        } catch (e) {
          emit(state.copyWith(isShimmering: false, isLoading: false));
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      }

      if (event is _getProductDataEvent) {
        emit(
          state.copyWith(
            orderBySupplierProduct: event.orderBySupplierProduct,
            orderData: event.orderData,
            language: preferencesHelper.getAppLanguage(),
            isSubUserCreateDuplicateOrder: preferencesHelper.getCanDuplicateOrder(),
            statusList: event.statusList,
          ),
        );
      } else if (event is _productProblemEvent) {
        var selectedIndices = List<int>.from(state.productListIndex);

        if (selectedIndices.contains(event.index)) {
          selectedIndices.remove(event.index);
        } else {
          selectedIndices.add(event.index);
        }

        final totalSelectableProducts = state.orderBySupplierProduct.products?.where((p) => !(p.isBottle ?? false) || (p.sku == "5321"))?.length ?? 0;

        final isAllSelected = selectedIndices.length == totalSelectableProducts && totalSelectableProducts > 0;

        emit(state.copyWith(
          productListIndex: selectedIndices,
          isAllCheck: isAllSelected,
        ));
      } else if (event is _checkAllEvent) {
        final allProducts = state.orderBySupplierProduct.products ?? [];

        final selectableProducts = allProducts.asMap().entries.where((entry) => !(entry.value.isBottle ?? false) || entry.value.sku == "5321").toList();

        final totalSelectable = selectableProducts.length;

        List<int> newSelectedIndices;

        if (!state.isAllCheck) {
          newSelectedIndices = List.generate(allProducts.length, (i) => i).where((index) => !(allProducts[index].isBottle ?? false) || allProducts[index].sku == "5321").toList();
        } else {
          newSelectedIndices = [];
        }

        final isNowAllSelected = newSelectedIndices.length == totalSelectable && totalSelectable > 0;

        emit(state.copyWith(
          productListIndex: newSelectedIndices,
          isAllCheck: isNowAllSelected,
        ));
      }
      // else if (event is _productProblemEvent) {
      //   List<int> index = [];
      //   bool isAllCheck = false;
      //   index = [...state.productListIndex];
      //   if (state.productListIndex.contains(event.index)) {
      //     index.remove(event.index);
      //   } else {
      //     index.add(event.index);
      //   }
      //   int length = state.orderBySupplierProduct.products?.length ?? 0;
      //
      //   if (length == index.length) {
      //     isAllCheck = true;
      //   }
      //
      //   emit(state.copyWith(productListIndex: index, isAllCheck: isAllCheck));
      // }

      // else if (event is _checkAllEvent) {
      //   final fullProductList = state.orderBySupplierProduct.products ?? [];
      //
      //   final returnProducts = state.returnList?.data?.returnProducts ?? [];
      //   final barcodesWithReason = returnProducts.map((e) => e.barcode!.trim()).toSet();
      //
      //   List<int> updatedIndices = [];
      //
      //   if (!state.isAllCheck) {
      //     updatedIndices = List<int>.generate(fullProductList.length, (i) => i);
      //   } else {
      //     updatedIndices = fullProductList.asMap().entries.where((entry) => barcodesWithReason.contains(entry.value.barcode!.trim())).map((entry) => entry.key).toList();
      //   }
      //
      //   final isAllCheck = fullProductList.isNotEmpty && fullProductList.length == updatedIndices.length;
      //
      //   emit(state.copyWith(
      //     productListIndex: updatedIndices,
      //     isAllCheck: isAllCheck,
      //   ));
      // }
      else if (event is _radioButtonEvent) {
        emit(state.copyWith(selectedRadioTile: event.selectRadioTile, isRefresh: !state.isRefresh, proofFile: File(''), proofFile1: File(''), proofFile2: File('')));
      } else if (event is _productIncrementEvent) {
        final currentQty = event.productIssueData[event.radioValue]!['quantity'] ?? event.messingQuantity;
        if (currentQty < event.productQuantity) {
          event.productIssueData[event.radioValue]!['quantity'] = currentQty + 1;

          emit(state.copyWith(isRefresh: !state.isRefresh, productIssueData: event.productIssueData));
        } else {
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: AppLocalizations.of(event.context)!.missing_quantity_not_more_than_original,
            type: SnackBarType.failure,
          );
        }
      } else if (event is _productDecrementEvent) {
        final currentQty = event.productIssueData[event.radioValue]!['quantity'] ?? event.messingQuantity;
        if (currentQty > 1) {
          event.productIssueData[event.radioValue]!['quantity'] = currentQty - 1;

          emit(state.copyWith(isRefresh: !state.isRefresh));
        }
      } else if (event is _createIssueEvent) {
        emit(state.copyWith(isLoading: true));
        if (event.issue != '') {
          create.CreateIssueReqModel reqMap = create.CreateIssueReqModel(
            supplierId: event.supplierId,
            products: [
              create.Product(
                productId: event.productId,
                issue: event.issue,
                missingQuantity: event.missingQuantity,
              )
            ],
          );

          try {
            final response = await DioClient(event.context).post(
              '${AppUrlEndPoints.createIssueUrl}${event.orderId}',
              data: reqMap,
            );

            if (response[AppStrings.statusString] == AppConstants.code_201) {
              emit(state.copyWith(isLoading: false));

              Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: event.issue});

              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context), type: SnackBarType.success);
            } else {
              Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: ''});
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context), type: SnackBarType.failure);
            }
          } on ServerException {
            Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: ''});
          } catch (e) {
            Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: ''});
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          }
        } else {
          emit(state.copyWith(isLoading: false));
          Navigator.pop(event.context);
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.select_issue, type: SnackBarType.failure);
        }
      } else if (event is _getBottomSheetDataEvent) {
        if (event.notes != null && event.notes!.isNotEmpty) {
          state.addNoteController.text = event.notes!;
        }
      } else if (event is _removeIssueEvent) {
        emit(state.copyWith(isRemoveProcess: true));

        RemoveIssueReqModel reqMap = RemoveIssueReqModel(supplierId: event.supplierId, orderId: event.orderId, products: event.product);

        try {
          final response = await DioClient(event.context).post(
            AppUrlEndPoints.removeIssueUrl,
            data: reqMap,
          );

          if (response[AppStrings.statusString] == AppConstants.code_200) {
            add(ProductDetailsEvent.getOrderByIdEvent(context: event.context, orderId: preferencesHelper.getOrderId()));
            emit(state.copyWith(isRemoveProcess: false));
            Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: 'issue'});

            // Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context), type: SnackBarType.success);
          } else {
            emit(state.copyWith(isRemoveProcess: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isRemoveProcess: false));
        } catch (e) {
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      } else if (event is _duplicateOrderEvent) {
        emit(state.copyWith(isDuplicateOrderProcess: true));
        try {
          final response = await DioClient(event.context).post(
            AppUrlEndPoints.duplicateOrderUrl,
            data: {AppStrings.orderIdString: event.orderId, AppStrings.cartIdString: preferencesHelper.getCartId()},
          );

          if (response[AppStrings.statusString] == AppConstants.code_200) {
            Navigator.pop(event.dialogContext);

            Navigator.pushNamed(event.context, RouteDefine.bottomNavScreen.name, arguments: {AppStrings.isBasketScreenString: 'true'});
            emit(state.copyWith(isDuplicateOrderProcess: false));
          } else {
            Navigator.pop(event.dialogContext);
            emit(state.copyWith(isDuplicateOrderProcess: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isDuplicateOrderProcess: false));
        } catch (e) {
          emit(state.copyWith(isDuplicateOrderProcess: false));
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      } else if (event is _getAllCartEvent) {
        emit(state.copyWith(isDuplicateOrderProcess: true));
        try {
          final res = await DioClient(event.context).post(
            '${AppUrlEndPoints.getAllCartUrl}${preferencesHelper.getCartId()}',
          );

          GetAllCartResModel response = GetAllCartResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(
              isDuplicateOrderProcess: false,
            ));
            List<ProductStockModel> stockList = [];
            stockList.addAll(response.data?.data?.map((product) => ProductStockModel(quantity: product.totalQuantity ?? 0, productId: product.id ?? '', stock: product.productStock.toString(), lowStock: product.lowStock.toString())) ?? []);

            await preferencesHelper.setCartCount(count: stockList.length);
            emit(state.copyWith(isCartCount: true));
          } else {
            emit(state.copyWith(isDuplicateOrderProcess: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isDuplicateOrderProcess: false));
        } catch (e) {
          emit(state.copyWith(isDuplicateOrderProcess: false));
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      } else if (event is _getPermissionList) {
        if (preferencesHelper.getSubUser()) {
          try {
            final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getAccountPermissionUrl}${preferencesHelper.getSubUserId()}');
            AccountPermissionResModel response = AccountPermissionResModel.fromJson(res);

            if (response.status == AppConstants.code_200) {
              var res = response.data?.permissions;
              preferencesHelper.setCanSeeWallet(isSeeWallet: res?.canSeeWallet ?? false);
              preferencesHelper.setCanAddBasket(isAddBasket: res?.canAddToCart ?? false);
              preferencesHelper.setCanCreateOrder(isCreateOrder: res?.canCreateOrder ?? false);
              preferencesHelper.setCanSeeOrder(isSeeOrder: res?.canSeeOrders ?? false);
              preferencesHelper.setCanDuplicateOrder(isDuplicateOrder: res?.canDuplicateOrders ?? false);
              preferencesHelper.setCanUpdateBusinessInfo(isUpdateBusinessInfo: res?.canSeeAndUpdateBusinessInfo ?? false);
              preferencesHelper.setCanUpdateAdditionalInfo(isUpdateAdditionalInfo: res?.canSeeAndUpdateAdditionalInfo ?? false);
              preferencesHelper.setCanUpdateTimeInfo(isUpdateTimeInfo: res?.canSeeAndUpdateTimesInfo ?? false);
              preferencesHelper.setCanSeeFormsFiles(isSeeFormsFiles: res?.canSeeFileAndForms ?? false);
              preferencesHelper.setManageSubUser(isManageSubUser: res?.canManageSubUsers ?? false);
            } else {
              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
            }
          } catch (e) {
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          }
        }
      } else if (event is _getPickDocumentEvent) {
        final images = event.proofImages ?? [];
        emit(state.copyWith(proofFile: images.length > 0 ? File(AppUrlEndPoints.baseFileUrl + images[0]) : File(''), proofFile1: images.length > 1 ? File(AppUrlEndPoints.baseFileUrl + images[1]) : File(''), proofFile2: images.length > 2 ? File(AppUrlEndPoints.baseFileUrl + images[2]) : File(''), proofImagesList: event.proofImages!));
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
            List<String> proofImageList = List<String>.from(event.productIssueData[event.selectedRadio]!['proofImage']);
            ensureListLength<String>(proofImageList, 1, '');
            proofImageList[0] = imgUrl;
            event.productIssueData[event.selectedRadio]!['proofImage'] = proofImageList;

            emit(state.copyWith(
              proofFile: File(croppedImage?.path ?? image.path),
              productIssueData: event.productIssueData,
            ));
          } else if (event.value == 2) {
            List<String> proofImageList = List<String>.from(event.productIssueData[event.selectedRadio]!['proofImage']);
            ensureListLength<String>(proofImageList, 2, '');
            proofImageList[1] = imgUrl;
            event.productIssueData[event.selectedRadio]!['proofImage'] = proofImageList;

            emit(state.copyWith(
              proofFile1: File(croppedImage?.path ?? image.path),
              productIssueData: event.productIssueData,
            ));
          } else if (event.value == 3) {
            List<String> proofImageList = List<String>.from(event.productIssueData[event.selectedRadio]!['proofImage']);
            ensureListLength<String>(proofImageList, 3, '');
            proofImageList[2] = imgUrl;
            event.productIssueData[event.selectedRadio]!['proofImage'] = proofImageList;

            emit(state.copyWith(
              proofFile2: File(croppedImage?.path ?? image.path),
              productIssueData: event.productIssueData,
            ));
          }

          emit(state.copyWith(proofImagesList: imgList));
        }
      } else if (event is _deleteFileEvent) {
        // Get current proof image list from event map and remove the image path
        List<String> proofImageList = List<String>.from(
          event.productIssueData[event.selectedRadio]!['proofImage'],
        );

        int listIndex = event.index - 1; // Convert from 1-based to 0-based index

        if (listIndex >= 0 && listIndex < proofImageList.length) {
          proofImageList.removeAt(listIndex);
        } else {}

        // Update productIssueData with modified proof image list
        event.productIssueData[event.selectedRadio]!['proofImage'] = proofImageList;

        // Get current proofImagesList and remove corresponding File
        final updatedProofImagesList = List<String>.from(state.proofImagesList);

        if (listIndex >= 0 && listIndex < updatedProofImagesList.length) {
          updatedProofImagesList.removeAt(listIndex);
        } else {}

        // Emit new state and clear the corresponding File
        if (event.index == 1) {
          emit(state.copyWith(
            proofFile: File(''),
            productIssueData: event.productIssueData,
            proofImagesList: updatedProofImagesList,
          ));
        } else if (event.index == 2) {
          emit(state.copyWith(
            proofFile1: File(''),
            productIssueData: event.productIssueData,
            proofImagesList: updatedProofImagesList,
          ));
        } else if (event.index == 3) {
          emit(state.copyWith(
            proofFile2: File(''),
            productIssueData: event.productIssueData,
            proofImagesList: updatedProofImagesList,
          ));
        }
      } else if (event is _getReturnListEvent) {
        try {
          final response = await DioClient(event.context).get(
            path: AppUrlEndPoints.getReturnByIdUrl + preferencesHelper.getOrderId(),
          );
          GetReturnByIdResModel res = GetReturnByIdResModel.fromJson(response);

          final fullProductList = state.orderBySupplierProduct.products ?? [];
          final returnProducts = res.data?.returnProducts ?? [];

          // Safely get excludeBarcodes or empty list if null
          final excludeBarcodes = event.excludeBarcodes ?? [];

          // Convert barcodes to indices
          final returnProductIndices = returnProducts
              .map((returnProd) {
                return fullProductList.indexWhere((p) => p.barcode!.trim() == returnProd.barcode!.trim());
              })
              .where((index) => index != -1)
              .toList();

          // Get existing valid indices
          List<int> filteredSelectedIndices = state.productListIndex.where((idx) {
            return idx >= 0 && idx < fullProductList.length;
          }).toList();

          // Exclude indices (uncheck those)
          final excludeIndices = excludeBarcodes
              .map((barcode) {
                return fullProductList.indexWhere((p) => p.barcode!.trim() == barcode.trim());
              })
              .where((index) => index != -1)
              .toSet();

          // Remove excluded indices from selected list
          filteredSelectedIndices = filteredSelectedIndices.where((idx) => !excludeIndices.contains(idx)).toList();

          // Merge previous + return list without duplicates
          final mergedIndices = {...filteredSelectedIndices, ...returnProductIndices}.toList();

          // ✅ Check if all are selected
          final isAllCheck = fullProductList.isNotEmpty && fullProductList.length == mergedIndices.length;

          emit(state.copyWith(
            returnList: res,
            productListIndex: mergedIndices,
            isAllCheck: isAllCheck,
            language: preferencesHelper.getAppLanguage(),
          ));
        } catch (e) {
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: e.toString(),
            type: SnackBarType.failure,
          );
        }
      } else if (event is _createReturnEvent) {
        emit(state.copyWith(isLoading: true));
        try {
          List<req.ReturnProduct> list = [];

          list.add(
            req.ReturnProduct(
              totalRefund: event.totalRefund,
              proofImages: event.proofImages,
              notes: event.notes,
              productName: event.productName,
              productImage: event.productImage!,
              barcode: event.barcode,
              totalUnits: event.totalUnits,
              isApproved: event.isApproved,
              reasonToReturn: event.reasonToReturn,
              supplierId: event.supplierId,
            ),
          );

          req.CreateReturnReqModel reqModel = req.CreateReturnReqModel(
            applicationName: AppStrings.appName,
            clientId: preferencesHelper.getUserId(),
            returnProducts: list,
            subUserId: preferencesHelper.getSubUserId().isNotEmpty ? preferencesHelper.getSubUserId() : null,
            supplierId: event.supplierId,
            isDraft: false,
            orderId: event.orderId,
          );
          final res = await DioClient(event.context).post(
            AppUrlEndPoints.createReturnUrl,
            data: reqModel.toJson(),
          );
          CreateReturnResModel resModel = CreateReturnResModel.fromJson(res);
          if (resModel.status == AppConstants.code_201) {
            emit(state.copyWith(
              isLoading: false,
            ));

            Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: event.reasonToReturn, 'refresh': true});

            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                res[AppStrings.messageString].toString().toLocalization(),
                event.context,
              ),
              type: SnackBarType.success,
            );
          } else {
            Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: '', 'refresh': false});
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                res[AppStrings.messageString].toString().toLocalization(),
                event.context,
              ),
              type: SnackBarType.failure,
            );
          }
        } catch (e) {}
      } else if (event is _updateReturnEvent) {
        emit(state.copyWith(isLoading: true));

        try {
          // Prepare updated product model
          req.ReturnProduct updatedProduct = req.ReturnProduct(
            returnProductId: event.returnProductId,
            totalRefund: event.totalRefund,
            proofImages: event.proofImages,
            notes: event.notes,
            productName: event.productName,
            productImage: event.productImage!,
            barcode: event.barcode,
            totalUnits: event.totalUnits,
            isApproved: event.isApproved,
            reasonToReturn: event.reasonToReturn,
            supplierId: event.supplierId,
          );

          List<req.ReturnProduct> list = [];

          // Handling the update/deletion logic
          if (event.returnProductId != null) {
            bool found = false;

            list = event.returnProduct
                .map((product) {
                  if (product.returnProductId == event.returnProductId) {
                    found = true;

                    if (event.isRemoved) {
                      // Mark the product as removed (do not add it to the list)
                      return null; // This effectively removes the product
                    } else {
                      // Update the product
                      return updatedProduct;
                    }
                  }
                  return req.ReturnProduct(
                    returnProductId: product.returnProductId,
                    totalRefund: product.totalRefund,
                    proofImages: product.proofImages,
                    notes: product.notes,
                    productName: product.productName,
                    productImage: product.productImg,
                    barcode: product.barcode,
                    totalUnits: product.totalUnits,
                    isApproved: product.isApproved,
                    reasonToReturn: product.reasonToReturn,
                    supplierId: product.supplierId,
                  );
                })
                .toList()
                .whereType<req.ReturnProduct>()
                .toList();

            // If product is not found, add it as updated
            if (!found && !event.isRemoved) {
              list.add(updatedProduct);
            }
          } else {
            // Add updated product to the list (handle new products here)
            list = [
              ...event.returnProduct.map((product) => req.ReturnProduct(
                    returnProductId: product.returnProductId,
                    totalRefund: product.totalRefund,
                    proofImages: product.proofImages,
                    notes: product.notes,
                    productName: product.productName,
                    productImage: product.productImg,
                    barcode: product.barcode,
                    totalUnits: product.totalUnits,
                    isApproved: product.isApproved,
                    reasonToReturn: product.reasonToReturn,
                    supplierId: product.supplierId,
                  )),
              updatedProduct,
            ];
          }

          // Create request model
          req.CreateReturnReqModel reqModel = req.CreateReturnReqModel(
            applicationName: AppStrings.appName,
            clientId: preferencesHelper.getUserId(),
            returnProducts: list,
            subUserId: preferencesHelper.getSubUserId().isNotEmpty ? preferencesHelper.getSubUserId() : null,
            supplierId: event.supplierId,
            isDraft: false,
            orderId: event.orderId,
          );

          // Call API to update return
          final res = await DioClient(event.context).post(
            '${AppUrlEndPoints.updateReturnUrl}${event.returnProduct.first.returnId}',
            data: reqModel.toJson(),
          );

          CreateReturnResModel resModel = CreateReturnResModel.fromJson(res);

          if (resModel.status == AppConstants.code_201) {
            emit(state.copyWith(
              isLoading: false,
            ));

            Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: event.reasonToReturn, 'refresh': true});

            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                res[AppStrings.messageString].toString().toLocalization(),
                event.context,
              ),
              type: SnackBarType.success,
            );
          } else {
            Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: '', 'refresh': false});
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                res[AppStrings.messageString].toString().toLocalization(),
                event.context,
              ),
              type: SnackBarType.failure,
            );
          }
        } catch (e) {
          emit(state.copyWith(isLoading: false));
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: "Something went wrong",
            type: SnackBarType.failure,
          );
        }
      } else if (event is _deleteEvent) {
        emit(state.copyWith(isLoading: true));
        DeleteReturnReq req = DeleteReturnReq(ids: [event.returnId!]);

        try {
          final res = await DioClient(event.context).post(
            AppUrlEndPoints.deleteReturnUrl,
            data: req.toJson(),
          );

          if (res['status'] == AppConstants.code_200) {
            final fullProductList = state.orderBySupplierProduct.products ?? [];
            final deletedProductIndex = fullProductList.indexWhere((product) => product.barcode == event.barcode);

            final updatedProductListIndex = List<int>.from(state.productListIndex);
            if (deletedProductIndex != -1) {
              updatedProductListIndex.remove(deletedProductIndex);
            }

            final isAllCheck = fullProductList.isNotEmpty && fullProductList.length == updatedProductListIndex.length;

            emit(state.copyWith(
              isLoading: false,
              productListIndex: updatedProductListIndex,
              isAllCheck: isAllCheck,
              language: preferencesHelper.getAppLanguage(),
            ));

            // Pass deleted barcode back on pop
            Navigator.pop(event.bottomSheetContext, {
              AppStrings.issueString: event.reasonToReturn,
              'refresh': true,
              'deletedBarcode': event.barcode, // <--- pass barcode here
            });

            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                res[AppStrings.messageString].toString().toLocalization(),
                event.context,
              ),
              type: SnackBarType.success,
            );
          } else {
            Navigator.pop(event.bottomSheetContext, {
              AppStrings.issueString: '',
              'refresh': false,
            });

            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                res[AppStrings.messageString].toString().toLocalization(),
                event.context,
              ),
              type: SnackBarType.failure,
            );
          }
        } catch (e) {
          emit(state.copyWith(isLoading: false));
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: "Something went wrong",
            type: SnackBarType.failure,
          );
        }
      } else if (event is _getArgumentEvent) {
        Map<int, Map<String, dynamic>> radioDataMap = {};

        List<RadioModel> tempList = [];

        RadioModel model1 = RadioModel(id: 1, text: AppLocalizations.of(event.context)!.product_did_not_arrive_at_all);
        RadioModel model2 = RadioModel(id: 2, text: AppLocalizations.of(event.context)!.product_arrived_damaged);
        RadioModel model3 = RadioModel(id: 3, text: AppLocalizations.of(event.context)!.product_arrived_incomplete);
        RadioModel model4 = RadioModel(id: 4, text: AppLocalizations.of(event.context)!.expiration_date_issue);
        RadioModel model5 = RadioModel(id: 5, text: AppLocalizations.of(event.context)!.wrong_product_received);

        tempList.addAll([model1, model2, model3, model4, model5]);

        for (var radioModel in tempList) {
          int radioId = radioModel.id;
          String reasonText = radioModel.text;

          int quantity = getQuantityForReason(reasonText, radioId, event.arguments, event.productQuantity);

          List<String> proofImages = [];
          if (radioId == 2 || radioId == 4) {
            final returnProduct = event.arguments as ReturnProduct?; // cast to your actual type

            if (returnProduct != null && returnProduct.reasonToReturn == reasonText) {
              proofImages = returnProduct.proofImages ?? [];
            }
          }

          radioDataMap[radioId] = {
            'quantity': quantity,
            'proofImage': proofImages,
          };
        }
        emit(state.copyWith(
          productIssueData: Map<int, Map<String, dynamic>>.from(radioDataMap),
        ));
      } else if (event is _pickProofDocumentEvent) {
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
          imgList.addAll(state.driverDeliveryProofImagesList);
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
            emit(state.copyWith(driverDeliveryProofFile: File(croppedImage?.path ?? image.path)));
          } else if (event.value == 2) {
            emit(state.copyWith(driverDeliveryProofFile1: File(croppedImage?.path ?? image.path)));
          } else if (event.value == 3) {
            emit(state.copyWith(driverDeliveryProofFile2: File(croppedImage?.path ?? image.path)));
          }
          emit(state.copyWith(driverDeliveryProofImagesList: imgList));
        }
      } else if (event is _deleteProofFileEvent) {
        final updatedList = List.of(state.driverDeliveryProofImagesList);

        int listIndex = event.index - 1;

        if (listIndex >= 0 && listIndex < updatedList.length) {
          updatedList.removeAt(listIndex);
        } else {}

// Clear the corresponding file slot regardless
        if (event.index == 1) {
          emit(state.copyWith(driverDeliveryProofFile: File(''), driverDeliveryProofImagesList: updatedList));
        } else if (event.index == 2) {
          emit(state.copyWith(driverDeliveryProofFile1: File(''), driverDeliveryProofImagesList: updatedList));
        } else if (event.index == 3) {
          emit(state.copyWith(driverDeliveryProofFile2: File(''), driverDeliveryProofImagesList: updatedList));
        }
      }
    });
  }

  int getQuantityForReason(String reason, int radioVal, dynamic arguments, int productQuantity) {
    try {
      if (arguments != null) {
        if (arguments.reasonToReturn == reason) {
          final returnData = arguments;
          if (returnData.totalUnits != null) return returnData.totalUnits;
        }
      }
    } catch (_) {}
    // Default logic
    if (radioVal == 1 || radioVal == 5) return productQuantity;
    return 1;
  }

  void ensureListLength<T>(List<T> list, int length, T fillValue) {
    while (list.length < length) {
      list.add(fillValue);
    }
  }
}
