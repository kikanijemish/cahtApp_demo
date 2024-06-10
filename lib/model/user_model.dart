class UserModel{

  String? uid;
  String? fullName;
  String? email;
  String? profilePic;
  String?status;

  UserModel({this.email,this.fullName,this.profilePic,this.uid,this.status});

  UserModel.fromMap(Map<String,dynamic>map){
    uid=map["uid"];
    fullName=map["fullName"];
    email=map["email"];
    profilePic=map["profilePic"];
    status=map["status"];
  }

  Map<String,dynamic> toMap(){
    return{
      "uid":uid,
      "fullName":fullName,
      "email":email,
      "profilePic":profilePic,
      "status":status,
    };
  }
}