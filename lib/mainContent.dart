
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainContent extends StatefulWidget{
  @override
  _mainContentState createState() => _mainContentState();
}

class _mainContentState extends State<MainContent>{
  String chat = "Start typing to see text here..."; // Initial text
  final TextEditingController _controller = TextEditingController(); // Text controller
  final FocusNode _textFieldFocus = FocusNode(); // Focus Node to access keyboard events

  int _selectedChatIndex = 0;
  bool _shiftPressed = false;

  // This part i Just added
  /*
late final _focusNode = FocusNode(
  onKeyEvent: (FocusNode node, KeyEvent evt) {
    if (!HardwareKeyboard.instance.isShiftPressed &&
        evt.logicalKey.keyLabel == 'Enter') {
      if (evt is KeyDownEvent) {
        _performSearch(); // -> implement this
      }
      return KeyEventResult.handled;
    
    } else if (HardwareKeyboard.instance.isShiftPressed &&
      evt.logicalKey.keyLabel == 'Enter'){
      _insertNewLine();
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  },
);
*/

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

  void _performSearch() {
      setState((){
        chat = _controller.text; // update chat with text in field
        _controller.clear();
      });
      print('Search Pressed!');
    }

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

  @override
  void dispose() {
    _textFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              chat, // this will display the current chat variable
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
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
                                    focusNode: _focusNode,
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

                                // Search Button
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState((){
                                        chat = _controller.text; // update chat with text in field
                                      });
                                      print('Search Pressed!');
                                    },
                                      style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero, // Removes default padding
                                      alignment: Alignment.center, // Ensures the child is centered
                                    ),
                                    child: Icon(Icons.search),
                                  ),
                                ),
                                
                                SizedBox(width: buttonSpacing),

                                // Reset Chat Button
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        chat = "Start typing to see text here..."; // Reset text
                                        _controller.clear(); // Clear input field
                                      });
                                      print('Reset Chat Pressed!');
                                    },
                                      style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero, // Removes default padding
                                      alignment: Alignment.center, // Ensures the child is centered
                                    ),
                                    child: Icon(Icons.edit_note_outlined), //Text('New Chat'),
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