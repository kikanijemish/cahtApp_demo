import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_1/model/user_model.dart';
import 'package:task_1/model/vehicle_model.dart';
import 'package:task_1/ui/const/long_button_const.dart';
import 'package:task_1/ui/const/teaxt_form_field_const.dart';
import 'package:task_1/ui/screen/alert_page/home_page/home_page.dart';
import 'package:task_1/ui/screen/auth_page/sign_up_page.dart';
import 'package:task_1/ui/utils/app_color.dart';
import 'package:task_1/ui/utils/text_const.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  FirebaseAuth auth=FirebaseAuth.instance;
  User?user;
  UserCredential? userCredential;
  String? uid;

  loginMethod(email,password)async{
    try{
      auth.signInWithEmailAndPassword(email: email, password: password);
      user=auth.currentUser;

    }on FirebaseAuthException catch(e){
      log(" Exception ${e.toString()}");
    }

    if(userCredential!=null){
      uid=userCredential!.user!.uid;
      DocumentSnapshot userData=await FirebaseFirestore.instance.collection("User").doc(uid).get();
      UserModel userModel=UserModel.fromMap(userData.data() as Map<String,dynamic>);
      

      // String key=user!.uid;
      // VehicleNameModel vehicleNameModel=VehicleNameModel(name: "",vid: key);
      // log("auth key are $key");
      // log("auth kew from the model  are ${vehicleNameModel.vid}");


    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().orangeCode,
        title: textMedium(text: "Login", fontSize: 16),
        centerTitle: true,
      ),
      body: bodyData(),
    );
  }
  Widget bodyData( ){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          formData(),
          loginButtonConst(),
          dontHaveAnAccount()
        ],
      ),
    );
  }
  Widget formData(){
    return Column(
      children: [
        TextFormFieldLabelConst(label: "Email",controller: emailController,hintText: "Enter Email",),
        TextFormFieldLabelConst(label: "Password",controller: passwordController,hintText: "Enter Password",),

      ],
    );
  }
  Widget loginButtonConst(){
    return LongButtonConst(
      topPadding: 40,
      colors: AppColors().orangeCode,
      child: textBold(text: "Login", fontSize:14,topPadding: 0),
        onTap: (){
          if(emailController.text.trim()==""){
            Get.snackbar("Hey","Enter the email");

          }else if(passwordController.text.trim()==""){
            Get.snackbar("Hey","Enter the Password");


          }else{

            islLogin();
          }}
    );
  }
  Widget dontHaveAnAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textMedium(text: "Don't Have an Account?", fontSize: 14,rightPadding: 5),
        InkWell(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) {
              return const SignUpPage();
            },));
          },
            child: textMedium(text: "sign UP", fontSize: 14,leftPadding: 0,fontColor: AppColors().orangeCode),),
      ],
    );
  }

  void islLogin() {
    // AlertBox().loadingBox(context, "Loading....!");

    auth
        .signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString())
        .then((value) async {
      // AlertBox().getSnackBarr("", value.user!.email.toString());

      if (auth != null) {
        String uid = auth.currentUser!.uid;
        User firebaseUser = auth.currentUser!;
        DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection("User").doc(uid).get();
        UserModel userModel =
        UserModel.fromMap(userData.data() as Map<String, dynamic>);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userModel: userModel,
              firebaseUser: firebaseUser,
            ),
          ),
        );
      }
    }).onError((error, stackTrace) {
      // Navigator.pop(context);
      // AlertBox().showAlertDialogBox(context, "Exception", error.toString());
      print("the error are " + error.toString());
    });
  }

}
