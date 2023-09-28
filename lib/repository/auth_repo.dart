import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/error/failures.dart';
import 'package:food_stock/data/res_model/login_res_model.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:dartz/dartz.dart';

class AuthRepository {

  // Sign In
  Future<Either<Failure, LoginResponse>> signIn() async {
    Map<String,dynamic> reqMap = {
      "MobileNo": "4204204200",
      "OTP": "123456",
      "Longitude": 0,
      "Latitude": 0,
      "Fcmtoken":""
    };
    try {
      final response = await DioClient().post('api/Account/Login',data: reqMap);
      print(response);
      return Right(LoginResponse.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}