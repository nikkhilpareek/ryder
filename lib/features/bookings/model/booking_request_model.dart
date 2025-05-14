class BookingRequestModel {
  String? userId;
  String? carId;
  String? startDate;
  String? endDate;

  BookingRequestModel({this.userId, this.carId, this.startDate, this.endDate});

  BookingRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    carId = json['carId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['carId'] = this.carId;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}
