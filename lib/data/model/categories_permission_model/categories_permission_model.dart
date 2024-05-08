



class categoriesPermissionModel {
  List<subCategories>? subCategoriesList;
  String? title;
  bool? isEnable;

  categoriesPermissionModel({
     this.subCategoriesList,
     this.title,
     this.isEnable = false,
  });

}

class subCategories {
  String? title;
  bool? isEnable;

  subCategories({
     this.title,
     this.isEnable = false,
  });

}


