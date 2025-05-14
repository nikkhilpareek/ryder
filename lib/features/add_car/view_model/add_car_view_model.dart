import 'package:car_rental_app/features/add_car/model/addcar_reponse_model.dart';
import 'package:car_rental_app/features/add_car/model/addcar_request_model.dart';
import 'package:car_rental_app/features/add_car/repository/add_car_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddCarViewModel extends ChangeNotifier {

  AddCarRepository repository;
  final List<int> yearsList = List.generate(
    DateTime.now().year - 1901 + 1,
    (index) => 1901 + index,
  );

  List<String> transmissionList = [
    'Manual Transmission',
    'Automatic Transmission',
    'Continuously Variable Transmission (CVT)',
    'Dual-Clutch Transmission (DCT)',
    'Semi-Automatic Transmission',
    'Tiptronic Transmission',
    'Direct Shift Gearbox (DSG)',
    'Electric Vehicle Transmission (EVT)',
  ];
  List<String> fuelTypeList = [
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid (Petrol + Electric)',
    'Plug-in Hybrid (PHEV)',
    'CNG (Compressed Natural Gas)',
    'LPG (Liquefied Petroleum Gas)',
    'Hydrogen (Fuel Cell)',
    'Ethanol (Flex Fuel)',
    'Biodiesel',
  ];

  String? selectedTransmission;
  String? selectedFuelType;
  int? selectedYear;
  XFile? selectedImage;

  AddCarViewModel({required this.repository});

  void setSelectedTransmission(String? value) {
    selectedTransmission = value;
    notifyListeners();
  }

  void setSelectedFuelType(String? value) {
    selectedFuelType = value;
    notifyListeners();
  }

  void setSelectedYear(int? value) {
    selectedYear = value;
    notifyListeners();
  }

  void setSelectedImage(XFile? value) {
    selectedImage = value;
    notifyListeners();
  }

  Future<AddCarResponseModel> addCar(AddCarRequestModel requestModel) async {
    try {
      final response = await repository.addCar(requestModel.toJson());
      final responseModel = AddCarResponseModel.fromJson(response.data);
      return responseModel;
    } catch (e) {
      return AddCarResponseModel(message: e.toString());
    }
  }
}
