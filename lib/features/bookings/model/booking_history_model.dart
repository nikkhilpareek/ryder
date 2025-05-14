class BookingHistoryResponseModel {
  List<Bookings>? bookings;

  BookingHistoryResponseModel({this.bookings});

  BookingHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(new Bookings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookings != null) {
      data['bookings'] = this.bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bookings {
  String? sId;
  String? userId;
  CarId? carId;
  String? startDate;
  String? endDate;
  int? totalAmount;
  int? iV;

  Bookings(
      {this.sId,
      this.userId,
      this.carId,
      this.startDate,
      this.endDate,
      this.totalAmount,
      this.iV});

  Bookings.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    carId = json['carId'] != null ? new CarId.fromJson(json['carId']) : null;
    startDate = json['startDate'];
    endDate = json['endDate'];
    totalAmount = json['totalAmount'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    if (this.carId != null) {
      data['carId'] = this.carId!.toJson();
    }
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['totalAmount'] = this.totalAmount;
    data['__v'] = this.iV;
    return data;
  }
}

class CarId {
  String? sId;
  String? name;
  String? brand;
  int? pricePerDay;

  CarId({this.sId, this.name, this.brand, this.pricePerDay});

  CarId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    brand = json['brand'];
    pricePerDay = json['pricePerDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['brand'] = this.brand;
    data['pricePerDay'] = this.pricePerDay;
    return data;
  }
}
