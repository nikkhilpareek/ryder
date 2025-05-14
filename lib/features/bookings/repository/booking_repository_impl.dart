import 'package:car_rental_app/features/bookings/repository/booking_repository.dart';
import 'package:car_rental_app/services/api_services.dart';
import 'package:car_rental_app/utils/local_storage_constants.dart';
import 'package:car_rental_app/utils/server_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingRepositoryImpl extends BookingRepository {
  final ApiServices _apiServices = ApiServices();
  @override
  Future<dynamic> createBooking(dynamic data) async {
    return await _apiServices.postCall(ServerConstants.bookACar, data);
  }
  
  @override
  Future<dynamic> getBookingHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString(LocalStorageConstants.userId) ?? "";
    return await _apiServices.getCall(ServerConstants.getBookedCars + userID);
  }

}