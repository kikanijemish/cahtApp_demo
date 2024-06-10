import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_1/model/user_model.dart';


class FirebaseHelperModel{

  static  Future<UserModel?> getUserModelByuUid(String uid)async{

    UserModel?userModel;

    DocumentSnapshot documentSnapshot=await FirebaseFirestore.instance.collection("User").doc(uid).get();

    if(documentSnapshot!=null){

       userModel=await UserModel.fromMap(documentSnapshot.data() as Map<String,dynamic>);}
    return userModel;
  }
}