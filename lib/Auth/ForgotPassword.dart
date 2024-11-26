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
        backgroundColor: Color(0xff1C0D0D),
        iconTheme: IconThemeData(color: Color(0xffD3B08F)),
      ),
      backgroundColor: Color(0xff1C0D0D),
      body:  Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            children: [
              SizedBox(height: 160,),

              Text("Forgot Password?", style: TextStyle(color: Color(0xffD2B48C), fontSize: 26, fontWeight: FontWeight.w800),),
              SizedBox(height: 40),
              Text("Enter email to get link for reseting password", style: TextStyle(color: Color(0xffD2B48C)),),
              SizedBox(height: 40,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Material(
                    color:  Color(0xff2E1E1E),
                    borderRadius: BorderRadius.circular(20),
                    elevation: 12,
                    shadowColor:  Color(0xffD2AA89),
                    child: TextFormField(
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
                        hintStyle: TextStyle(color: Color(0xffC19A6B)),
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
                  ),
                  SizedBox(height: 40,),
                  Container(
                    width: 100,
                    height: 50,
                    child: Material(
                      color:  Color(0xffD2B48C),
                      borderRadius: BorderRadius.circular(26),
                      elevation: 12,
                      shadowColor:  Color(0xffD2AA89),
                      child: TextButton(
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
                              color: Color(0xff3E2723),
                            ),
                          ),
                          child: Text(
                              "Send Link",
                              style: TextStyle(
                                  color: Color(0xff3E2723)
                              )
                          )
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),

      );
  }
}
