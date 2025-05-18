// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

import 'dart:ui';
import 'package:car_rental_app/presentation/pages/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  String userName = '';
  String email = '';
  final TextEditingController nameController = TextEditingController();
  String? profileImageUrl;
  bool isUploadingImage = false;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      if (user != null) {
        // Try to load from SharedPreferences first
        final prefs = await SharedPreferences.getInstance();
        final localImagePath = prefs.getString('profile_image_path');
        
        if (localImagePath != null && File(localImagePath).existsSync()) {
          setState(() {
            profileImageUrl = 'file://$localImagePath';
          });
        }
        
        // Still get user data from Firestore for name and email
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        
        final data = userData.data();

        if (data != null) {
          setState(() {
            userName = data['name'] ?? 'User';
            nameController.text = userName;
            email = data['email'] ?? user!.email ?? 'No email';
            
            // Only update image from Firestore if we don't have a local one
            if (profileImageUrl == null) {
              final firestoreImgUrl = data['profileImageUrl'];
              if (firestoreImgUrl != null && firestoreImgUrl.startsWith('local:')) {
                // This is a local file reference from Firestore
                final localPath = firestoreImgUrl.substring(6); // Remove 'local:' prefix
                if (File(localPath).existsSync()) {
                  profileImageUrl = 'file://$localPath';
                }
              } else if (firestoreImgUrl != null) {
                // This is a regular URL
                profileImageUrl = firestoreImgUrl;
              }
            }
            
            isLoading = false;
          });
        } else {
          setState(() {
            userName = 'User';
            email = user!.email ?? 'No email';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error getting user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'name': newName});
        
        setState(() {
          userName = newName;
        });
      }
    } catch (e) {
      print('Error updating user name: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // ignore: duplicate_ignore
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
        (route) => false,
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Navigate to account settings
  void navigateToAccountSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          height: 150, // Reduced height since we have fewer fields now
          child: Column(
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Update name in Firestore and update UI
                  updateUserName(nameController.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigate to help and support
  void navigateToHelpAndSupport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _supportOption(
              icon: Icons.email,
              title: 'Email Support',
              onTap: () async {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'nikhilpareekpandit@gmail.com',
                  query: 'subject=Support Request for Ryder&body=Hello, I need assistance with...',
                );
                
                if (await canLaunchUrl(emailUri)) {
                  await launchUrl(emailUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch email client')),
                  );
                }
                Navigator.pop(context);
              },
            ),
            _supportOption(
              icon: Icons.phone,
              title: 'Call Support',
              onTap: () async {
                final Uri phoneUri = Uri(scheme: 'tel', path: '+1234567890');
                
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not make a call')),
                  );
                }
                Navigator.pop(context);
              },
            ),
            _supportOption(
              icon: Icons.chat_bubble_outline,
              title: 'Live Chat',
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF1E1E1E),
                    title: const Text(
                      'Live Chat',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      'Live chat support is coming soon!',
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _supportOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  // Navigate to about us
  void navigateToAboutUs() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xff2C2B34),
          appBar: AppBar(
            title: const Text('About Us'),
            backgroundColor: const Color(0xFF1E1E1E),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/textlogo.png',
                  height: 60,
                ),
                const SizedBox(height: 24),
                const Text(
                  'The future of car rental',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ryder is a premium car rental service that offers a seamless and luxurious experience for our customers. Our mission is to provide high-quality vehicles with exceptional service at affordable prices.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white24),
                const SizedBox(height: 24),
                const Text(
                  'Our Vision',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'To revolutionize the car rental industry by offering premium vehicles with cutting-edge technology and exceptional customer service.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                
                // Add developer information in frosted glass container
                const SizedBox(height: 40),
                const Text(
                  'Development Team',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // First developer (existing one)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          // Developer image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/nik.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback if image doesn't load
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.withOpacity(0.3),
                                  child: const Icon(Icons.person, color: Colors.white, size: 40),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Developer name and social links
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Nikhil Pareek',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // Social media links
                                Row(
                                  children: [
                                    // GitHub link
                                    GestureDetector(
                                      onTap: () async {
                                        final Uri url = Uri.parse('https://github.com/nikkhilpareek');
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url, mode: LaunchMode.externalApplication);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(
                                          'assets/github.png',
                                          width: 24,
                                          height: 24,
                                          
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    
                                    // LinkedIn link
                                    GestureDetector(
                                      onTap: () async {
                                        final Uri url = Uri.parse('https://www.linkedin.com/in/nikkhil-pareek');
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url, mode: LaunchMode.externalApplication);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(
                                          'assets/linkedin.webp',
                                          width: 24,
                                          height: 24,
                                          
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    
                                    // Instagram link
                                    GestureDetector(
                                      onTap: () async {
                                        final Uri url = Uri.parse('https://www.instagram.com/nikkhil.pareek');
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url, mode: LaunchMode.externalApplication);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(
                                          'assets/ig.webp',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Add spacing between developers
                const SizedBox(height: 16),
                
                // Second developer (updated for Deepak)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          // Developer image - using Deepak's image from assets
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/deepak.jpeg', // Use Deepak's image from assets
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback if image doesn't load
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.deepPurple.withOpacity(0.3),
                                  child: const Icon(Icons.person, color: Colors.white, size: 40),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Developer name and social links
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Deepak Vishwakarma', // Updated name
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // Social media links
                                Row(
                                  children: [
                                    // GitHub link
                                    GestureDetector(
                                      onTap: () async {
                                        // Replace with Deepak's actual GitHub URL
                                        final Uri url = Uri.parse('https://github.com/deepak-vm');
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url, mode: LaunchMode.externalApplication);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(
                                          'assets/github.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    
                                    // LinkedIn link
                                    GestureDetector(
                                      onTap: () async {
                                        // Replace with Deepak's actual LinkedIn URL
                                        final Uri url = Uri.parse('https://www.linkedin.com/in/deepakvi18');
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url, mode: LaunchMode.externalApplication);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(
                                          'assets/linkedin.webp',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    
                                    // Instagram link
                                    GestureDetector(
                                      onTap: () async {
                                        // Replace with Deepak's actual Instagram URL
                                        final Uri url = Uri.parse('https://www.instagram.com/vdeepak_');
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url, mode: LaunchMode.externalApplication);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(
                                          'assets/ig.webp',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Add spacing between developers
                const SizedBox(height: 16),
                
                // Third developer (updated for Riyansh)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          // Developer image - using Riyansh's image from assets
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/riyansh.png', // Use Riyansh's image from assets
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback if image doesn't load
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.blue.withOpacity(0.3),
                                  child: const Icon(Icons.person, color: Colors.white, size: 40),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Developer name and social links
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Riyansh Verma', // Updated name
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // Social media links
                                Row(
                                  children: [
                                    // Instagram link only
                                    GestureDetector(
                                      onTap: () async {
                                        // Replace with Riyansh's actual Instagram URL
                                        final Uri url = Uri.parse('https://www.github.com/riyanshverma');
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url, mode: LaunchMode.externalApplication);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(
                                          'assets/github.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
  );}

  Future<void> pickAndUploadImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      
      if (pickedFile == null) return;
      
      setState(() {
        isUploadingImage = true;
      });
      
      // Get local app directory for storing files
      final appDir = await getApplicationDocumentsDirectory();
      
      // Use a timestamp to ensure uniqueness and prevent caching issues
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'profile_${user!.uid}_$timestamp.jpg';
      final savedImage = File('${appDir.path}/$fileName');
      
      // Delete any existing profile images for this user
      final directory = Directory(appDir.path);
      await for (var entity in directory.list()) {
        if (entity is File && 
            path.basename(entity.path).startsWith('profile_${user!.uid}')) {
          try {
            await entity.delete();
          } catch (e) {
            print('Error deleting old profile image: $e');
          }
        }
      }
      
      // Copy the picked image to our app directory
      await File(pickedFile.path).copy(savedImage.path);
      
      // Store the path in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', savedImage.path);
      
      // Also update in Firestore just the reference (not the actual image)
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
    
        if (userDoc.exists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .update({
            'profileImageUrl': 'local:${savedImage.path}',
            'profileImageUpdatedAt': timestamp, // Add timestamp to track updates
          });
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .set({
            'name': userName,
            'email': email,
            'profileImageUrl': 'local:${savedImage.path}',
            'profileImageUpdatedAt': timestamp, // Add timestamp to track updates
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      } catch (e) {
        // If Firestore update fails, we still have the local image
        print('Firestore update failed, but image saved locally: $e');
      }
      
      // Use a cache-busting parameter with the file path to avoid image caching
      setState(() {
        // Add the timestamp as a cache busting parameter
        profileImageUrl = 'file://${savedImage.path}?t=$timestamp';
        isUploadingImage = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        isUploadingImage = false;
      });
      print('Error picking/saving image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile picture: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text('Gallery', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
                pickAndUploadImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text('Camera', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
                pickAndUploadImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C2B34),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // New horizontal layout for profile info
                    Row(
                      children: [
                        // User avatar on left
                        GestureDetector(
                          onTap: _showImageSourceActionSheet,
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white10,
                                  border: Border.all(
                                    color: Colors.white30,
                                    width: 2,
                                  ),
                                  image: profileImageUrl != null
                                      ? DecorationImage(
                                          image: profileImageUrl!.startsWith('file://')
                                              ? FileImage(File(profileImageUrl!.split('?').first.substring(7))) // Remove 'file://' prefix and any query params
                                              : NetworkImage(profileImageUrl!) as ImageProvider,
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: isUploadingImage 
                                    ? const CircularProgressIndicator()
                                    : profileImageUrl == null
                                        ? const Center(
                                            child: Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                              ),
                              if (isUploadingImage)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xff2C2B34), width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 20),
                        
                        // Name and email on right
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Menu items - removed booking history and favorite cars
                    buildMenuItem(
                      icon: Icons.settings,
                      title: 'Account Settings',
                      onTap: navigateToAccountSettings,
                    ),

                    buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: navigateToHelpAndSupport,
                    ),

                    buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'About Us',
                      onTap: navigateToAboutUs,
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 16),

                    // Sign out button
                    GestureDetector(
                      onTap: signOut,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.redAccent.withOpacity(0.2),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.redAccent,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Sign Out',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // App version at bottom
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}