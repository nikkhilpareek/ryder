import 'package:car_rental_app/utils/colors_constants.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      required this.buttonTitle,
      required this.onPressed,
      this.buttonBgColor = ColorsConstants.primaryColor,
      this.buttonWidth = double.infinity,
      this.buttonTextColor = Colors.white});
  final String buttonTitle;
  final void Function() onPressed;
  final Color buttonBgColor;
  final double buttonWidth;
  final Color buttonTextColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonBgColor,
          ),
          child: Text(
            buttonTitle,
            style: TextStyle(fontSize: 16, color: buttonTextColor),
          ),
        ));
  }
}
