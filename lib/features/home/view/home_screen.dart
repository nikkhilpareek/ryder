import 'package:car_rental_app/features/bookings/view/booking_screen.dart';
import 'package:car_rental_app/features/cars/view/cars_list_screen.dart';
import 'package:car_rental_app/features/favourites/view/favourites_screen.dart';
import 'package:car_rental_app/features/profile/view/profile_screen.dart';
import 'package:car_rental_app/utils/colors_constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Widget> screens = const [
    CarsListScreen(),
    FavouritesScreen(),
    BookingScreen(),
    ProfileScreen()
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: screens[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorsConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (value) => onTapAction(value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.heart_broken), label: "Fav Cars"),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  onTapAction(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}

/*
4 option for bottom navigation bar
load the screen in body of the scaffold based on the selected item

Home Screen: 

Home -: screen
favCars -> screen
Bookings -> screen
Profile  -> screen

 */