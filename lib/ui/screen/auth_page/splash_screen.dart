import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_1/ui/screen/alert_page/home_page/home_page.dart';
import 'package:task_1/ui/screen/auth_page/login_page.dart';
import 'package:task_1/ui/utils/text_const.dart';

import '../../../model/firebse_hgelper_model.dart';
import '../../../model/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashNavigate();
  }

  void splashNavigate() {
    Timer(const Duration(seconds: 3), () async {
      UserCredential userCredential;
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser;
      if (user != null) {
        UserModel? userModel =
        await FirebaseHelperModel.getUserModelByuUid(user.uid,);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(firebaseUser: user, userModel: userModel!),
          ),
        );

        // if (userModel != null) {
        // await  Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) =>
        //           HomePage(firebaseUser: user, userModel: userModel),
        //     ),
        // );
        // } else {
        //  await Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => LoginPage(),
        //       ),);
        // }
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>const LoginPage(),
            ));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: textBold(text: "This is the splash screen", fontSize: 16),
      ),
    );
  }
}
