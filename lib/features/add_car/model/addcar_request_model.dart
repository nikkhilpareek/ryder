class AddCarRequestModel {
  final String name;
  final String brand;
  final String year;
  final String fuelType;
  final String transmission;
  final String address;
  final String pricePerDay;
  final String description;
  final dynamic imagePath;

  AddCarRequestModel({
    required this.name,
    required this.brand,
    required this.year,
    required this.fuelType,
    required this.transmission,
    required this.address,
    required this.pricePerDay,
    required this.description,
    required this.imagePath,
  });

  factory AddCarRequestModel.fromJson(Map<String, dynamic> json) {
    return AddCarRequestModel(
      name: json['name'],
      brand: json['brand'],
      year: json['year'],
      fuelType: json['fuelType'],
      transmission: json['transmission'],
      address: json['address'],
      pricePerDay: json['pricePerDay'],
      description: json['description'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'year': year,
      'fuelType': fuelType,
      'transmission': transmission,
      'address': address,
      'pricePerDay': pricePerDay,
      'description': description,
      'image': imagePath,
    };
  }
}
