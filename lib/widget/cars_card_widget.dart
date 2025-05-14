
import 'package:car_rental_app/features/cars/model/cars_model.dart';
import 'package:car_rental_app/widget/button_widget.dart';
import 'package:car_rental_app/widget/cache_network_image_widget.dart';
import 'package:flutter/material.dart';
class CarsCardWidget extends StatelessWidget {
const CarsCardWidget(
      {super.key, required this.carData, required this.bookingAction});
final Cars carData;
final Function() bookingAction;


  @override
  Widget build(BuildContext context){
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CacheNetworkImageWidget(imageUrl: carData.image ?? ""),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      carData.name ?? "",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(carData.transmission ?? "",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      carData.fuelType ?? "",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(" ${carData.pricePerDay} / day",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          )
        ,
          SizedBox(
              width: 150,
              child: ButtonWidget(buttonTitle: "Book Now", onPressed: () {
                bookingAction();
              })) 
        ],
      ),
    );
  }
}