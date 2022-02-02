
class VendorModel {
  String shopName;
  String email;
  String phone;
  String vId;
  String address = "";
  bool vendor = true;
  bool verfiedEmail = false;
  String imageProfile =
      "https://banner2.cleanpng.com/20180920/yko/kisspng-computer-icons-portable-network-graphics-avatar-ic-5ba3c66df14d32.3051789815374598219884.jpg";
  String fcmId;    

  VendorModel(
      {this.shopName,
      this.email,
      this.vId,
      this.phone,
      this.address,
      this.imageProfile="https://banner2.cleanpng.com/20180920/yko/kisspng-computer-icons-portable-network-graphics-avatar-ic-5ba3c66df14d32.3051789815374598219884.jpg",
      this.verfiedEmail,
      this.fcmId,
      });

  VendorModel.fromJson(Map<String, dynamic> json) {
    shopName = json['name'];
    address = json['address'];
    email = json['email'];
    phone = json['phone'];
    vendor = json['vendor'];
    vId = json['uId'];
    verfiedEmail = json['verfiedEmail'];
    imageProfile = json['imageProfile'];
    fcmId=json['fcmId'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": shopName,
      "email": email,
      "phone": phone,
      "address": address,
      "vendor": vendor,
      "uId": vId,
      "verfiedEmail": verfiedEmail,
      "imageProfile": imageProfile,
      'fcmId':fcmId,
    };
  }
}
