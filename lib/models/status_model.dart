

class Status {
  String? uid;
  String? docId;
  String? username;
  String? phoneNumber;
  List<PhotoUrl>? photoUrl;
  List? seenAllStatus;
  String? createdAt;
  String? updateAt;
  String? profilePic;
  bool? isSeenByOwn;

  Status(
      {this.uid,
      this.username,
      this.docId,
      this.phoneNumber,
      this.photoUrl,
      this.seenAllStatus,
      this.createdAt,
      this.updateAt,
      this.profilePic,
      this.isSeenByOwn});

  Status.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'] ?? "";
    phoneNumber = json['phoneNumber'] ?? "";
    createdAt = json['createdAt'];
    updateAt = json['updateAt'];
    profilePic = json['profilePic'];
    isSeenByOwn = json['isSeenByOwn'];
    if (json['photoUrl'] != null) {
      photoUrl = <PhotoUrl>[];
      json['photoUrl'].forEach((v) {
        photoUrl!.add(PhotoUrl.fromJson(v));
      });
    }
    if (json.containsKey("seenAllStatus")) {
      seenAllStatus = json['seenAllStatus'] ?? [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['username'] = username;
    data['phoneNumber'] = phoneNumber;
    data['createdAt'] = createdAt;
    data['updateAt'] = updateAt;
    data['profilePic'] = profilePic;
    data['isSeenByOwn'] = isSeenByOwn;
    if (photoUrl != null) {
      data['photoUrl'] = photoUrl!.map((v) => v.toJson()).toList();
    }
    if (seenAllStatus != null) {
      if (seenAllStatus!.isNotEmpty) {
        data['seenAllStatus'] = seenAllStatus;
      }
    }
    return data;
  }
}

class PhotoUrl {
  String? image;
  String? timestamp;
  String? statusType;
  String? statusText;
  String? statusBgColor;
  bool? isExpired;
  List? seenBy;
  String? expiryDate;

  PhotoUrl({this.image, this.timestamp, this.isExpired, this.statusType,this.expiryDate});

  PhotoUrl.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    timestamp = json['timestamp'];
    isExpired = json['isExpired'];
    statusType = json['statusType'];
    statusText = json['statusText'];
    statusBgColor = json['statusBgColor'];
    seenBy = json['seenBy'] ?? [];
    expiryDate = json['expiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['timestamp'] = timestamp;
    data['isExpired'] = isExpired;
    data['statusType'] = statusType;
    data['statusText'] = statusText;
    data['statusBgColor'] = statusBgColor;
    data['expiryDate'] = expiryDate;
    if (seenBy!.isNotEmpty) {
      data['seenBy'] = seenBy;
    }
    return data;
  }
}
