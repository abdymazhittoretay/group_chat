import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_chat/models/message_model.dart';

class Firestore {
  final CollectionReference _messages = FirebaseFirestore.instance.collection(
    "messages",
  );

  Future<void> addMessage(MessageModel message) {
    return _messages.add({
      "message": message.message,
      "sentBy": message.sentBy,
      "date": message.date,
    });
  }

  Stream<QuerySnapshot> getMesssages() {
    final messagesStream =
        _messages.orderBy("date", descending: true).snapshots();
    return messagesStream;
  }

  Future<void> deleteMessage(String docId) {
    return _messages.doc(docId).delete();
  }
}
