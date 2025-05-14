import 'package:car_rental_app/features/add_car/model/addcar_reponse_model.dart';
import 'package:car_rental_app/features/bookings/model/booking_history_model.dart';
import 'package:flutter/material.dart';

class BookingHositoryCarWidget extends StatelessWidget {
  const BookingHositoryCarWidget({super.key, required this.bookingsData});
  final Bookings bookingsData;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(bookingsData.carId?.name ?? ""),
          Text(bookingsData.startDate ?? ""),
          Text(bookingsData.endDate ?? ""),
          Text("${bookingsData.carId?.pricePerDay ?? 0}"),
        ],
      ),
    );
  }
}
