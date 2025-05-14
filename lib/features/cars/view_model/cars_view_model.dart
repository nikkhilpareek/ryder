import 'package:car_rental_app/features/cars/model/cars_model.dart';
import 'package:car_rental_app/features/cars/repository/car_repository.dart';
import 'package:car_rental_app/utils/loader_utils.dart';
import 'package:flutter/material.dart';

class CarsViewModel extends ChangeNotifier {
  List<Cars> cars = [];
  CarRepository repository;
  CarsViewModel({required this.repository});

  //Api Serice
  //Repos -> abstract -> imple

  Future<void> getCars() async {
    try {
      LoaderWidget.showLoader();
      final response = await repository.getCarsList();
      LoaderWidget.hideLoader();
      if (response.statusCode == 200) {
        final carsModel = CarsModelData.fromJson(response.data);
        cars = carsModel.cars ?? [];
      }
    } catch (e) {
      LoaderWidget.hideLoader();
      cars = [];
    } finally {
      notifyListeners();
    }

//api/cars
  }
}

// view -> VM - > dio -> call 
// view- > VM -> repository -> Apiservice 