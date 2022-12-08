import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyOtp extends StatefulWidget {
  final String? verificationId;
  const VerifyOtp({Key? key,this.verificationId}) : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  TextEditingController otpController=TextEditingController();

  void verifyOtp() async{
    String otp=otpController.text.trim();
    if(otp.isEmpty){
      log("Please fill the details");
    }
    else{
      try{
        PhoneAuthCredential credential=PhoneAuthProvider.credential(verificationId:widget.verificationId.toString(), smsCode: otp);

        UserCredential userCredential=await FirebaseAuth.instance.signInWithCredential(credential);
        if(userCredential.user!=null){
          // ignore: use_build_context_synchronously
          Navigator.popUntil(context, (route) => route.isFirst);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, "/homeScreen");
        }
        else{
          log("please again user created");
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
        title: const Text("Verify OTP"),
        centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: otpController,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: "6-Digit OTP",
                  counterText: "",
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Center(
              child: GestureDetector(
                onTap: (){
              verifyOtp();
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.blue
                  ),
                  height: 40,
                  width: 100,
                  child: const Center(child: Text("Verify")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

