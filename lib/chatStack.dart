// chat_stack.dart
import 'package:flutter/material.dart';

class ChatStack extends StatefulWidget {
  
  final void Function(int) onChatSelected; // callback
  const ChatStack({Key? key, required this.onChatSelected}) : super(key: key);

  @override
  _ChatStackState createState() => _ChatStackState();
}

class _ChatStackState extends State<ChatStack> {
  final List<String> _chatTitles = ['Chat 1', 'Chat 2', 'Chat 3', 'Chat 4'];
  static int _selectedChatIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Return just the left panel (or entire layout if you wish),
    // but NOT a Scaffold, because we'll embed it inside HomePage.
    return Container(
      width: 250, // fixed sidebar width
      color: Colors.grey[900],
      child: SafeArea(
        child: Column(
          children: [
            // "New Chat" button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('New Chat'),
                onPressed: () {
                  setState(() {
                    _chatTitles.add('Chat ${_chatTitles.length + 1}');
                    _selectedChatIndex = _chatTitles.length - 1;
                  });
                },
              ),
            ),
            // List of chats
            Expanded(
              child: ListView.builder(
                itemCount: _chatTitles.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedChatIndex == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedChatIndex = index;
                      });
                      // 1) Call the callback to inform the parent
                      widget.onChatSelected(_selectedChatIndex);
                      print("Index $_selectedChatIndex Selected");
                    },
                    child: Container(
                      color: isSelected ? Colors.grey[700] : null,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        _chatTitles[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}