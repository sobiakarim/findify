import 'package:businessinfoapp/Screens/AddBusiness.dart';
import 'package:businessinfoapp/Screens/Login.dart';
import 'package:businessinfoapp/Screens/Search.dart';
import 'package:businessinfoapp/Screens/userProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Category.dart';

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
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown[700],
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTile('assets/food.jpg', 'Food', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryScreen(category: 'Food'),
              ),
            );
          }),
          _buildTile('assets/healthcare.jpg', 'Healthcare', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryScreen(category: 'Healthcare'),
              ),
            );
          }),
          _buildTile('assets/hotels.jpg', 'Hotels', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryScreen(category: 'Hotels'),
              ),
            );
          }),
          _buildTile('assets/education.jpg', 'Education', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryScreen(category: 'Education'),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Method to build a large tile with an image and label
  Widget _buildTile(String imagePath, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0), // Space between tiles
        decoration: BoxDecoration(
          color: Colors.white,  // Background color for the tile container
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                imagePath,
                height: 300, // Set height for the image to make the tile bigger
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: Color(0xffD3B08F), // Set background color for text area
              width: double.infinity, // Make the background color take full width
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
