import 'dart:typed_data';

class FirebaseContactModel {
  String? name, phone, id;
  bool? isRegister;
  Uint8List? photo;

  FirebaseContactModel(
      {this.name, this.phone, this.id, this.isRegister = false,this.photo});

  FirebaseContactModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    id = json['id'];
    isRegister = json['isRegister'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['id'] = id;
    data['isRegister'] = isRegister;
    data['photo'] = photo;
    return data;
  }
}
