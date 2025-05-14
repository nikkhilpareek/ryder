class BookingResponseModel {
  String? message;
  Booking? booking;

  BookingResponseModel({this.message, this.booking});

  BookingResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    booking =
        json['booking'] != null ? new Booking.fromJson(json['booking']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.booking != null) {
      data['booking'] = this.booking!.toJson();
    }
    return data;
  }
}

class Booking {
  String? userId;
  String? carId;
  String? startDate;
  String? endDate;
  int? totalAmount;
  String? sId;
  int? iV;

  Booking(
      {this.userId,
      this.carId,
      this.startDate,
      this.endDate,
      this.totalAmount,
      this.sId,
      this.iV});

  Booking.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    carId = json['carId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    totalAmount = json['totalAmount'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['carId'] = this.carId;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['totalAmount'] = this.totalAmount;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
