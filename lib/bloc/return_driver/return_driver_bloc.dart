import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/model/res_model/file_upload_model/file_upload_model.dart';
import '../../data/model/res_model/get_client_waiting_for_new_order_return_products/get_client_waiting_for_new_order_return_products_model.dart';
import '../../data/model/res_model/get_return_by_id_res_model/get_return_by_id_res_model.dart';
import '../../ui/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/account_permission/account_permission_res_model.dart';
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';

part 'return_driver_event.dart';
part 'return_driver_state.dart';
part 'return_driver_bloc.freezed.dart';

class ReturnDriverBloc extends Bloc<ReturnDriverEvent, ReturnDriverState> {
  ReturnDriverBloc() : super(ReturnDriverState.initial()) {
    on<ReturnDriverEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getOrderByIdEvent) {
        emit(state.copyWith(isShimmering: true, isLoading: true, language: preferences.getAppLanguage(), isSubUserCreateDuplicateOrder: preferences.getCanDuplicateOrder()));
        try {
          final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getOrderById}${preferences.getOrderId()}');
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
                userId: preferences.getUserId(),
              ),
            );
            add(ReturnDriverEvent.getDriverReturnIdEvent(context: event.context, userId: state.userId!));
          } else {
            emit(state.copyWith(isShimmering: false, isLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false, isLoading: false));
        } catch (e) {
          emit(state.copyWith(isShimmering: false, isLoading: false));
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      } else if (event is _getDriverReturnIdEvent) {
        emit(state.copyWith(isShimmering: true, isLoading: true, language: preferences.getAppLanguage(), isSubUserCreateDuplicateOrder: preferences.getCanDuplicateOrder()));
        try {
          final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getClientPendingReturnProducts}${preferences.getOrderId()}');
          GetClientWaitingForNewOrderReturnModel response = GetClientWaitingForNewOrderReturnModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(returnDriverData: response, isShimmering: false, isLoading: false, isRefresh: !state.isRefresh, userId: preferences.getUserId()));
          } else {
            emit(state.copyWith(isShimmering: false, isLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false, isLoading: false));
        } catch (e) {
          emit(state.copyWith(isShimmering: false, isLoading: false));
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      } else if (event is _checkAllEvent) {
        int length = state.returnDriverData.data?.length ?? 0;
        final Map<int, bool> updatedCheckedItems = {};
        if (!state.isAllCheck) {
          for (int i = 0; i < length; i++) {
            updatedCheckedItems[i] = true;
          }
        }
        emit(state.copyWith(checkedItems: updatedCheckedItems, isAllCheck: !state.isAllCheck));
      } else if (event is _getPermissionList) {
        if (preferences.getSubUser()) {
          try {
            final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getAccountPermissionUrl}${preferences.getSubUserId()}');
            AccountPermissionResModel response = AccountPermissionResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              var res = response.data?.permissions;
              preferences.setCanSeeWallet(isSeeWallet: res?.canSeeWallet ?? false);
              preferences.setCanAddBasket(isAddBasket: res?.canAddToCart ?? false);
              preferences.setCanCreateOrder(isCreateOrder: res?.canCreateOrder ?? false);
              preferences.setCanSeeOrder(isSeeOrder: res?.canSeeOrders ?? false);
              preferences.setCanDuplicateOrder(isDuplicateOrder: res?.canDuplicateOrders ?? false);
              preferences.setCanUpdateBusinessInfo(isUpdateBusinessInfo: res?.canSeeAndUpdateBusinessInfo ?? false);
              preferences.setCanUpdateAdditionalInfo(isUpdateAdditionalInfo: res?.canSeeAndUpdateAdditionalInfo ?? false);
              preferences.setCanUpdateTimeInfo(isUpdateTimeInfo: res?.canSeeAndUpdateTimesInfo ?? false);
              preferences.setCanSeeFormsFiles(isSeeFormsFiles: res?.canSeeFileAndForms ?? false);
              preferences.setManageSubUser(isManageSubUser: res?.canManageSubUsers ?? false);
            } else {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
            }
          } catch (e) {
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          }
        }
      } else if (event is _getReturnListEvent) {
        try {
          final response = await DioClient(event.context).get(path: AppUrlEndPoints.getReturnByIdUrl + preferences.getOrderId());
          GetReturnByIdResModel res = GetReturnByIdResModel.fromJson(response);
          emit(state.copyWith(returnList: res));
        } catch (e) {
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      } else if (event is _pickProofDocumentEvent) {
        XFile? image = await openImagePicker(event.isFromCamera ? ImageSource.camera : ImageSource.gallery);
        if (image != null) {
          CroppedFile? croppedImage = await cropImage(path: image.path, shape: CropStyle.rectangle, quality: AppConstants.fileQuality);
          if (croppedImage?.path.isEmpty ?? true) return;
          final absoluteCroppedImagePath = await _getAbsoluteFilePath(croppedImage!.path);
          final File croppedFile = File(absoluteCroppedImagePath);
          if (!croppedFile.existsSync()) {
            return;
          }
          final int fileLength = await croppedFile.length();
          String imageSize = getFileSizeString(bytes: fileLength);
          if (int.parse(imageSize.split(' ').first) == 0) return;

          final response = await DioClient(event.context).uploadFileProgressWithFormData(
            path: AppUrlEndPoints.fileUploadUrl,
            formData: FormData.fromMap({AppStrings.returnImagesString: await MultipartFile.fromFile(croppedFile.path, contentType: MediaType('image', 'png'))}),
          );
          FileUploadModel signModel1 = FileUploadModel.fromJson(response);
          if (signModel1.filepath == '') return;
          Map<int, List<File?>> updatedMap1 = Map.from(state.driverDeliveryProofFilesMap);
          List<File?> files1 = List<File?>.from(updatedMap1[event.index] ?? List.filled(3, null));
          File file1 = File(croppedImage.path);
          if (event.value >= 0 && event.value < 3) {
            files1[event.value] = file1;
          }
          updatedMap1[event.index] = files1;
          FileUploadModel signModel = FileUploadModel.fromJson(response);
          if (signModel.filepath!.isEmpty) return;
          String uploadedImageUrl = signModel.filepath!;
          Map<int, List<String?>> updatedMap = Map.from(state.driverDeliveryProofUrlsMap);
          List<String?> urls = List<String?>.from(updatedMap[event.index] ?? List.filled(3, null));

          if (event.value >= 0 && event.value < 3) {
            urls[event.value] = uploadedImageUrl;
          }

          updatedMap[event.index] = urls;
          emit(state.copyWith(driverDeliveryProofUrlsMap: updatedMap, driverDeliveryProofFilesMap: updatedMap1));
        }
      } else if (event is _deleteProofFileEvent) {
        Map<int, List<File?>> updatedMap = Map.from(state.driverDeliveryProofFilesMap);
        List<File?> files = List<File?>.from(updatedMap[event.index] ?? List.filled(3, null));
        if (event.fileIndex >= 0 && event.fileIndex < files.length) {
          files[event.fileIndex] = null;
        }
        updatedMap[event.index] = files;
        emit(state.copyWith(driverDeliveryProofFilesMap: updatedMap));
      } else if (event is _toggleItemChecked) {
        final updatedCheckedItems = Map<int, bool>.from(state.checkedItems);
        updatedCheckedItems[event.index] = event.isChecked;
        int totalItems = state.returnDriverData.data?.length ?? 0;
        bool allChecked = updatedCheckedItems.length == totalItems && updatedCheckedItems.values.every((checked) => checked);
        emit(state.copyWith(checkedItems: updatedCheckedItems, isAllCheck: allChecked));
      }
    });
  }

  Future<String> _getAbsoluteFilePath(String path) async {
    if (path.startsWith('/')) {
      return path;
    }
    final tempDir = await getTemporaryDirectory();
    return '${tempDir.path}/$path';
  }
}
