import 'package:car_rental_app/features/add_car/repository/add_car_repository.dart';
import 'package:car_rental_app/services/api_services.dart';
import 'package:car_rental_app/utils/local_storage_constants.dart';
import 'package:car_rental_app/utils/server_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCarRepositoryImpl extends AddCarRepository {
  final ApiServices _apiServices = ApiServices();
  @override
  Future<dynamic> addCar(data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString(LocalStorageConstants.userId) ?? "";
    final res = await _apiServices.postCallWithFormData(
        ServerConstants.addCar + userID, data);
    return res;
  }
}
