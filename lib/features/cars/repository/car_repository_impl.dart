
import 'package:car_rental_app/features/cars/repository/car_repository.dart';
import 'package:car_rental_app/services/api_services.dart';
import 'package:car_rental_app/utils/server_constants.dart';

class CarRepositoryImpl extends CarRepository {
  final ApiServices _apiServices = ApiServices();
  @override
  Future<dynamic> getCarsList() {
    return _apiServices.getCall(ServerConstants.getAllCars);
  }
  
  @override
  Future addCar(data) {
    // TODO: implement addCar
    throw UnimplementedError();
  }
}

