import 'package:businessinfoapp/Auth/ForgotPassword.dart';
import 'package:businessinfoapp/Auth/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Business/home.dart';

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
      backgroundColor: Color(0xff1C0D0D),
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
                        Material(
                          color:  Color(0xff2E1E1E),
                          borderRadius: BorderRadius.circular(20),
                          elevation: 12,
                          shadowColor:  Color(0xffD2AA89),
                          child: TextFormField(
                          controller: emailController,
                            style: TextStyle(color: Color(0xffD2B48C)),
                          cursorColor: Color(0xffD2AA89),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.alternate_email_outlined, color: Color(0xffD2B48C)),
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Color(0xffC19A6B)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff2E1E1E))
                            ),
                          ),
                                                    ),
                        ),
                        SizedBox(height: 30),
                        Material(
                          color:  Color(0xff2E1E1E),
                          borderRadius: BorderRadius.circular(20),
                          elevation: 12,
                          shadowColor:  Color(0xffD2AA89),
                          child: TextFormField(
                            obscureText: true,
                            style: TextStyle(color: Color(0xffD2B48C)),
                            controller: passwordController,
                            cursorColor: Color(0xffD2AA89),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Password";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.key_rounded,color: Color(0xffD2B48C)),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Color(0xffC19A6B)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Color(0xff2E1E1E)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Color(0xff2E1E1E)),
                              ),
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
                              style: TextStyle(color: Color(0xffD2B48C)),
                            ),
                          ),
                        ),
                         SizedBox(height: 10,),
                         Container(
                            width: 200.0,
                            height: 50,
                            child: Material(
                              color:  Color(0xffD2B48C),
                              borderRadius: BorderRadius.circular(26),
                              elevation: 12,
                              shadowColor:  Color(0xffD2AA89),
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
                                    color: Color(0xff3E2723),
                                  ),
                                ),
                                child: Text("Log in", style: TextStyle(color: Color(0xff3E2723))),
                              ),
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
                            style: TextStyle(color: Color(0xffD2B48C)),
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
