import 'dart:io';

import 'package:businessinfoapp/Auth/Login.dart';
import 'package:businessinfoapp/Business/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> loginAnimation;

  File? image;

  // Method to pick an image using ImagePicker
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
        // Provide feedback that image is selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selected successfully!')),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;




  // Method to upload the image to Firebase Storage
  Future<String?> _uploadImage(User user) async {
    try {
      if (image != null) {
        // Create a reference to the location you want to upload to in Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('user_images/${user.uid}.jpg');

        // Start the file upload
        UploadTask uploadTask = storageRef.putFile(image!);

        // Wait for the upload to complete and get the download URL
        TaskSnapshot completedTask = await uploadTask;
        String downloadUrl = await completedTask.ref.getDownloadURL();
        return downloadUrl;  // Return the download URL after upload is successful
      } else {
        return null;  // No image was selected
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;  // Return null if an error occurs
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2500));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward(from: 0); // Start animation when the screen is visible
    });
    slideAnimation = Tween(begin: Offset(-1, -1), end: Offset.zero).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Curves.ease)
    );

    scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Curves.ease)
    );

    loginAnimation  =Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: animationController, curve: Curves.ease));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1C0D0D),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: SlideTransition(
              position: slideAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor:  Color(0xff2E1E1E),
                              backgroundImage: image != null ? FileImage(image!) : null,
                              child: image == null
                                  ? const Icon(Icons.add_a_photo, size: 50, color: Color(0xffD2B48C),)
                                  : null,
                            ),
                            Text("Add Profile Picture", style: TextStyle(color: Color(0xffC19A6B),),)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Material(
                      color:  Color(0xff2E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      elevation: 12,
                      shadowColor:  Color(0xffD2AA89),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        style: TextStyle(color: Color(0xffD2B48C)),
                        cursorColor: Color(0xffD2AA89),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email_outlined,color:  Color(0xffD2B48C)),
                          hintText: "Email",
                          hintStyle: TextStyle(color: Color(0xffC19A6B)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E),)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E),)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Material(
                      color:  Color(0xff2E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      elevation: 12,
                      shadowColor:  Color(0xffD2AA89),
                      child: TextFormField(
                        controller: nameController,
                        style: TextStyle(color: Color(0xffD2B48C)),
                        cursorColor: Color(0xffD2AA89),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person,  color: Color(0xffD2B48C),),
                          hintText: "Name",
                          hintStyle: TextStyle(color: Color(0xffC19A6B)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E),)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E),)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Material(
                      color:  Color(0xff2E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      elevation: 12,
                      shadowColor:  Color(0xffD2AA89),
                      child: TextFormField(
                        controller: passwordController,
                        style: TextStyle(color: Color(0xffD2B48C)),
                        cursorColor: Color(0xffD2AA89),
                        obscureText: true, // Hide password input
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key_rounded, color:  Color(0xffD2B48C),),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Color(0xffC19A6B)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E),)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E),)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Material(
                      color: Color(0xff2E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      elevation: 12,
                      shadowColor:  Color(0xffD2AA89),
                      child: TextFormField(
                        controller: confirmPasswordController,
                        style: TextStyle(color: Color(0xffD2B48C)),
                        cursorColor: Color(0xffD2AA89),
                        obscureText: true, // Hide password input
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Confirm Password";
                          } else if (value != passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key_rounded, color:  Color(0xffD2B48C),),
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(color: Color(0xffC19A6B)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E),)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color:Color(0xff2E1E1E),)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Material(
                      color:  Color(0xff2E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      elevation: 12,
                      shadowColor:  Color(0xffD2AA89),
                      child: TextFormField(
                        controller: cityController,
                        style: TextStyle(color: Color(0xffD2B48C)),
                        cursorColor: Color(0xffD2AA89),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter City";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_city, color: Color(0xffD2B48C),),
                          hintText: "City",
                          hintStyle: TextStyle(color: Color(0xffC19A6B)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E),)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E),)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Material(
                      color: Color(0xff2E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      elevation: 12,
                      shadowColor:  Color(0xffD2AA89),
                      child: TextFormField(
                        controller: addressController,
                        style: TextStyle(color: Color(0xffD2B48C)),
                        cursorColor: Color(0xffD2AA89),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Address";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.maps_home_work_outlined, color:  Color(0xffD2B48C),),
                          hintText: "Address",
                          hintStyle: TextStyle(color: Color(0xffC19A6B)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E),)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E),)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ScaleTransition(
                      scale: loginAnimation,
                      child: Container(
                        width: 200.0,
                        height: 50,
                        child: Material(
                          color:  Color(0xffD2B48C),
                          borderRadius: BorderRadius.circular(24),
                          elevation: 12,
                          shadowColor:  Color(0xffD2AA89),
                          child: TextButton(
                            onPressed: () async {
                              animationController.forward();
                              if (formKey.currentState!.validate()) {
                                try {
                                  // Create user with email and password
                                  UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );

                                  // Upload image and get URL
                                  String? imageUrl = await _uploadImage(userCredential.user!);

                                  // Store additional user information (like username, city, address) in Firestore
                                  await _firestore.collection('users').doc(userCredential.user?.uid).set({
                                    'username': nameController.text.trim(),
                                    'email': emailController.text.trim(),
                                    'city': cityController.text.trim(),
                                    'address': addressController.text.trim(),
                                    'imageUrl': imageUrl ?? '',  // Save image URL, if available
                                  });

                                  // Navigate to home screen after successful registration
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeScreen()),
                                  );
                                } catch (e) {
                                  // Handle errors (e.g., show a snackbar or dialog)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                    ),
                                  );
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                              side: BorderSide(color:  Color(0xff3E2723)),
                            ),
                            child: Text("Sign Up", style: TextStyle(color: Color(0xff3E2723),)),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        animationController.forward();
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => Login()));
                      },

                      child: Text(
                        "Already have an account?" ,
                        style: TextStyle(color: Color(0xffD2B48C),
                      ),
                    ),
                    )],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
