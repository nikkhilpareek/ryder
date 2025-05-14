class AddCarResponseModel {
  String? message;
  Car? car;

  AddCarResponseModel({this.message, this.car});

  AddCarResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    car = json['car'] != null ? new Car.fromJson(json['car']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.car != null) {
      data['car'] = this.car!.toJson();
    }
    return data;
  }
}

class Car {
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
  List<Null>? favoriteBy;
  String? sId;
  int? iV;

  Car(
      {this.name,
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
      this.sId,
      this.iV});

  Car.fromJson(Map<String, dynamic> json) {
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
    if (json['favoriteBy'] != null) {
      favoriteBy = <Null>[];
      json['favoriteBy'].forEach((v) {
        // favoriteBy!.add(new Null.fromJson(v));
      });
    }
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    if (this.favoriteBy != null) {
      // data['favoriteBy'] = this.favoriteBy!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
