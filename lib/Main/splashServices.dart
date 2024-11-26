import 'dart:async';
import 'package:businessinfoapp/Auth/Login.dart';
import 'package:businessinfoapp/Business/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices{

  void isLogin(BuildContext context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user!=null){
      Timer(
          const Duration(seconds: 3),
              ()=>Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=>HomeScreen()
                  )
              )
      );
    }
    else{
      Timer(
          const Duration(seconds: 3),
              ()=>Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=>Login()
                  )
              )
      );
    }
  }
}