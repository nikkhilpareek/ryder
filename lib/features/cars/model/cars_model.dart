class CarsModelData {
  List<Cars>? cars;

  CarsModelData({this.cars});

  CarsModelData.fromJson(Map<String, dynamic> json) {
    if (json['cars'] != null) {
      cars = <Cars>[];
      json['cars'].forEach((v) {
        cars!.add(new Cars.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cars != null) {
      data['cars'] = this.cars!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cars {
  String? sId;
  String? name;
  String? brand;
  int? year;
  String? fuelType;
  String? transmission;
  String? address;
  int? pricePerDay;
  String? description;
  String? image;
  bool? available;
  String? userId;
  List<String>? favoriteBy;
  int? iV;

  Cars(
      {this.sId,
      this.name,
      this.brand,
      this.year,
      this.fuelType,
      this.transmission,
      this.address,
      this.pricePerDay,
      this.description,
      this.image,
      this.available,
      this.userId,
      this.favoriteBy,
      this.iV});

  Cars.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    brand = json['brand'];
    year = json['year'];
    fuelType = json['fuelType'];
    transmission = json['transmission'];
    address = json['address'];
    pricePerDay = json['pricePerDay'];
    description = json['description'];
    image = json['image'];
    available = json['available'];
    userId = json['userId'];
    favoriteBy = json['favoriteBy'].cast<String>();
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['name'] = this.name;
    data['brand'] = this.brand;
    data['year'] = this.year;
    data['fuelType'] = this.fuelType;
    data['transmission'] = this.transmission;
    data['address'] = this.address;
    data['pricePerDay'] = this.pricePerDay;
    data['description'] = this.description;
    data['image'] = this.image;
    data['available'] = this.available;
    data['userId'] = this.userId;
    data['favoriteBy'] = this.favoriteBy;
    data['__v'] = this.iV;
    return data;
  }
}
