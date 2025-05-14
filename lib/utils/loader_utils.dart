
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoaderWidget {
  static void showLoader({String  message = "Loading..."}){
    EasyLoading.show(status: 'loading...');
  }
  static void hideLoader(){
    EasyLoading.dismiss();
  }
}