
class UserModel {
  String name;
  String email;
  String phone;
  String uId;
  String address = "No address";
  bool vendor = false;
  bool verfiedEmail = false;
  String fcmId;

  UserModel({this.name, this.email, this.uId, this.phone, this.address="No address",this.verfiedEmail,this.fcmId});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    address = json['address'];
    vendor = json['vendor'];
    verfiedEmail = json['verfiedEmail'];
    fcmId=json['fcmId'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "vendor": vendor,
      "uId": uId,
      "verfiedEmail": verfiedEmail,
      'fcmId':fcmId,
    };
  }
}
