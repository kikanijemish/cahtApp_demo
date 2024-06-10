import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:task_1/notifire/vegicle_notifire.dart';
import 'package:task_1/ui/screen/auth_page/splash_screen.dart';
import 'package:uuid/uuid.dart';
var uuid=Uuid();
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
final auth=FirebaseAuth.instance;
final user=auth.currentUser;

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<VehicleNotifier>(
              create: (context) => VehicleNotifier()),
        ],
    
    child:   GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:
      SplashScreen(),
    ));
  }
}

