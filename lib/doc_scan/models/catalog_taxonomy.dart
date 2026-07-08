/// מחלקה בקטלוג הלקוח.
class CatalogDepartment {
  const CatalogDepartment({required this.code, required this.name});

  final String code;
  final String name;

  factory CatalogDepartment.fromJson(Map<String, dynamic> json) =>
      CatalogDepartment(
        code: (json['code'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
      );
}

/// קבוצה בקטלוג הלקוח (משויכת למחלקה לפי [departmentCode]).
class CatalogGroup {
  const CatalogGroup({
    required this.code,
    required this.name,
    required this.departmentCode,
  });

  final String code;
  final String name;
  final String departmentCode;

  factory CatalogGroup.fromJson(Map<String, dynamic> json) => CatalogGroup(
        code: (json['code'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        departmentCode: (json['departmentCode'] ?? '').toString(),
      );
}
