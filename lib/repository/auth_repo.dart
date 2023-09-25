/*
import 'package:food_stock/data/error/failures.dart';
import 'package:food_stock/data/res_model/login_res_model.dart';
import 'package:food_stock/repository/login_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepository extends BaseApi{

  // Sign In
  Future<Either<Failure, LoginResponse>> signIn({
    required String email,
    String? password,
  }) async {

    final response  = BaseApi().post('api/Account/Login',data: reqMap);
    return response;
  }
  Future<Either<Failure, LoginResponse>> customerLogin() async {
    Map<String,dynamic> reqMap = {
      "MobileNo": "4204204200",
      "OTP": "123456",
      "Longitude": 0,
      "Latitude": 0,
      "Fcmtoken":""
    };
    try {
      final response = await BaseApi().post('api/Account/Login',data: reqMap);
      return Right(LoginResponse.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

}*/
