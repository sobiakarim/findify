import 'package:businessinfoapp/Main/splashServices.dart';
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
      backgroundColor: Color(0xff1C0D0D),
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
                color: Color(0xff2E1E1E),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffD2AA89),
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
