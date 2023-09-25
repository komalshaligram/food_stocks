
import 'package:food_stock/repository/auth_repo.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future setupInjection() async {
//  await _registerNetworkComponents();
  await _registerRepository();
}



/*Future<void> _registerNetworkComponents() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: "",
      connectTimeout: 10000,
    ),
  );

  dio.interceptors.addAll(
    [
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ),
    ],
  );
  getIt.registerSingleton(dio);

}*/

Future _registerRepository() async {
  //getIt.registerSingleton(AuthRepository());
}
