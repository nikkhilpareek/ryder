import 'package:car_rental_app/features/login/view_model/login_view_model.dart';
import 'package:car_rental_app/features/splash/view_model/splash_view_model.dart';
import 'package:car_rental_app/routes/routes_constants.dart';
import 'package:car_rental_app/services/navigation_services.dart';
import 'package:car_rental_app/utils/local_storage_constants.dart';
import 'package:car_rental_app/widget/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScren extends StatefulWidget {
  const SplashScren({super.key});

  @override
  _SplashScrenState createState() => _SplashScrenState();
}

class _SplashScrenState extends State<SplashScren> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LogoWidget(width: 300, height: 300),
      ),
    );
  }

  @override
  void initState() {
    checkUserSession();
    super.initState();
  }

  checkUserSession() async {
    /*
     get the user id from local storage -> is user is empty -> navigate the user to login screen 
     otherwise user navigate to home 
     */
    await Future.delayed(const Duration(seconds: splashDuration));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString(LocalStorageConstants.userId) ?? "";
    if (userID.isEmpty) {
      NavigationServices().replaceAll(RoutesConstants.loginScreen);
    } else {
      NavigationServices().replaceAll(RoutesConstants.homeScreen);
    }

    // prefs.clear();

  }
}