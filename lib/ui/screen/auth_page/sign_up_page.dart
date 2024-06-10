import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_1/model/user_model.dart';
import 'package:task_1/ui/screen/auth_page/login_page.dart';
import 'package:task_1/ui/screen/auth_page/profile_page.dart';

import '../../../model/vehicle_model.dart';
import '../../const/long_button_const.dart';
import '../../const/teaxt_form_field_const.dart';
import '../../utils/app_color.dart';
import '../../utils/text_const.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();



  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  UserCredential? userCredential;


  signUpMethod(email, password) async {
    try {
    userCredential=  await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = auth.currentUser;

    }on FirebaseAuthException catch (e) {
      Get.snackbar("Hey", e.toString());
      log(" Exception ${e.toString()}");
    }

    if (userCredential != null) {
      String uid= userCredential!.user!.uid;

      UserModel newUser=UserModel(profilePic: "",fullName: "",uid: uid,email: emailController.text.trim());
      await FirebaseFirestore.instance.collection("User").doc(uid).set(newUser.toMap()).then((value) {

        Navigator.popUntil(context, (route) => route.isFirst);
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  ProfilePage(userModel:newUser,firebaseUSer:userCredential!.user!),
          ),
        );
      },);



    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().orangeCode,
        title: textMedium(text: "Sign Up", fontSize: 16),
        centerTitle: true,
      ),
      body: bodyData(),
    );
  }

  Widget bodyData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [formData(), loginButtonConst(), haveAnAccount()],
      ),
    );
  }

  Widget formData() {
    return Column(
      children: [
        TextFormFieldLabelConst(
          label: "Email",
          controller: emailController,
          hintText: "Enter Email",
        ),
        TextFormFieldLabelConst(
          label: "Password",
          controller: passwordController,
          hintText: "Enter Password",
        ),
      ],
    );
  }

  Widget loginButtonConst() {
    return LongButtonConst(
        topPadding: 40,
        colors: AppColors().orangeCode,
        child: textBold(text: "SignUP", fontSize: 14, topPadding: 0),
        onTap: () {
          if (emailController.text.trim() == "") {
            Get.snackbar("Hey", "Enter the email");
          } else if (passwordController.text.trim() == "") {
            Get.snackbar("Hey", "Enter the Password");
          } else {
            signUpMethod(emailController.text, passwordController.text);
          }
        });
  }

  Widget haveAnAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textMedium(
            text: "Already Have an Account?", fontSize: 14, rightPadding: 5),
        InkWell(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return const LoginPage();
              },
            ));
          },
          child: textMedium(
              text: "Login",
              fontSize: 14,
              leftPadding: 0,
              fontColor: AppColors().orangeCode),
        ),
      ],
    );
  }
}
