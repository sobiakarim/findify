import 'package:businessinfoapp/Self/AddBusiness.dart';
import 'package:businessinfoapp/Auth/Login.dart';
import 'package:businessinfoapp/Business/Search.dart';
import 'package:businessinfoapp/Self/userProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'categoryDetails.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout Confirmation"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                // Perform logout operation
                final auth = FirebaseAuth.instance;
                auth.signOut();

                // Navigate to Login screen after sign-out
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final categories = [
      {'image': 'assets/food.jpg', 'title': 'Food'},
      {'image': 'assets/healthcare.jpg', 'title': 'Healthcare'},
      {'image': 'assets/hotels.jpg', 'title': 'Hotels'},
      {'image': 'assets/education.jpg', 'title': 'Education'},
    ];

    return Scaffold(
      backgroundColor: Color(0xff1C0D0D),
      appBar: AppBar(
        backgroundColor: Color(0xff1C0D0D),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Color(0xffD3B08F)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SearchScreen()));
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddBusinessScreen()));
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UserProfile()));
            },
            icon: Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60,),
            Text("Choose Category", style: TextStyle(color: Color(0xffD2B48C), fontSize: 20, fontWeight: FontWeight.w800),),
            SizedBox(height: 80,),
            SizedBox(
              height: 313,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.8), // ViewportFraction to show part of adjacent pages
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _build3DTile(categories[index]['image']!, categories[index]['title']!, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(category: categories[index]['title']!),
                      ),
                    );
                  }, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build a tile with a 3D effect
  Widget _build3DTile(String imagePath, String title, VoidCallback onTap, int index) {
    return AnimatedBuilder(
      animation: PageController(viewportFraction: 0.8), // Track the scroll position
      builder: (context, child) {
        double scale = 1.0;
        final PageController controller = PageController(viewportFraction: 0.8);
        if (controller.hasClients) {
          final position = controller.page!;
          scale = (1 - ((position - index).abs() * 0.2)).clamp(0.8, 1.0);
        }

        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                color: Color(0xffD2B48C)  ,// Background color for the tile container
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffD2B48C) ,
                    blurRadius: 8.0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      imagePath,
                      height: 250, // Set height for the image to make the tile bigger
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: Color(0xffD2B48C) , // Set background color for text area
                    width: double.infinity, // Make the background color take full width
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3E2723),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
