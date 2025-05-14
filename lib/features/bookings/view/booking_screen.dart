import 'package:car_rental_app/features/bookings/view_model/bookin_view_model.dart';
import 'package:car_rental_app/utils/loader_utils.dart';
import 'package:car_rental_app/widget/booking_hository_car_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({ Key? key }) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    final bookingViewModel = Provider.of<BookingViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookings "),
      ),
      body: Center(
          child: ListView.builder(
        itemCount: bookingViewModel.bookingsList.length,
        itemBuilder: (context, index) {
          return BookingHositoryCarWidget(
              bookingsData: bookingViewModel.bookingsList[index]);
        },
      )
      ),
    );
  }

  @override
  void initState() {
    fetchBookingHistory();
    super.initState();
  }

  fetchBookingHistory() {
    // fetch the booking history
    final bookingViewModel =
        Provider.of<BookingViewModel>(context, listen: false);
    LoaderWidget.showLoader();
    bookingViewModel.getBookingHistory();
    LoaderWidget.hideLoader();
  }
}