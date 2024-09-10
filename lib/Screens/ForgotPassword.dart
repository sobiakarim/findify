import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.brown,
        iconTheme: IconThemeData(color: Color(0xffD3B08F)),
      ),
      backgroundColor: Colors.brown,
      body:  Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            children: [
              SizedBox(height: 40,),
              ClipOval(
                child: Image(
                    width: 100,
                    height: 100,
                    image: AssetImage('assets/logo.png')),
              ),
              SizedBox(height: 120,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

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
                      prefixIcon: Icon(Icons.alternate_email_outlined, color: Color(0xffD3B08F) ,),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Color(0xffD3B08F)),
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
                  SizedBox(height: 20,),
                  TextButton(
                      onPressed: (){
                        if (formKey.currentState!.validate()) {
                          try{
                            auth.sendPasswordResetEmail(email: emailController.text.toString());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('We have sent you an email'),
                              ),
                            );
                          }catch(e){
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
                      child: Text("Send link to reset password", style: TextStyle(color: Color(0xffD3B08F))))
                ],
              ),
            ],
          ),
        ),
      ),

      );
  }
}
