import 'dart:ui';
import 'package:car_rental_app/data/models/car.dart';
import 'package:car_rental_app/presentation/pages/car_details_page.dart';
import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final Car car;

  const CarCard({super.key, required this.car});

  String _getCarImagePath(String model) {
    final modelLower = model.toLowerCase();
    if (modelLower.contains('creta')) return 'assets/creta.webp';
    if (modelLower.contains('civic')) return 'assets/civic.png';
    if (modelLower.contains('corolla')) return 'assets/corolla.png';
    if (modelLower.contains('fortuner')) return 'assets/fortuner.png';
    if (modelLower.contains('harrier')) return 'assets/harrier.webp';
    return 'assets/car_image.png';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailsPage(car: car),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Image.asset(
                  _getCarImagePath(car.model),
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/car_image.png', height: 120);
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  car.model,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/gps.png', height: 16, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          '${car.distance.toStringAsFixed(0)}km',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(width: 10),
                        Image.asset('assets/pump.png', height: 16, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          '${car.fuelCapacity.toStringAsFixed(0)}L',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    Text(
                      'Rs. ${car.pricePerHour.toStringAsFixed(2)}/h',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
