import 'dart:developer';
import 'package:async/async.dart' show StreamGroup;
import 'package:localstorage/localstorage.dart';
import 'package:scoped_model/scoped_model.dart';

import '../config.dart';

class DataModel extends Model {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> userData =
 [];

  final Map<String, Future> _messageStatus = <String, Future>{};

  _getMessageKey(String? peerNo, int? timestamp) => '$peerNo$timestamp';

  getMessageStatus(String? peerNo, int? timestamp) {
    final key = _getMessageKey(peerNo, timestamp);
    return _messageStatus[key] ?? true;
  }

  bool _loaded = false;

  final LocalStorage _storage = LocalStorage('model');

  addMessage(String? peerNo, int? timestamp, Future future) {
    final key = _getMessageKey(peerNo, timestamp);
    future.then((_) {
      _messageStatus.remove(key);
    });
    _messageStatus[key] = future;
  }

  updateItem(String key, Map<String, dynamic> value) {
    Map<String, dynamic> old = _storage.getItem(key) ?? <String, dynamic>{};
    old.addAll(value);
    _storage.setItem(key, old);
  }


  bool get loaded => _loaded;

  Map<String, dynamic>? get currentUser => _currentUser;

  Map<String, dynamic>? _currentUser;

  Map<String?, int?> get lastSpokenAt => _lastSpokenAt;

  final Map<String?, int?> _lastSpokenAt = {};

  getChatOrder(List<String> chatsWith, String? currentUserNo) {
    List<Stream<QuerySnapshot>> messages = [];

    chatsWith.asMap().forEach((key,otherNo) {
      String chatId = otherNo;
      messages.add(FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user["id"])
          .collection(collectionName.chat).where("chatId",isEqualTo: chatId)
          .snapshots());
    });

    StreamGroup.merge(messages).listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot message = snapshot.docs.last;
        _lastSpokenAt[message["senderId"] == currentUserNo
            ? message["receiverId"]
            : message["senderId"]] = message["timestamp"];

        notifyListeners();
        log("_lastSpokenAt :: $_lastSpokenAt");
      }
    });

  }

  DataModel(String? currentUserNo) {
    FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .snapshots()
        .listen((user) {
      _currentUser = user.data();
      notifyListeners();
    });

    _storage.ready.then((ready) {
      if (ready) {
        debugPrint("STORAGE sss:: $ready");
        FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(appCtrl.user["id"])
            .collection(collectionName.chats) .orderBy("updateStamp", descending: true)
            .snapshots()
            .listen((chatsWith) {
          debugPrint("_chatsWithexists : ${chatsWith.docs.length}");
          if (chatsWith.docs.isNotEmpty) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> users = [];
            List<QueryDocumentSnapshot<Map<String, dynamic>>> peers = [];

            chatsWith.docs.asMap().entries.forEach((element) {

              peers.add(element.value);
            });

            users = peers;
            notifyListeners();
            List<QueryDocumentSnapshot<Map<String, dynamic>>> newData =
            [];
            users.asMap().entries.forEach((element) {
              newData.add(element.value);
            });

            userData= newData;
            notifyListeners();
            log("LOG :: $newData");
          }
          if (!_loaded) {
            _loaded = true;
            notifyListeners();
          }
        });
      }
    });
  }
}