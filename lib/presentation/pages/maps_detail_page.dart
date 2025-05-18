// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:car_rental_app/data/models/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:car_rental_app/presentation/pages/booking_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MapsDetailPage extends StatelessWidget {
  final Car car;

  const MapsDetailPage({super.key, required this.car});
  
  // Get appropriate image based on car model
  String _getCarImagePath(String model) {
    // Convert model name to lowercase for case-insensitive comparison
    final modelLower = model.toLowerCase();
    
    if (modelLower.contains('creta')) {
      return 'assets/creta.webp';
    } else if (modelLower.contains('civic')) {
      return 'assets/civic.png';
    } else if (modelLower.contains('corolla')) {
      return 'assets/corolla.png';
    } else if (modelLower.contains('fortuner')) {
      return 'assets/fortuner.png';}
    else if (modelLower.contains('harrier')) {
      return 'assets/harrier.webp';
    } 
    else if (modelLower.contains('xuv')) {
      return 'assets/mahindra xuv 300.webp';
    }
    else if (modelLower.contains('swift')) {
      return 'assets/maruti suzuki swift.png';
    }
    else if (modelLower.contains('maybach')) {
      return 'assets/maybach gls 600.webp';
    }
    // else if (modelLower.contains('ferrari')) {
    //   return 'assets/ferrari_car.png';
    // } else if (modelLower.contains('lamborghini')) {
    //   return 'assets/lamborghini_car.png';
    // }
    
    // Default image if no match found
    return 'assets/car_image.png';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(26.9124, 75.7873), // Changed to Jaipur coordinates
              zoom: 13.0,
            ),
            nonRotatedChildren: [ // Use nonRotatedChildren instead of children for newer flutter_map versions
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              // Add marker for Jaipur
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(26.9124, 75.7873),
                    width: 40,
                    height: 40,
                    builder: (context) => Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
              bottom: 0, left: 0, right: 0, child: carDetailsCard(context: context, car: car, getCarImagePath: _getCarImagePath)),
        ],
      ),
    );
  }
}

Widget carDetailsCard({
  required BuildContext context,
  required Car car,
  required String Function(String) getCarImagePath,
}) {
  return SizedBox(
    height: 350,
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          car.model,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(car.category).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
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
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.directions_car, color: Colors.white, size: 16),
                      SizedBox(width: 5),
                      Text(
                        '> ${car.distance} km',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.battery_full, color: Colors.white, size: 16),
                      SizedBox(width: 5),
                      Text(
                        car.fuelCapacity.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Features",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    featureIcons(),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs. ${car.pricePerHour.toStringAsFixed(2)}/hour',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Day rate: Rs. ${(car.pricePerHour * 10).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: () {
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BookingPage(
      carName: car.model,
      pricePerDay: car.pricePerHour * 10,
      carImage: getCarImagePath(car.model),
      category: car.category, // Add this line
    ),
  ),
);
                              },
                              child: const Text('Book Now'),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 10,
          child: Image.asset(
            getCarImagePath(car.model),
            height: 120,
            width: 160,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/white_car.png',
                height: 120,
                width: 160,
              );
            },
          ),
        ),
      ],
    ),
  );
}
// Alternative implementation with more manual spacing control

Widget featureIcons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center, // Center the entire row
    children: [
      featureIcon(Icons.local_gas_station, 'Diesel', 'Common Rail'),
      SizedBox(width: 15), // Add explicit spacing between icons
      featureIcon(Icons.speed, 'Accleration', '0-100km/s'),
      SizedBox(width: 15), // Add explicit spacing between icons
      featureIcon(Icons.ac_unit, 'Cold', 'Temp Control'),
    ],
  );
}

// You may also want to adjust the featureIcon width to ensure they fit well
Widget featureIcon(IconData icon, String title, String subtitle) {
  return Container(
    width: 95, // Slightly reduced to ensure all three fit with spacing
    height: 100,
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      // Dark theme styling with glassmorphism effect
      color: const Color(0xFF1E1E1E).withOpacity(0.75),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: Colors.white.withOpacity(0.1), // Subtle border
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 28,
          color: Colors.deepPurpleAccent, // Accent color for icon
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white, // Light text for dark background
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey, // Secondary text in gray
            fontSize: 10,
          ),
        ),
      ],
    ),
  );
}

void showBookingDialog(Car car) {
  // Create form key for validation
  final formKey = GlobalKey<FormState>();
  
  // Form field controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  
  // Date and time selection
  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 0);
  int hours = 1;
  
  // Show dialog
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Book ${car.model}'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Full Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: phoneController,  // Added missing controller
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      title: Text('Booking Date'),
                      subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 90)),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text('Pickup Time'),
                      subtitle: Text('${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}'),
                      trailing: Icon(Icons.access_time),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null && picked != selectedTime) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                    ),
                    Row(
                      children: [
                        Text('Rental Duration: '),
                        DropdownButton<int>(
                          value: hours,
                          items: [1, 2, 4, 6, 10, 24].map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value hour${value > 1 ? 's' : ''}'),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              hours = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    
                    // Add this info text about day rate
                    if (hours >= 10 && hours <= 24)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Day rate applied: Fixed price for 10-24 hours',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    
                    SizedBox(height: 10),
                    Text(
                      'Total Price: Rs. ${calculateTotalPrice(car.pricePerHour, hours)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Form is valid, process the booking
                    _showPaymentScreen(
                      context, 
                      car, 
                      nameController.text, 
                      phoneController.text, 
                      emailController.text,
                      selectedDate,
                      selectedTime,
                      hours
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: Text('Confirm Booking', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showPaymentScreen(
  BuildContext context, 
  Car car, 
  String name, 
  String phone, 
  String email,
  DateTime date,
  TimeOfDay time,
  int hours
) {
  // Create controllers for payment inputs
  final cardNumberController = TextEditingController();
  final cardNameController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isProcessing = false;
  
  // Calculate total price
  final totalPrice = calculateTotalPrice(car.pricePerHour, hours);
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Payment Details'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking summary
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Booking Summary', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Car:'),
                              Text(car.model, style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Date:'),
                              Text('${date.day}/${date.month}/${date.year}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Time:'),
                              Text('${time.hour}:${time.minute.toString().padLeft(2, '0')}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Duration:'),
                              Text('$hours hour${hours > 1 ? 's' : ''}'),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Rs. $totalPrice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Payment method selection with card as default
                    Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.credit_card),
                        SizedBox(width: 10),
                        Text('Credit/Debit Card'),
                      ],
                    ),
                    SizedBox(height: 15),
                    
                    // Card details
                    TextFormField(
                      controller: cardNumberController,
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        hintText: '1234 5678 9012 3456',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 19,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card number';
                        } else if (value.replaceAll(' ', '').length < 16) {
                          return 'Card number must be 16 digits';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // Format card number with spaces every 4 digits
                        if (value.isNotEmpty) {
                          value = value.replaceAll(' ', '');
                          String newValue = '';
                          for (int i = 0; i < value.length; i++) {
                            if (i > 0 && i % 4 == 0) {
                              newValue += ' ';
                            }
                            newValue += value[i];
                          }
                          if (value != newValue) {
                            cardNumberController.value = TextEditingValue(
                              text: newValue,
                              selection: TextSelection.collapsed(offset: newValue.length),
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: cardNameController,
                      decoration: InputDecoration(
                        labelText: 'Name on Card',
                        hintText: 'JOHN SMITH',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name on card';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        // Expiry date
                        Expanded(
                          child: TextFormField(
                            controller: expiryController,
                            decoration: InputDecoration(
                              labelText: 'Expiry (MM/YY)',
                              hintText: '05/25',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              } else if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                                return 'Use MM/YY format';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              // Auto-add slash after month
                              if (value.length == 2 && !value.contains('/')) {
                                expiryController.text = '$value/';
                                expiryController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: expiryController.text.length),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        // CVV
                        Expanded(
                          child: TextFormField(
                            controller: cvvController,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              hintText: '123',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              } else if (value.length < 3) {
                                return 'Enter 3 digits';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isProcessing 
                    ? null 
                    : () async {
                        if (formKey.currentState!.validate()) {
                          // Simulate payment processing
                          setState(() {
                            isProcessing = true;
                          });
                          
                          // Simulate API call with delay
                          await Future.delayed(Duration(seconds: 2));
                          
                          setState(() {
                            isProcessing = false;
                          });
                          
                          // Close payment dialog
                          Navigator.of(context).pop();
                          
                          // Process the booking with successful payment
                          _processBooking(
                            context, 
                            car, 
                            name, 
                            phone, 
                            email,
                            date,
                            time,
                            hours
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey,
                ),
                child: isProcessing
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(
                            width: 16, 
                            height: 16, 
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Processing...', style: TextStyle(color: Colors.white)),
                        ],
                      )
                    : Text('Pay Rs. $totalPrice', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}

void _processBooking(
  BuildContext context, 
  Car car, 
  String name, 
  String phone, 
  String email,
  DateTime date,
  TimeOfDay time,
  int hours
) {
  // Here you would normally save the booking to Firebase
  // For now, we'll show a success dialog
  
  Navigator.of(context).pop(); // Close booking form
  
  // Show confirmation
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Booking Confirmed!'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Thank you for your booking, $name!'),
            SizedBox(height: 10),
            Text('Car: ${car.model}'),
            Text('Date: ${date.day}/${date.month}/${date.year}'),
            Text('Time: ${time.hour}:${time.minute.toString().padLeft(2, '0')}'),
            Text('Duration: $hours hour${hours > 1 ? 's' : ''}'),
            Text('Total Price: Rs. ${calculateTotalPrice(car.pricePerHour, hours)}'),
            SizedBox(height: 10),
            Text('We\'ll contact you at $phone shortly to confirm your reservation.'),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          child: Text('OK', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
  
  // In a real app, you would save the booking to Firestore like this:
  /*
  FirebaseFirestore.instance.collection('bookings').add({
    'carModel': car.model,
    'customerName': name,
    'customerPhone': phone,
    'customerEmail': email,
    'bookingDate': Timestamp.fromDate(date),
    'pickupTime': '${time.hour}:${time.minute}',
    'duration': hours,
    'totalPrice': car.pricePerHour * hours,
    'status': 'pending',
    'createdAt': FieldValue.serverTimestamp(),
  });
  */
}

String calculateTotalPrice(double hourlyRate, int hours) {
  double totalPrice;
  
  // Special day rate for rentals between 10 and 24 hours
  if (hours >= 10 && hours <= 24) {
    totalPrice = hourlyRate * 10; // Fixed day rate (10x hourly rate)
  } else {
    totalPrice = hourlyRate * hours; // Regular hourly rate
  }
  
  return totalPrice.toStringAsFixed(2);
}

// Add helper method at the end of the file
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
