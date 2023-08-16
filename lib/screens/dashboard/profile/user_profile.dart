import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 0),
          Text(
            "Fahad313",
            style: TextStyle(fontSize: 20,color: Colors.white),
          ),
        ],
      ),
    );
  }
}
