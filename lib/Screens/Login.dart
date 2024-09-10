import 'package:businessinfoapp/Screens/ForgotPassword.dart';
import 'package:businessinfoapp/Screens/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  late Animation<double> logoFadeAnimation;
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> loginAnimation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2500));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward(from: 0); // Start animation when the screen is visible
    });

    logoFadeAnimation = Tween<double>(begin: 0, end: 1).animate(animationController);
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

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: logoFadeAnimation,
              child: ClipOval(
                child: Image(
                    width: 100,
                    height: 100,
                    image: AssetImage('assets/logo.png')),
              ),
            ),
            Padding(
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
                        SizedBox(height: 40,),
                        TextFormField(
                          controller: emailController,
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.alternate_email_outlined, color: Color(0xffD3B08F)),
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Color(0xffD3B08F)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xffD3B08F)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xffD3B08F))
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          cursorColor: Colors.white,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.key_rounded,color: Color(0xffD3B08F)),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                color: Color(0xffD3B08F)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xffD3B08F)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xffD3B08F)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Forgotpassword()),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Color(0xffD3B08F)),
                            ),
                          ),
                        ),
                         Container(
                            width: 200.0,
                            child: TextButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  try {
                                    // Sign in user with email and password
                                    await auth.signInWithEmailAndPassword(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    );

                                    // Navigate to home screen if login is successful
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeScreen()),
                                 );
                                  } catch (e) {
                                    // Show error message if login fails
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: ${e.toString()}'),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                  color: Color(0xffD3B08F),
                                ),
                              ),
                              child: Text("Log in", style: TextStyle(color: Color(0xffD3B08F))),
                            ),
                          ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
                            );
                          },
                          child: Text(
                            "Don't have an account?",
                            style: TextStyle(color: Color(0xffD3B08F)),
                          ),
                        ),
                      ],
                    ),
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
