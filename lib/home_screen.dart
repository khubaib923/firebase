// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screen/email_auth/login_screen.dart';
import 'package:flutter_firebase/screen/phone_auth/sign_in_with_phone.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController=TextEditingController();
  File? profilePic;

  void saveData() async {


    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String ageString=ageController.text.trim();

    int age=int.parse(ageString);


    nameController.clear();
    emailController.clear();
    ageController.clear();
    if (name.isEmpty || email.isEmpty || ageString.isEmpty || profilePic == null) {
      log("Please fill the details");



    }
    else {
     UploadTask uploadTask= FirebaseStorage.instance.ref().child("profilePic").child(const Uuid().v1()).putFile(profilePic!);
     StreamSubscription streamSubscription=uploadTask.snapshotEvents.listen((snapshot) {
       double percentage=(snapshot.bytesTransferred/snapshot.totalBytes)*100;
       log(percentage.toString());
     });
     TaskSnapshot taskSnapshot=await uploadTask;
     final downloadUrl=await taskSnapshot.ref.getDownloadURL();
     streamSubscription.cancel();
      Map<String, dynamic> newUser = {
        "name": name,
        "email": email,
        "age":age,
        "profilePic":downloadUrl,
        "sampleArray":[name,email,age]
      };

      await FirebaseFirestore.instance.collection("users").add(newUser);
      log("user created");
    }
   setState((){
     profilePic=null;
   });
  }

 void logOut()async{
   await FirebaseAuth.instance.signOut();

   Navigator.popUntil(context, (route) => route.isFirst);

   Navigator.pushReplacementNamed(context, "/");

 }
 Future<void> getInitialMessage() async{
   RemoteMessage? message=await FirebaseMessaging.instance.getInitialMessage();

   if(message!=null){
     if(message.data["page"]=="email"){
   Navigator.push(context,MaterialPageRoute(builder: (context)=>const LoginScreen()));
     }
     else if(message.data["page"]=="phone"){


       Navigator.push(context,MaterialPageRoute(builder: (_)=>const SignInWithPhone()));
     }
     else{
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Invalid page"),duration: Duration(seconds: 2),backgroundColor: Colors.red, ));
     }
   }
 }

 @override
  void initState(){
    super.initState();
    getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      // log("message received ${event.notification!.title}");
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("message received ${event.data["name"]}"),duration: const Duration(seconds: 2),backgroundColor: Colors.green, ));


    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("App was opened by a notification"),duration: Duration(seconds: 2),backgroundColor: Colors.red, ));

    });

 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            GestureDetector(
                onTap: () {
                  logOut();
                },
                child: const Icon(Icons.logout)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                splashColor: Colors.blue,
                onTap: () async{
                  ImagePicker picker=ImagePicker();
                  XFile? selectedImage=await picker.pickImage(source: ImageSource.gallery).timeout(const Duration(seconds: 5),onTimeout: (){
                    log("time extend out");
                  });

                  if(selectedImage!=null){
                    File convertedFile=File(selectedImage.path);
                    setState((){
                      profilePic=convertedFile;
                    });
                    log("Image selected");
                  }
                  else{
                    log("Image is not selected");
                  }
                },
                child:  CircleAvatar(
                  radius: 40,
                 backgroundImage: profilePic!=null?FileImage(profilePic!):null,
                 // backgroundColor: Colors.pink,

                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                ),
              ),
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
                  controller: ageController,
                  decoration: const InputDecoration(
                    hintText: "Age",
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    saveData();
                  },
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.blue),
                    height: 40,
                    width: 100,
                    child: const Center(child: Text("Save")),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.requireData.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> userMap =
                                  snapshot.requireData.docs[index].data()
                                      as Map<String, dynamic>;

                              return ListTile(

                                title: Text(userMap["name"] + " (${(userMap["age"])}) "),
                                subtitle: Text(userMap["email"]),
                                // leading: IconButton(
                                //   icon: const Icon(
                                //     Icons.update,
                                //     size: 30,
                                //     color: Colors.red,
                                //   ),
                                //   onPressed: () async {
                                //     nameController.text=snapshot.requireData.docs[index]["name"];
                                //     emailController.text=snapshot.requireData.docs[index]["email"];
                                //
                                //
                                //     await FirebaseFirestore.instance
                                //         .collection("users")
                                //         .doc(
                                //             snapshot.requireData.docs[index].id)
                                //         .update({
                                //       "name":nameController.text ,
                                //       "email":emailController.text ,
                                //     });
                                //   },
                                // ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(userMap["profilePic"]),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(
                                            snapshot.requireData.docs[index].id)
                                        .delete();
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return const Text("No data");
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}
