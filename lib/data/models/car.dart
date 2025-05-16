class Car {
  final String model;
  final double distance;
  final double fuelCapacity;  // Changed from fuelcapacity
  final double pricePerHour;  // Changed from pricehr

  Car({
    required this.model,
    required this.distance,
    required this.fuelCapacity,  // Changed from fuelcapacity
    required this.pricePerHour,  // Changed from pricehr
  });

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      model: map['model'] ?? '',
      distance: (map['distance'] ?? 0).toDouble(),
      // Handle both naming conventions from Firestore
      fuelCapacity: map['fuelCapacity'] != null 
          ? (map['fuelCapacity']).toDouble() 
          : (map['fuelcapacity'] ?? 0).toDouble(),
      // Handle both naming conventions from Firestore
      pricePerHour: map['pricePerHour'] != null 
          ? (map['pricePerHour']).toDouble() 
          : (map['pricehr'] ?? 0).toDouble(),
    );
  }
  
  // Add toMap method for sending data back to Firebase
  Map<String, dynamic> toMap() {
    return {
      'model': model,
      'distance': distance,
      'fuelCapacity': fuelCapacity,
      'pricePerHour': pricePerHour,
    };
  }
}
