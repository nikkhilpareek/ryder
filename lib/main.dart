import 'package:car_rental_app/firebase_options.dart';
import 'package:car_rental_app/injection_container.dart';
import 'package:car_rental_app/presentation/bloc/bloc/car_bloc.dart';
import 'package:car_rental_app/presentation/bloc/bloc/car_event.dart';
import 'package:car_rental_app/presentation/pages/onboarding_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Global navigator key for navigation from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initInjection();
  runApp(
    DevicePreview(
      enabled: true, // Enable for web demo
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CarBloc>()..add(LoadCars()),
      child: MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Car Rental App',
        theme: ThemeData.dark().copyWith(
          // ignore: deprecated_member_use
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            elevation: 0,
          ),
        ),
        // Always start with the onboarding page regardless of auth state
        home: const OnboardingPage(),
      ),
    );
  }
}
