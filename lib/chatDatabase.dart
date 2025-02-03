import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  final String chatId; // e.g. the ID of the conversation you want to show

  ChatScreen({required this.chatId});

  @override
  Widget build(BuildContext context) {
    final messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('messageID');

    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          // 1) The messages list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                // docs is a list of QueryDocumentSnapshot
                return ListView.builder(
                  reverse: true, // so newest at bottom
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final text = data['text'] ?? '';
                    final sender = data['senderId'] ?? 'Unknown';
                    final timestamp = data['timestamp'] as Timestamp?;

                    return ListTile(
                      title: Text(text),
                      subtitle: Text('From: $sender'),
                    );
                  },
                );
              },
            ),
          ),

          // 2) An input field for sending new messages
          MessageInputField(chatId: chatId),
        ],
      ),
    );
  }
}
