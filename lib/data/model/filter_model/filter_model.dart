
class FilterModel{
  BrandModel? brandModel;
  FilterModel({
     this.brandModel,
  });
}

class BrandModel {
  String filterFieldName;
  List<FilterProductModel>FilterFieldProductList;

  BrandModel({
    required this.FilterFieldProductList,
    required this.filterFieldName,
});
}

class FilterProductModel {
  bool isSelected;
  String name;
  FilterProductModel({
    this.isSelected = false,
    required this.name,
});
}

