
class DateTimeChip {
  String? time;
  List<MessageModel>? message;

  DateTimeChip({
    this.time,
    this.message,
  });

  DateTimeChip.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    if (json['message'] != null) {
      message = <MessageModel>[];
      json['message'].forEach((v) {
        message!.add(MessageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageModel {
  String? sender, senderName;
  String? receiver;
  String? content;
  String? timestamp;
  String? type, groupId,broadcastId;
  String? messageType, chatId, blockBy, blockUserId, emoji, favouriteId, docId;
  bool? isBlock, isSeen, isBroadcast, isFavourite;
  List? receiverList, seenMessageList;

  MessageModel(
      {this.sender,
        this.senderName,
        this.receiverList,
        this.content,
        this.timestamp,
        this.type,
        this.chatId,
        this.messageType,
        this.blockBy,
        this.blockUserId,
        this.isBlock = false,
        this.isBroadcast = false,
        this.isSeen = false,
        this.emoji,
        this.isFavourite = false,
        this.favouriteId,
        this.docId,
        this.groupId,
        this.broadcastId,
        this.seenMessageList,
        this.receiver});

  MessageModel.fromJson(Map<String, dynamic> json) {
    sender = json["sender"];
    senderName = json['senderName'] ?? '';
    if (!json.containsKey("groupId") && !json.containsKey("broadcastId") ) {
      receiver = json['receiver'] ?? '';
    }
    content = json['content'] ?? '';
    timestamp = json['timestamp'];
    docId = json['docId'];
    type = json['type'] ?? '';
    chatId = json['chatId'] ?? '';
    messageType = json['messageType'] ?? "";
    blockBy = json['blockBy'] ?? "";
    blockUserId = json['blockUserId'] ?? "";
    if (json.containsKey("emoji")) {
      emoji = json['emoji'] ?? "";
    }
    if (json.containsKey("favouriteId")) {
      favouriteId = json['favouriteId'] ?? "";
    }
    if (json.containsKey("isBlock")) {
      isBlock = json['isBlock'] ?? "";
    } else {
      isBlock = false;
    }
    isBroadcast = json['isBroadcast'] ?? false;
    isSeen = json['isSeen'] ?? false;
    if (json.containsKey("isFavourite")) {
      isFavourite = json['isFavourite'] ?? false;
    }
    if (json.containsKey("groupId") || json.containsKey("broadcastId")) {
      if (json.containsKey("receiver")) {
        receiverList = json['receiver'] ?? [];
      }
    }
    if (json.containsKey("groupId") || json.containsKey("broadcastId")) {
      groupId = json['groupId'] ?? "";
    }
    if (json.containsKey("seenMessageList")) {
      seenMessageList = json['seenMessageList'] ?? "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender'] = sender;
    data['senderName'] = senderName;
    data['receiver'] = receiver;
    data['content'] = content;
    data['timestamp'] = timestamp;
    data['docId'] = docId;
    data['type'] = type;
    data['chatId'] = chatId;
    data['messageType'] = messageType;
    data['blockBy'] = blockBy;
    data['blockUserId'] = blockUserId;
    data['emoji'] = emoji;
    data['favouriteId'] = favouriteId;
    data['isBlock'] = isBlock;
    data['isBroadcast'] = isBroadcast;
    data['isSeen'] = isSeen;
    data['isFavourite'] = isFavourite;
    data['receiverList'] = receiverList;
    data['groupId'] = groupId;
    data['seenMessageList'] = seenMessageList;
    data['broadcastId'] = broadcastId;
    return data;
  }
}
