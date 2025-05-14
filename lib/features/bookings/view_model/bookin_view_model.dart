import 'package:car_rental_app/features/bookings/model/booking_history_model.dart';
import 'package:car_rental_app/features/bookings/model/booking_request_model.dart';
import 'package:car_rental_app/features/bookings/model/booking_response_model.dart';
import 'package:car_rental_app/features/bookings/repository/booking_repository.dart';
import 'package:flutter/material.dart';

class BookingViewModel extends ChangeNotifier {
  final BookingRepository repository;
  List<Bookings> bookingsList = [];
  BookingViewModel({required this.repository});

  Future<BookingResponseModel> createBooking(BookingRequestModel data) async {
    try {
      final response = await repository.createBooking(data.toJson());
      final bookingResponseModel = BookingResponseModel.fromJson(response.data);
      return bookingResponseModel;
    } catch (e) {
      return BookingResponseModel(message: e.toString());
    }
    //  return await repository.createBooking(data.toJson());
  }

  Future<void> getBookingHistory() async {
    try {
      final response = await repository.getBookingHistory();
      final bookingHistoryResponseModel =
          BookingHistoryResponseModel.fromJson(response.data);
      bookingsList = bookingHistoryResponseModel.bookings ?? [];
      notifyListeners();
    } catch (e) {
      bookingsList = [];
      notifyListeners();
    }
  }
}
