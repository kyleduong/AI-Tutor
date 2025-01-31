import 'package:flutter/material.dart';

class MainContent extends StatefulWidget{
  @override
  _mainContentState createState() => _mainContentState();
}

class _mainContentState extends State<MainContent>{
  String chat = "";
  int _selectedChatIndex = 0;

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
                              'No patterns to detect here. jfkdsal;faljdks' * 500,
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
                                  ),
                                ),
                                SizedBox(width: 10),

                                // Left Button
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
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

                                // Right Button
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print('New Chat Pressed!');
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
