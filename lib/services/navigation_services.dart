import 'package:car_rental_app/routes/routes.dart';

class NavigationServices {
  static final NavigationServices _instance = NavigationServices._internal();
  NavigationServices._internal();
  factory NavigationServices() {
    return _instance;
  }

  Future<dynamic> navigateTo(String routeName) async {
    return AppRouter.router.push(routeName);
  }

  Future<dynamic> navigateToWithParameters(
      String routeName, Object arguments) async {
    return AppRouter.router.pushNamed(routeName, extra: arguments);
  }

  void goBack() {
    return AppRouter.router.pop();
  }

  void replaceWith(String routeName) {
    AppRouter.router.replace(routeName);
  }

  void replaceAll(String routeName){
     AppRouter.router.go(routeName);
  }

  // navition push
  // pop
  // push with paramerters
  // push with parameters and remove until
  // pop until
  // push and replace
  //pop back
}
