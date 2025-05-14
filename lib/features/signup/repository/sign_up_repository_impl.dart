import 'package:car_rental_app/features/signup/repository/sign_up_repository.dart';
import 'package:car_rental_app/services/api_services.dart';
import 'package:car_rental_app/utils/server_constants.dart';

class SignUpRepositoryImpl extends SignUpRepository {
  final ApiServices _apiServices = ApiServices();
  @override
  Future<dynamic> signUp(payload) {
    return _apiServices.postCall(ServerConstants.signup, payload);
  }
}
