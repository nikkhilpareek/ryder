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
    if (modelLower.contains('swift')) return 'assets/maruti suzuki swift.png';
    if (modelLower.contains('xuv')) return 'assets/mahindra xuv 300.webp';
    if (modelLower.contains('maybach')) return 'assets/maybach gls 600.webp';
    return 'assets/car_image.png';
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'suv':
        return Colors.blue;
      case 'sedan':
        return Colors.green;
      case 'hatchback':
        return Colors.orange;
      case 'luxury':
        return Colors.purple;
      case 'electric':
        return Colors.teal;
      default:
        return Colors.deepPurple;
    }
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
      child: Stack(
        children: [
          // Main Card
          ClipRRect(
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
                    // Car image
                    Image.asset(
                      _getCarImagePath(car.model),
                      height: 120,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/car_image.png', height: 120);
                      },
                    ),
                    
                    // Car details
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          car.model,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // Price section
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: 'Rs. ${car.pricePerHour.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const TextSpan(
                                text: '/hr',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Car features
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Distance feature
                        buildFeature(
                          icon: Icons.speed,
                          value: '${car.distance.toStringAsFixed(0)} km',
                        ),
                        // Fuel capacity feature
                        buildFeature(
                          icon: Icons.local_gas_station,
                          value: '${car.fuelCapacity.toStringAsFixed(0)} L',
                        ),
                        // Rating feature
                        buildFeature(
                          icon: Icons.star,
                          value: '4.8',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Category badge - positioned relative to the entire card
          Positioned(
            top: 5, // Adjusted for proper positioning
            right: 25, // Adjusted to account for card margin
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(car.category).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Text(
                    car.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFeature({required IconData icon, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
