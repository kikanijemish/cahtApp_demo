import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel{

  String? chtRoomId;
  Map<String,dynamic>? participants;
  String?lastMessage;
  Timestamp? messageTime;
  bool?status;

  ChatRoomModel({this.chtRoomId,this.participants,this.lastMessage,this.messageTime,this.status});

  ChatRoomModel.fromMap(Map<String,dynamic>map){

    chtRoomId=map["chtRoomId"];
    participants=map["participants"];
    lastMessage=map["lastMessage"];
    messageTime=map["messageTime"];
    status=map["status"];
  }

  Map<String,dynamic>? toMap(){
    return{
      "chtRoomId":chtRoomId,
      "participants":participants,
      "lastMessage":lastMessage,
      "messageTime":messageTime,
      "status":status,
    };
  }
}