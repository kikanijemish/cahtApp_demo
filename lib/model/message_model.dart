import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{

  String? sender;
  String? messageId;
  bool? seen;
  String? text;
  String? imageUrl;
  Timestamp? createdOn;

  MessageModel({this.text,this.createdOn,this.seen,this.sender,this.messageId,this.imageUrl});

  MessageModel.fromMap(Map<String,dynamic>map){
    sender = map["sender"];
    seen = map["seen"];
    text = map["text"];
    createdOn = map["createdOn"];
    messageId = map["messageId"];
    imageUrl = map["imageUrl"];
  }
  Map<String,dynamic> toMap(){
    return {
      "sender":sender,
      "seen":seen,
      "createdOn":createdOn,
      "messageId":messageId,
      "text":text,
      "imageUrl":imageUrl
    };

  }
}

