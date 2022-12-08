import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:flutter_firebase/home_screen.dart';
import 'package:flutter_firebase/screen/email_auth/login_screen.dart';
import 'package:flutter_firebase/screen/email_auth/singup_screen.dart';
import 'package:flutter_firebase/screen/phone_auth/sign_in_with_phone.dart';
import 'package:flutter_firebase/screen/phone_auth/verify_otp.dart';
import 'package:flutter_firebase/services/notification_services.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  await NotificationServices.initialize();







 //DocumentSnapshot snapshot=await FirebaseFirestore.instance.collection("users").doc("uMohWykbEJ09uJun9E1E").get();

 //log(snapshot.docs.toString());
  //log(snapshot.data().toString());
  // Map<String,dynamic> user1={
  //   "email":"khubaibirfan200@gmail.com",
  //   "name":"Khubaib Ameen"
  //
  // };
  // //await FirebaseFirestore.instance.collection("users").add(user1);
  // //await FirebaseFirestore.instance.collection("users").doc("1234567890").set(user1);
  // // await FirebaseFirestore.instance.collection("users").doc("1234567890").update({
  // //   "email":"altafhussain@gmail.com"
  // // });
  // //await FirebaseFirestore.instance.collection("users").doc("1234567890").delete();
  // log("user added");
  
// QuerySnapshot snapshot=await FirebaseFirestore.instance.collection("users").get();
//  DocumentSnapshot documentSnapshot=await FirebaseFirestore.instance.collection("users").doc("OSEugoPZTTa8kLZuokFF").get();
//  log(documentSnapshot.data().toString());
//   for(var value in snapshot.docs){
//     log(value.data().toString());
//   }
//
 Map<String,dynamic>newUser={
   "name":"khubaibameen",
   "age":24,

 };
//
// DocumentReference reference= await FirebaseFirestore.instance.collection("users").add(newUser);
// await FirebaseFirestore.instance.collection("users").doc("OSEugoPZTTa8kLZuokFF").update({
//   "name":"Altaf Hussain",
//   "age":65
// });
//
//  await FirebaseFirestore.instance.collection("users").doc("OSEugoPZTTa8kLZuokFF").delete();

 //await FirebaseFirestore.instance.collection("users").doc("474757555775").set(newUser);



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser != null ? "/homeScreen" :"/",
      routes: {
        "/":(context)=>const LoginScreen(),
        "/signupScreen":(context)=>const SignupScreen(),
        "/homeScreen":(context)=>const HomeScreen(),
        "/signInWithPhone":(context)=>const SignInWithPhone(),
        "/verifyOtp":(context)=> const VerifyOtp(),
      },
    );
  }
}
