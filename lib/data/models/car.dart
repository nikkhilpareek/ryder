class Car {
  final String model;
  final double distance;
  final double fuelCapacity;
  final double pricePerHour;
  final String category; // New field

  Car({
    required this.model,
    required this.distance,
    required this.fuelCapacity,
    required this.pricePerHour,
    this.category = 'Sedan', // Default category
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
      // Add category from Firestore
      category: map['category'] ?? 'Sedan',
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'model': model,
      'distance': distance,
      'fuelCapacity': fuelCapacity,
      'pricePerHour': pricePerHour,
      'category': category,
    };
  }
}
