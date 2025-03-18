import 'package:flutter/material.dart';
import 'package:group_chat/services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    );
  }
}
