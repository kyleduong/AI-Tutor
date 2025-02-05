
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';


// **FIREBASE**: import Firebase packages
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Make sure you've run flutterfire configure:
import 'firebase_options.dart';

import 'chatStack.dart';

class MainContent extends StatefulWidget{
  // WHY DO I NEED THIS ------------------------------------------------
  final int chatIndex;

  // Typically you do need this constructor to receive the index from the parent
  const MainContent({Key? key, required this.chatIndex}) : super(key: key);

  @override
  _mainContentState createState() => _mainContentState();
}

class _mainContentState extends State<MainContent>{

  bool _initialized = false;  // track if Firebase is inited
  bool _error = false;

  String chat = "Start typing to see text here..."; // Initial text
  final TextEditingController _controller = TextEditingController(); // Text controller
  late final FocusNode _focusNode; // Focus Node to access keyboard events

  int _selectedChatIndex = 0;
  bool _shiftPressed = false;



  // **FIREBASE**: Hardcode a chatId for demonstration

  // Gets the selected chatIndex from chatStack class.
  // In the future, i need to replace testChatId with the UsersID from authentication, so it will be USERID + CHAT # ----------------------
  String get _chatId => 'testChatId ${widget.chatIndex}';


  @override
  void initState() {
    super.initState();

    // SHIFT+Enter logic in the focus node
    _focusNode = FocusNode(
      onKeyEvent: (FocusNode node, KeyEvent evt) {
        if (evt.logicalKey.keyLabel == 'Enter') {
          if (evt is KeyDownEvent) {
            if (HardwareKeyboard.instance.isShiftPressed) {
              // SHIFT+ENTER => Insert newline
              _insertNewLine();
            } else {
              // ENTER => Send message
              _sendMessage();
            }
          }
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
    );

    // **FIREBASE**: Initialize FlutterFire
    _initializeFlutterFire();
  }
// old focusNode
/*
  late final _focusNode = FocusNode(
    onKeyEvent: (FocusNode node, KeyEvent evt) {
      //evt.logicalKey == LogicalKeyboardKey.enter
      if (evt.logicalKey.keyLabel == 'Enter') {
        if (evt is KeyDownEvent) {
          if (HardwareKeyboard.instance.isShiftPressed) {
            _insertNewLine();
          } else {
            _performSearch();
          }
        }
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    },
  );
  */

  // **FIREBASE**: Async function to init the Firebase app
  Future<void> _initializeFlutterFire() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() => _initialized = true);
    } catch (e) {
      setState(() => _error = true);
    }
  }

  // Old "submit" button
  /*
  void _performSearch() {
      setState((){
        chat = _controller.text; // update chat with text in field
        _controller.clear();
      });
      print('Search Pressed!');
    }
    */

  void _insertNewLine() {
    final text = _controller.text;
    final selection = _controller.selection;
    final newText = text.replaceRange(selection.start, selection.end, '\n');
    setState(() {
      _controller.text = newText;
      // Move cursor after newline
      _controller.selection = TextSelection.collapsed(offset: selection.start + 1);
    });
  }

  // "Send message": Writes a doc to Firestore
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Hardcode a "senderId" for demonstration
    const senderId = "userAUid";

    setState(() {
      _controller.clear();
    });

    // **FIREBASE**: Add a message doc to /chats/_chatId/messages
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(_chatId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });



  }

  // Pressing the "Search" button also sends a message
  void _onSearchPressed() {
    _sendMessage();
    print('Search (Send) Pressed!');
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {


    // If there's an error initializing Firebase, show a message
    if (_error) {
      return const Center(child: Text('Firebase init error'));
    }
    // If not yet initialized, show a loader
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final Size screenSize = MediaQuery.of(context).size;
    final double containerWidth = screenSize.width * 0.7;//MediaQuery.of(context).size.width; // 80% of screen width
    final double containerHeight = screenSize.height * 0.5;//MediaQuery.of(context).size.height; // 50% of screen height

    // Spacings
    final double sidebarSpace = screenSize.width * 0.1; // space from the NavigationRail
    final double buttonSpacing = screenSize.width * 0.005;
    final double buttonWidth   = screenSize.width * 0.07;
    final double buttonHeight  = screenSize.height * 0.05;


  return Expanded(
      child: Container(
        // Main background color (dark gray, for instance)
        color: Colors.grey[800],
        child: Column(
          children: [
            //SizedBox(width: sidebarSpace),
            Expanded(
            // The main "outer" container
              child:Container(
                width: containerWidth,
                //height: containerHeight,
                margin: const EdgeInsets.all(8.0), // Optional spacing
                // box appreance edits
                decoration: BoxDecoration(
                  color: Colors.grey[800],           // Slightly lighter than #212121
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    children: [
                      // 1) Scrollable area
                      // **FIREBASE**: Instead of a simple Text() for "chat",
                      // we use a StreamBuilder to read messages in real-time
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chats')
                              .doc(_chatId)
                              .collection('messages')
                              .orderBy('timestamp', descending: false)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final docs = snapshot.data!.docs;

                            // We'll display messages in a SingleChildScrollView
                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: docs.map((doc) {
                                  final data = doc.data() as Map<String, dynamic>;
                                  final text = data['text'] ?? '';
                                  final senderId = data['senderId'] ?? '';
                                  final ts = data['timestamp'] as Timestamp?;
                                  final timeStr = ts == null
                                      ? ''
                                      : ts.toDate().toLocal().toString();

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[600],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '$senderId: $text\n(time: $timeStr)',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // 2) Bottom area: a second Container for the textfield & buttons
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            // Slightly brighter color to highlight
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // TextField expands to take leftover horizontal space
                                Expanded(
                                  child: TextField(
                                    autofocus: true,
                                    focusNode: _focusNode, // SHIFT+Enter logic
                                    controller: _controller, // Used to track input
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,          // Removes default outline/underline
                                      enabledBorder: InputBorder.none,   // Removes border when not focused
                                      focusedBorder: InputBorder.none,   // Removes border when focused
                                      hintText: 'Type here...',
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      //border: OutlineInputBorder(),
                                      // Focused (on tap) border
                                      //focusedBorder: OutlineInputBorder(
                                        //borderSide: BorderSide(color: Colors.grey), // same color => no blue
                                      //),
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,  // Minimum height
                                    maxLines: 6, // Allows infinite vertical expansion
                                    //onSubmitted: (value) => _performSearch(), // Also triggers on Enter
                                    textInputAction: TextInputAction.none, // so we handle it ourselves
                                  ),

                                ),
                                SizedBox(width: 10),

                                // Search Button => actually sends message
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: _onSearchPressed,
                                      style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero, // Removes default padding
                                      alignment: Alignment.center, // Ensures the child is centered
                                    ),
                                    child: Icon(Icons.arrow_upward),
                                  ),
                                ),
                                
                                SizedBox(width: buttonSpacing),

                                // Reset Chat Button (clears local text, doesn't nuke Firestore)
                                
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: ElevatedButton(
                                    // MAKING THIS THE TEMPORARY SIGN OUT BUTTON UNTIL I FIND A BETTER SPOT --------------------------
                                    onPressed: _signOut,
                                      /*
                                      setState(() {
                                        // GPT SAID TO REMOVE THIS BELOW -------------------------------------------------------
                                        //chat = "Start typing to see text here..."; // Reset text
                                        _controller.clear(); // Clear input field
                                      });
                                      print('Reset Chat Pressed!');
                                      */
                                    style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero, // Removes default padding
                                    alignment: Alignment.center, // Ensures the child is centered
                                    ),
                                    child: Icon(Icons.logout), //Text('New Chat'),
                                  ),
                                ),
                              ],
                            ),
                            ),
                          ),
                        ),
                      
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';


class MainContent extends StatefulWidget {
  @override
  _mainContentState createState() => _mainContentState();
}

class _mainContentState extends State<MainContent> {
  String chat = "Start typing to see text here..."; // Initial text
  final TextEditingController _controller = TextEditingController(); // Text controller

  int _selectedChatIndex = 0;

  void _performSearch() {
      setState((){
        chat = _controller.text; // update chat with text in field
      });
      print('Search Pressed!');
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double containerWidth = screenSize.width * 0.7;
    final double containerHeight = screenSize.height * 0.5;
    final double sidebarSpace = screenSize.width * 0.1;
    final double buttonSpacing = screenSize.width * 0.005;
    final double buttonWidth = screenSize.width * 0.07;
    final double buttonHeight = screenSize.height * 0.05;

    return Expanded(
      child: Container(
        color: Colors.grey[800],
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: containerWidth,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              chat,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: 'Type here...',
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 6,
                                    onSubmitted: (_) { // we are passing _ as we dont need the string
                                      _performSearch();
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _performSearch,
                                      style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                    ),
                                    child: Icon(Icons.search),
                                  ),
                                ),
                                SizedBox(width: buttonSpacing),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        chat = "Start typing to see text here...";
                                        _controller.clear();
                                      });
                                      print('Reset Chat Pressed!');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                    ),
                                    child: Icon(Icons.edit_note_outlined),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/