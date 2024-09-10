import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();

  User? user;
  File? _imageFile;
  String? _imageUrl;
  bool isLoading = false;
  bool isEditMode = false; // Edit mode state

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Fetch user data when the widget is initialized
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true; // Show loading indicator while fetching data
    });

    user = _auth.currentUser; // Get the current logged-in user
    if (user != null) {
      try {
        // Fetch user data from Firestore using user's UID
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>; // Cast data to Map
          setState(() {
            nameController.text = userData['username'] ?? ''; // Use 'username' field here
            cityController.text = userData['city'] ?? '';
            addressController.text = userData['address'] ?? '';
            _imageUrl = userData['imageUrl'];
            isLoading = false; // Stop loading indicator
          });
          print('User data loaded successfully.');
        } else {
          print('User document does not exist.');
          setState(() {
            isLoading = false; // Stop loading if user data does not exist
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
        setState(() {
          isLoading = false; // Stop loading indicator even if an error occurs
        });
      }
    } else {
      print('No user is logged in.');
      setState(() {
        isLoading = false; // Stop loading if no user is logged in
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery); // Open image picker
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Set the picked image file
      });
    }
  }

  Future<void> _updateUserData() async {
    setState(() {
      isLoading = true; // Show loading indicator while updating data
    });

    try {
      String? newImageUrl = _imageUrl; // Use the existing image URL if no new image is picked

      if (_imageFile != null) {
        // Upload new profile image to Firebase Storage
        final storageRef = _storage.ref().child('user_images/${user!.uid}.jpg');
        await storageRef.putFile(_imageFile!);
        newImageUrl = await storageRef.getDownloadURL(); // Get the new image URL
      }

      // Update user data in Firestore
      await _firestore.collection('users').doc(user!.uid).update({
        'username': nameController.text.trim(),
        'city': cityController.text.trim(),
        'address': addressController.text.trim(),
        'imageUrl': newImageUrl ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      setState(() {
        isEditMode = false; // Exit edit mode after saving
      });
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }

    setState(() {
      isLoading = false; // Stop loading indicator after updating
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: const Text('User Profile', style: TextStyle(color: Color(0xffD3B08F)),),
        backgroundColor: Colors.brown[700],
        iconTheme: IconThemeData(color: Color(0xffD3B08F)),
      ),
      body: isLoading // Show loading indicator if loading is true
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: isEditMode ? _pickImage : null, // Pick a new image on tap only in edit mode
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!) // Display selected image
                      : (_imageUrl != null ? NetworkImage(_imageUrl!) : null) as ImageProvider?,
                  child: _imageFile == null && _imageUrl == null
                      ? const Icon(Icons.add_a_photo, size: 50) // Default icon if no image is set
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(nameController, 'Name', Icons.person, enabled: isEditMode),
              const SizedBox(height: 20),
              _buildTextField(cityController, 'City', Icons.location_city, enabled: isEditMode),
              const SizedBox(height: 20),
              _buildTextField(addressController, 'Address', Icons.maps_home_work_outlined, enabled: isEditMode),
              const SizedBox(height: 20),
              isEditMode
                  ? ElevatedButton(
                onPressed: _updateUserData, // Update user data on button press
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700],
                ),
                child: const Text('Save Changes', style: TextStyle(color: Color(0xffD3B08F)),),
              )
                  : ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditMode = true; // Enable edit mode
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700],
                ),
                child: const Text('Make Changes', style: TextStyle(color: Color(0xffD3B08F)),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build text fields with specific properties
  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, {bool enabled = true}) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.white,
      enabled: enabled, // Control whether the text field is enabled or not
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xffD3B08F) ,),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xffD3B08F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xffD3B08F)),
        ),
      ),
      style: TextStyle(color: Colors.black),
    );
  }
}
