part of 'return_driver_bloc.dart';

@freezed
class ReturnDriverState with _$ReturnDriverState {
  const factory ReturnDriverState({
    required bool isRefresh,
    required List<int> productListIndex,
    required OrdersBySupplier orderBySupplierProduct,
    required OrderDatum orderData,
    required bool isShimmering,
    required bool isLoading,
    required bool isAllCheck,
    required String language,
    required bool isCartCount,
    required bool isSubUserCreateDuplicateOrder,
    required File driverDeliveryProofFile,
    required File driverDeliveryProofFile1,
    required File driverDeliveryProofFile2,
    required List<String> driverDeliveryProofImagesList,
    required GetReturnByIdResModel returnList,
    required String? userId,
    required GetClientWaitingForNewOrderReturnModel returnDriverData,
    required Map<int, bool> checkedItems,
    required Map<int, List<File?>> driverDeliveryProofFilesMap,
    required Map<int, List<String?>> driverDeliveryProofUrlsMap,
  }) = _ReturnDriverState;

  factory ReturnDriverState.initial() => ReturnDriverState(
    productListIndex: [],
    isRefresh: false,
    orderBySupplierProduct: const OrdersBySupplier(),
    orderData: const OrderDatum(),
    isShimmering: false,
    isLoading: false,
    isAllCheck: false,
    language: 'en',
    isCartCount: false,
    isSubUserCreateDuplicateOrder: false,
    driverDeliveryProofFile: File(''),
    driverDeliveryProofFile1: File(''),
    driverDeliveryProofFile2: File(''),
    driverDeliveryProofImagesList: [],
    returnList: const GetReturnByIdResModel(),
    userId: '',
    returnDriverData: const GetClientWaitingForNewOrderReturnModel(),
    checkedItems: {},
    driverDeliveryProofFilesMap: {},
      driverDeliveryProofUrlsMap: {},
  );
}
