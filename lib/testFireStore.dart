// main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// You'll need this file generated by `flutterfire configure`:
import 'firebase_options.dart'; // <-- Make sure this exists in your project

/// Main entry point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

/// A simple root widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Chat Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

/// A home page that automatically creates or retrieves a chat between two "users" and navigates to the ChatScreen.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _chatId; // We'll store the ID of our chat after creation

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  /// Example: create or retrieve a chat for userA and userB
  Future<void> _initChat() async {
    // In a real app, you'd get actual user UIDs from FirebaseAuth
    const userA = "userAUid";
    const userB = "userBUid";

    final chatId = await createChatDoc(userA, userB);
    setState(() {
      _chatId = chatId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_chatId == null) {
      // Chat doc not created yet
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Once we have a chatId, go to the ChatScreen
    return ChatScreen(chatId: _chatId!);
  }
}

/// Creates or retrieves a chat doc for userA/userB in `/chats/{chatId}`
Future<String> createChatDoc(String userA, String userB) async {
  // Deterministic chat ID (for a 1-to-1 chat). 
  // Or you could do a random doc ID with .doc() without specifying
  final chatId = userA.compareTo(userB) < 0 ? '$userA\_$userB' : '$userB\_$userA';

  final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

  // Optionally set some metadata if the doc doesn't exist
  await chatRef.set({
    'participants': [userA, userB],
    'createdAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true)); 
  // merge: true so we don't overwrite if it already exists

  return chatId;
}

/// A screen that displays messages in real-time for a given chatId
class ChatScreen extends StatelessWidget {
  final String chatId;

  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Reference to messages in `/chats/{chatId}/messages`, ordered by timestamp
    final messagesQuery = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true);

    return /*Scaffold(
      appBar: AppBar(title: Text('Chat: $chatId')),
body:*/Column(
        children: [
          // The messages list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesQuery.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true, // newest messages at the top
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final text = data['text'] ?? '';
                    final senderId = data['senderId'] ?? '';
                    final timeStamp = data['timestamp'] as Timestamp?;
                    final timeString = timeStamp?.toDate().toLocal().toString() ?? '';

                    return ListTile(
                      title: Text(text),
                      subtitle: Text('$senderId @ $timeString'),
                    );
                  },
                );
              },
            ),
          ),

          // Text field + send button
          MessageInputField(chatId: chatId),
        ],
      //),
    );
  }
}

/// A widget for typing and sending messages to `/chats/{chatId}/messages`
class MessageInputField extends StatefulWidget {
  final String chatId;

  const MessageInputField({Key? key, required this.chatId}) : super(key: key);

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();

  /// Insert a new doc into the Firestore subcollection
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // In a real app, you'd get the current user's ID from FirebaseAuth:
    const currentUserId = "userAUid"; // Example

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': currentUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Clear the text field
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // The text field
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
