
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  void login() async{
    String email=emailController.text.trim();
    String password=passwordController.text.trim();

    if(email.isEmpty||password.isEmpty){
      log("Please fill all the details");
    }
    else{
      try{
        UserCredential userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        if(userCredential.user!=null){
          // ignore: use_build_context_synchronously
          Navigator.popUntil(context, (route) => route.isFirst);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, "/homeScreen");

        }
        else{
          log("Please create user");
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
        title: const Text("Login"),
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
            const SizedBox(height: 20,),
            Center(
              child: GestureDetector(
                onTap: (){
                  login();
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue
                  ),
                  height: 40,
                  width: 100,
                  child: const Center(child: Text("Log in")),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Center(
              child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context,"/signupScreen");
                  },
                  child: const Text("Create an account",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 25),)),
            )
          ],
        ),
      ),

    );
  }
}
