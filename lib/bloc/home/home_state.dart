part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required String UserImageUrl,
    required String UserCompanyLogoUrl,
    required int cartCount,
    required ProductSalesResModel productSalesList,
    required bool isShimmering,
    required bool isProductLoading,
    required ProductDetailsResModel productDetails,
    required List<ProductStockModel> productStockList,
    required int productStockUpdateIndex,
  }) = _HomeState;

  factory HomeState.initial() => HomeState(
      UserImageUrl: '',
      UserCompanyLogoUrl: '',
      cartCount: 12,
      productSalesList: ProductSalesResModel(),
      isShimmering: false,
      isProductLoading: false,
      productDetails: ProductDetailsResModel(),
      productStockUpdateIndex: -1,
      productStockList: []);
}
