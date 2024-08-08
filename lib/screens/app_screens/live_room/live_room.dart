import 'package:chatzy/config.dart';
import 'package:flutter/material.dart';
import 'package:chatzy/screens/app_screens/live_room/zego/livepage.dart';

class LiveRoom extends StatefulWidget {
  const LiveRoom({super.key});

  @override
  State<LiveRoom> createState() => _LiveRoomState();
}

class _LiveRoomState extends State<LiveRoom> {
  final TextEditingController _roomIDController = TextEditingController();

  @override
  void dispose() {
    _roomIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Zego Cloud',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _roomIDController,
              decoration: const InputDecoration(
                labelText: 'Enter Room ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_roomIDController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LivePage(
                        roomID: 'your_room_id',
                        userID: appCtrl.user['id'],
                        userName: appCtrl.user['name'],
                        isHost: true, // or false, depending on the role
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Room ID cannot be empty')),
                  );
                }
              },
              child: const Text('Join Room'),
            ),
          ],
        ),
      ),
    );
  }
}
