import 'package:car_rental_app/features/signup/model/sign_up_request_model.dart';
import 'package:car_rental_app/features/signup/model/sign_up_resoonse_model.dart';
import 'package:car_rental_app/features/signup/repository/sign_up_repository.dart';
import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  SignUpRepository repository;
  SignUpViewModel({required this.repository});

  Future<SignUpResponseModel> signUpTheUser(SignUpRequestModel model) async {
    try {
      final response = await repository.signUp(model.toJson());
      SignUpResponseModel signUpResponseModel =
          SignUpResponseModel.fromJson(response.data);
      return signUpResponseModel;
    } catch (e) {
      return SignUpResponseModel(error: true,message: "Something went Wrong!!");
    }
  }
}
