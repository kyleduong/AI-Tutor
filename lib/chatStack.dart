// chat_stack.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // if you're using FirebaseAuth

class ChatStack extends StatefulWidget {
  final void Function(int) onChatSelected; // callback
  final void Function(int)? onNewChat;
  const ChatStack({Key? key, required this.onChatSelected, this.onNewChat,}) : super(key: key);

  @override
  _ChatStackState createState() => _ChatStackState();
}

class _ChatStackState extends State<ChatStack> {
  static int _selectedChatIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Obtain the current user's UID, if available.
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "default";

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
                onPressed: () async {
                  // Retrieve the current chats to determine the new chat number.
                  QuerySnapshot chatSnapshot =
                      await FirebaseFirestore.instance.collection(uid).get();

                  // + 1
                  final newChatNumber = chatSnapshot.docs.length;
                  final chatDocId = 'Chat $newChatNumber';


                  // Create the parent chat document with a custom ID.
                  await FirebaseFirestore.instance
                      .collection(uid)
                      .doc(chatDocId)
                      .set({
                    'title': chatDocId,
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  // Create an initial message in the 'messages' subcollection.
                  await FirebaseFirestore.instance
                      .collection(uid)
                      .doc(chatDocId)
                      .collection('messages')
                      .add({
                    'text': "Type to start the conversation.",
                    'senderId': "AI",
                    'timestamp': FieldValue.serverTimestamp(),
                    'number': 0,
                    
                  });

                  // Update the selected chat index so the StreamBuilder listens to the newly created chat.
                  setState(() {
                    _selectedChatIndex = newChatNumber; // newChatNumber should match your doc ID suffix
                  });  

                  // Optionally, you can also trigger the parent's callback if needed:
                  widget.onChatSelected(_selectedChatIndex);
                },
              ),
            ),
            // List of chats from Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                  .collection(uid)
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: TextStyle(color: Colors.white)),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Center(
                      child: Text('No chats available${'\n'}Type to start a new one.',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          ),
                          
                    );
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      // Get the data from each chat document.
                      final data = docs[index].data() as Map<String, dynamic>;
                      // Use the title from the document if available.
                      // + 1
                      final chatTitle = data['title'] ?? 'Chat ${index}';
                      final isSelected = _selectedChatIndex == index;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedChatIndex = index;
                          });
                          // Trigger the callback to inform the parent widget.
                          widget.onChatSelected(_selectedChatIndex);
                        },
                        // Hover color (visible on desktop/web).
                        hoverColor: Colors.greenAccent,
                        child: Container(
                          color: isSelected ? Colors.grey[700] : null,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(
                            chatTitle,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
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
