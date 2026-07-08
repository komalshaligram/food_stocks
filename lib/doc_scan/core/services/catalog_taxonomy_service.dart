import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../models/catalog_taxonomy.dart';

class CatalogTaxonomyResult {
  const CatalogTaxonomyResult({
    this.departments = const [],
    this.groups = const [],
  });

  final List<CatalogDepartment> departments;
  final List<CatalogGroup> groups;
}

/// טוען את רשימת המחלקות והקבוצות של הקטלוג דרך ה-Cloud Function getCatalogTaxonomy.
class CatalogTaxonomyService {
  CatalogTaxonomyService({required FirebaseApp app, String region = 'europe-west1'})
      : _functions = FirebaseFunctions.instanceFor(app: app, region: region);

  final FirebaseFunctions _functions;

  Future<CatalogTaxonomyResult> fetchTaxonomy({String? customerCode}) async {
    final callable = _functions.httpsCallable(
      'getCatalogTaxonomy',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 60)),
    );
    final result = await callable.call(<String, dynamic>{
      if (customerCode != null && customerCode.trim().isNotEmpty)
        'customerCode': customerCode.trim(),
    });
    final data = Map<String, dynamic>.from(result.data as Map);

    final departments = ((data['departments'] as List?) ?? const [])
        .whereType<Object?>()
        .map((e) => CatalogDepartment.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final groups = ((data['groups'] as List?) ?? const [])
        .whereType<Object?>()
        .map((e) => CatalogGroup.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return CatalogTaxonomyResult(departments: departments, groups: groups);
  }
}
