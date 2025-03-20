import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/models/message_model.dart';
import 'package:group_chat/services/auth.dart';
import 'package:group_chat/services/firestore.dart';
import 'package:grouped_list/grouped_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Firestore _fs = Firestore();

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.black,
          title: Text("Home Page"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              await Auth().signOut();
              if (context.mounted) Navigator.pop(context);
            },
            icon: Icon(Icons.logout),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: _fs.getMesssages(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        List<MessageModel> messages =
                            snapshot.data!.docs
                                .map((doc) {
                                  return MessageModel(
                                    message: doc["message"],
                                    sentBy: doc["sentBy"],
                                    date: (doc["date"] as Timestamp).toDate(),
                                  );
                                })
                                .toList()
                                .reversed
                                .toList();
                        return GroupedListView<MessageModel, DateTime>(
                          reverse: true,
                          order: GroupedListOrder.DESC,
                          useStickyGroupSeparators: true,
                          floatingHeader: true,
                          elements: messages,
                          groupBy:
                              (message) => DateTime(
                                message.date.year,
                                message.date.month,
                                message.date.day,
                              ),
                          groupHeaderBuilder:
                              (MessageModel message) => SizedBox(
                                height: 50.0,
                                child: Center(
                                  child: Card(
                                    color: Colors.blue,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${message.date.day.toString().padLeft(2, "0")} ${message.date.month.toString().padLeft(2, "0")} ${message.date.year}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          itemBuilder: (context, MessageModel message) {
                            final isSentByMe =
                                message.sentBy == Auth().currentUser!.email;
                            return Align(
                              alignment:
                                  isSentByMe
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Card(
                                color: Colors.white,
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        isSentByMe
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.person),
                                          Text(message.sentBy!),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(message.message),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
                SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            _fs.addMessage(
                              MessageModel(
                                message: _controller.text,
                                sentBy: Auth().currentUser!.email,
                                date: DateTime.now(),
                              ),
                            );
                            _controller.clear();
                            FocusScope.of(context).unfocus();
                          }
                        },
                        icon: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
