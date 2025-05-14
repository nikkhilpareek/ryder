import 'package:car_rental_app/utils/images_constants.dart';
import 'package:flutter/material.dart';
//Create the logo widget
class LogoWidget extends StatelessWidget {
const LogoWidget({super.key, this.width = 200, this.height = 200});
  final double? width;
  final double? height;

  // default width and height is 200 and 200 respectively

  @override
  Widget build(BuildContext context){
    return Image.asset(
      ImagesConstants.logo,
      width: width,
      height:height,
    );
  }
}