import 'package:car_rental_app/features/add_car/repository/add_car_repository_impl.dart';
import 'package:car_rental_app/features/add_car/view_model/add_car_view_model.dart';
import 'package:car_rental_app/features/bookings/repository/booking_repository_impl.dart';
import 'package:car_rental_app/features/bookings/view_model/bookin_view_model.dart';
import 'package:car_rental_app/features/cars/repository/car_repository_impl.dart';
import 'package:car_rental_app/features/cars/view_model/cars_view_model.dart';
import 'package:car_rental_app/features/login/repository/login_repository_impl.dart';
import 'package:car_rental_app/features/login/view_model/login_view_model.dart';
import 'package:car_rental_app/features/signup/repository/sign_up_repository_impl.dart';
import 'package:car_rental_app/features/signup/view_model/sign_up_view_model.dart';
import 'package:car_rental_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
void main() {
    configLoading();
  runApp(const MyApp());

}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black
    ..indicatorSize = 45.0
    ..radius = 10.0;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => CarsViewModel(repository: CarRepositoryImpl())),
        ChangeNotifierProvider(
            create: (_) => SignUpViewModel(repository: SignUpRepositoryImpl())),
        ChangeNotifierProvider(
            create: (_) => LoginViewModel(repository: LoginRepositoryImpl())),

        ChangeNotifierProvider(
            create: (_) => AddCarViewModel(repository: AddCarRepositoryImpl())),
        ChangeNotifierProvider(
            create: (_) =>
                BookingViewModel(repository: BookingRepositoryImpl())),

      ],
     
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          
        ),
        routerConfig: AppRouter.router,
         builder: EasyLoading.init(),
        
      ),
    );
  }
}
