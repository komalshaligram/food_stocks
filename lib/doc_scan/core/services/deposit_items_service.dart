import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../models/deposit_option.dart';

class DepositItemsResult {
  const DepositItemsResult({
    this.misc = const [],
    this.draggedToRegister = const [],
    this.depositItem = const [],
  });

  final List<DepositOption> misc;
  final List<DepositOption> draggedToRegister;
  final List<DepositOption> depositItem;
}

/// טוען את רשימות הפיקדון (שונות / נגרר לקופה / פריט פקדון) דרך getDepositItems.
class DepositItemsService {
  DepositItemsService({required FirebaseApp app, String region = 'europe-west1'})
      : _functions = FirebaseFunctions.instanceFor(app: app, region: region);

  final FirebaseFunctions _functions;

  Future<DepositItemsResult> fetchDepositItems({String? customerCode}) async {
    final callable = _functions.httpsCallable(
      'getDepositItems',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
    );
    final result = await callable.call(<String, dynamic>{
      if (customerCode != null && customerCode.trim().isNotEmpty)
        'customerCode': customerCode.trim(),
    });
    final data = Map<String, dynamic>.from(result.data as Map);

    List<DepositOption> parse(String key) =>
        ((data[key] as List?) ?? const [])
            .whereType<Object?>()
            .map((e) => DepositOption.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();

    return DepositItemsResult(
      misc: parse('misc'),
      draggedToRegister: parse('draggedToRegister'),
      depositItem: parse('depositItem'),
    );
  }
}
