import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screen/phone_auth/verify_otp.dart';

class SignInWithPhone extends StatefulWidget {
  const SignInWithPhone({Key? key}) : super(key: key);

  @override
  State<SignInWithPhone> createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  TextEditingController phoneController = TextEditingController();

void createOtp() async{
  String phoneNumber="+92${phoneController.text.trim()}";
    try{
    await FirebaseAuth.instance.verifyPhoneNumber
        (phoneNumber:phoneNumber,

        codeSent: (verificationId,responseToken){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyOtp(verificationId: verificationId,)));
        },
        verificationCompleted: (credintial){},
        verificationFailed: (e){
          log(e.code.toString());
        },
      codeAutoRetrievalTimeout: (verificationId){},
        timeout: const Duration(seconds: 30),

      );
    }
    on FirebaseAuthException catch(e){
      log(e.code.toString());
    }

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in with Phone"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: "Phone Number",
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                 createOtp();
                },
                child: Container(
                  decoration: const BoxDecoration(color: Colors.blue),
                  height: 40,
                  width: 100,
                  child: const Center(child: Text("Sign in")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
