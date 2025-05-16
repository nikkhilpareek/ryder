import 'package:car_rental_app/presentation/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C2B34),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2C2B34), Color(0xff1F1E26)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Centered background image with spacing - now larger and aligned to left
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft, // Align to left to allow right-side overflow
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 60.0, 
                  bottom: 60.0,
                  right: 0, // No right padding to prevent overflow constraints
                ),
                child: Image.asset(
                  'assets/rr.png',
                  fit: BoxFit.fitHeight,
                  height: 550, // Increased height
                  alignment: Alignment.centerLeft, // Left alignment within image container
                ),
              ),
            ),
          ),
          
          // Glassmorphic content card at bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Glassmorphic card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // App text logo image
                            Image.asset(
                              'assets/textlogo.png',
                              height: 60,
                            ),
                            const SizedBox(height: 16),

                            // Text content
                            const Text(
                              'Ride easy with Ryder',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Let's Go button - NOW NAVIGATES TO LOGIN PAGE
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Let\'s Go', 
                                  style: TextStyle(fontWeight: FontWeight.bold)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // "Made with love" text at the bottom
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Made with ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                          size: 14,
                        ),
                        Text(
                          ' using Flutter',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
