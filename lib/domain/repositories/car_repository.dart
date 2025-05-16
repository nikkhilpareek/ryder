import 'package:car_rental_app/data/models/car.dart';

abstract class CarRepository {
  Future<List<Car>> fetchCars();
}