import 'package:businessinfoapp/Class/splashServices.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashscreen = SplashServices();

  @override

  void initState(){
    super.initState();
    splashscreen.isLogin(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: 200.0),
          duration: const Duration(milliseconds: 1500),
          builder: (context, size, widget) {
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffD3B08F),
                    blurRadius: size/2,
                    spreadRadius: size/4,

                )
                ],
              ),
              child: ClipOval(
                child: Image(
                    image: AssetImage('assets/logo.png')),
              ),
            );
          }
        )

      )
    );

  }
}
