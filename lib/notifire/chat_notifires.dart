import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class VehicleNotifier extends ChangeNotifier{

  List<String> vehicleList=[];
  bool imagePicked=false;

  getVehicle(newList){
    vehicleList=newList;
    notifyListeners();
  }

messageSeen(status,chatRoom,newMessage){
  FirebaseFirestore.instance
      .collection("chatrooms")
      .doc(chatRoom.chatRoom.chtRoomId)
      .collection("message")
      .doc(newMessage.messageId).update({"seen":status});

}

}