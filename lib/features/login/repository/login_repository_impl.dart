import 'package:car_rental_app/features/login/repository/login_repository.dart';
import 'package:car_rental_app/services/api_services.dart';
import 'package:car_rental_app/utils/server_constants.dart';

class LoginRepositoryImpl  extends LoginRepository{
  final _apiServices = ApiServices();
  @override
  Future<dynamic> login(payload) {
    return _apiServices.postCall(ServerConstants.signIn, payload);
  }
  

}