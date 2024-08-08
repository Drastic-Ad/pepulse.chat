class UsageControlModel {
  String? statusDeleteTime;
  bool? allowCreatingBroadcast,
      allowCreatingGroup,
      allowCreatingStatus,
      allowUserSignup,
      callsAllowed,
      existenceUsers,
      mediaSendAllowed,
      showLogoutButton,
      textMessageAllowed;
  int? broadCastMembersLimit, groupMembersLimit,maxFileSize,maxFilesMultiShare,maxContactSelectForward;

  UsageControlModel({
    this.statusDeleteTime,
    this.allowCreatingBroadcast,
    this.allowCreatingGroup,
    this.allowCreatingStatus,
    this.allowUserSignup,
    this.callsAllowed,
    this.existenceUsers,
    this.mediaSendAllowed,
    this.textMessageAllowed,
    this.broadCastMembersLimit,
    this.groupMembersLimit,
    this.maxFileSize,
    this.maxFilesMultiShare,
    this.maxContactSelectForward,
  });

  UsageControlModel.fromJson(Map<String, dynamic> json) {
    statusDeleteTime = json['statusDeleteTime'] ?? "24";
    allowCreatingBroadcast = json['allowCreatingBroadcast'] ?? false;
    allowCreatingGroup = json['allowCreatingGroup'] ?? false;
    allowCreatingStatus = json['allowCreatingStatus'] ?? true;
    allowUserSignup = json['allowUserSignup'] ?? true;
    callsAllowed = json['callsAllowed'] ?? true;
    existenceUsers = json['existenceUsers'] ?? false;
    mediaSendAllowed = json['mediaSendAllowed'] ?? true;
    showLogoutButton = json['showLogoutButton'] ?? true;
    textMessageAllowed = json['textMessageAllowed'] ?? true;
    broadCastMembersLimit = json['broadCastMembersLimit'] ?? 10;
    groupMembersLimit = json['groupMembersLimit'] ?? 10;
    maxFileSize = json['maxFileSize'] ?? 15;
    maxFilesMultiShare = json['maxFilesMultiShare'] ?? 15;
    maxContactSelectForward = json['maxContactSelectForward'] ?? 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusDeleteTime'] = statusDeleteTime;
    data['allowCreatingBroadcast'] = allowCreatingBroadcast;
    data['allowCreatingGroup'] = allowCreatingGroup;
    data['allowCreatingStatus'] = allowCreatingStatus;
    data['allowUserSignup'] = allowUserSignup;
    data['callsAllowed'] = callsAllowed;
    data['existenceUsers'] = existenceUsers;
    data['mediaSendAllowed'] = mediaSendAllowed;
    data['showLogoutButton'] = showLogoutButton;
    data['textMessageAllowed  '] = textMessageAllowed;
    data['broadCastMembersLimit'] = broadCastMembersLimit;
    data['groupMembersLimit'] = groupMembersLimit;
    data['maxFileSize'] = maxFileSize;
    data['maxFilesMultiShare'] = maxFilesMultiShare;
    data['maxContactSelectForward'] = maxContactSelectForward;
    return data;
  }
}
