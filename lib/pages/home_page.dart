import 'package:flutter/material.dart';
import 'package:group_chat/models/message_model.dart';
import 'package:group_chat/services/auth.dart';
import 'package:group_chat/services/firestore.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            await Auth().signOut();
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.logout),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(child: SizedBox()),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(border: OutlineInputBorder()),
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
    );
  }
}
