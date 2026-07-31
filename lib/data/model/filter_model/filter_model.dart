class FilterModel {
  BrandModel? brandModel;
  FilterModel({
    this.brandModel,
  });
}

class BrandModel {
  String filterFieldName;
  List<FilterProductModel> filterFieldProductList;

  BrandModel({
    required this.filterFieldProductList,
    required this.filterFieldName,
  });
}

class FilterProductModel {
  bool isSelected;
  bool isExpansion;
  String name;
  List<SubcategoriesFilterModel> subCategoriesList;
  FilterProductModel({this.isSelected = false, required this.name, this.subCategoriesList = const [], this.isExpansion = false});
}

class SubcategoriesFilterModel {
  bool isSelected;
  String name;
  SubcategoriesFilterModel({
    this.isSelected = false,
    required this.name,
  });
}
