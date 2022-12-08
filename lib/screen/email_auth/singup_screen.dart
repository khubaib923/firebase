import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();

  void createAccount() async{
    String email=emailController.text.trim();
    String password=passwordController.text.trim();
    String confirmPassword=confirmPasswordController.text.trim();

    if(email.isEmpty||password.isEmpty||confirmPassword.isEmpty){
      log("Please fill all the details");
    }
    else if(password!=confirmPassword){
      log("Please enter same password");
    }
    else{
    try{
      UserCredential userCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if(userCredential.user!=null){
        // ignore: use_build_context_synchronously
        Navigator.pop(context);

      }
      else{
        log("please again create user");
      }

    }
    on FirebaseAuthException catch(e){
      log(e.code.toString());
    }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create an account"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email Address",

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: "Password",

                ),
              ),

            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  hintText: "Confirm Password",

                ),
              ),

            ),
            const SizedBox(height: 20,),
            Center(
              child: GestureDetector(
                onTap: (){
                  createAccount();
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.blue
                  ),
                  height: 40,
                  width: 200,
                  child: const Center(child: Text("Create Account")),
                ),
              ),
            ),


          ],
        ),
      ),

    );
  }
}
