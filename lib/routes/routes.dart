import 'package:car_rental_app/features/add_car/view/add_car_screen.dart';
import 'package:car_rental_app/features/bookings/view/booking_screen.dart';
import 'package:car_rental_app/features/car_details/view/car_details_screen.dart';
import 'package:car_rental_app/features/favourites/view/favourites_screen.dart';
import 'package:car_rental_app/features/home/view/home_screen.dart';
import 'package:car_rental_app/features/login/view/login_screen.dart';
import 'package:car_rental_app/features/profile/view/profile_screen.dart';
import 'package:car_rental_app/features/signup/view/signup_screen.dart';
import 'package:car_rental_app/features/splash/view/splash_scren.dart';
import 'package:car_rental_app/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {

static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

static final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
      initialLocation: RoutesConstants.splashScreen,
  routes: <RouteBase>[
    GoRoute(
      path: RoutesConstants.splashScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScren();
      },
    ),
    GoRoute(
      path: RoutesConstants.loginScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: RoutesConstants.signUpScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const SignupScreen();
      },
    ),
    GoRoute(
      path: RoutesConstants.homeScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: RoutesConstants.carDetailsScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const CarDetailsScreen();
      },
    ),
    GoRoute(
        path: RoutesConstants.bookingScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const BookingScreen();
        }),
    GoRoute(
        path: RoutesConstants.favoriteScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const FavouritesScreen();
        }),
    GoRoute(
        path: RoutesConstants.addCar,
        builder: (BuildContext context, GoRouterState state) {
          return const AddCarScreen();
        }),
    GoRoute(
        path: RoutesConstants.profileScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        })
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return const Scaffold(
      body: Center(
        child: Text('Error'),
      ),
    );
  }
);
}
