import 'package:businessinfoapp/Screens/AddBusiness.dart';
import 'package:businessinfoapp/Screens/BusinessDetail.dart';
import 'package:businessinfoapp/Screens/Category.dart';
import 'package:businessinfoapp/Screens/Search.dart';
import 'package:businessinfoapp/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Findify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
