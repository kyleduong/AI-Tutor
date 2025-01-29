import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AI Tutor",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double containerWidth = screenSize.width * 0.8; // 80% of screen width
    final double containerHeight =
        screenSize.height * 0.5; // 50% of screen height
    final double leftSpacing = screenSize.width * 0.05; // 80% of screen width
    final double buttonSpacing =
        screenSize.width * 0.005; // Spacing between buttons

    // space from the sidebar (20%)
    final double scrollableAndTextBoxSpaceFromLeft = screenSize.width * 0.1;

    // Calculate button dimensions as a percentage of the screen size
    final double buttonWidth =
        screenSize.width * 0.07; // Example: 15% of the screen width
    final double buttonHeight =
        screenSize.height * 0.05; // Example: 5% of the screen height

    return Scaffold(
      // Remove MaterialApp, it should be at the root
      
      appBar: AppBar(
        title: Text('Tinder for Kids MADE BY RAYNE, FOR RAYNE'),
        centerTitle: true,
        elevation: 10,
      ),
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Page 1')),
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Page 2')),
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Page 3')),
              ],
              selectedIndex: 0,
              onDestinationSelected: (value) {
                print('selected: $value');
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Distribute space
                children: [
                  SizedBox.shrink(), // Empty space at the top
                  // Center the scrollable box
                  // --- This is where the code starts --- 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      children: [
                        SizedBox(width: scrollableAndTextBoxSpaceFromLeft),
                        Center(
                          child: Flexible(
                            child: Container(
                              width: containerWidth,
                              height: containerHeight,
                              decoration: BoxDecoration(
                                // This part, putting color: fixed the corner issues.
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                // This part above and below, the clipRRect, was unnessessary up to this point,
                                // The corners were correctly rounded.
                                borderRadius: BorderRadius.circular(10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      // Add your content here
                                      Container(
                                        height: 1000,
                                        //color: Colors.white,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'This is some sample text inside the scrollable box. ' *
                                              10,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      //Container(height: 200, color: Colors.blue[100]),
                                      //Container(height: 150, color: Colors.green[100]),
                                      //Container(height: 300, color: Colors.red[100]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //SizedBox(width: leftSpacing),
                      ],
                    ),
                  ),
                  SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // Center the buttons
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // Center the buttons
                      children: [
                        SizedBox(width: scrollableAndTextBoxSpaceFromLeft),
                        Expanded(
                          // Make TextField take available space
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Type here...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        //height: 50,
                        SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              print('Left Button Pressed!');
                            },
                            child: Text('Left Button'),
                          ),
                        ),

                        SizedBox(width: buttonSpacing), // Space between buttons

                        SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              print('Right Button Pressed!');
                            },
                            child: Text('Find Match'),
                          ),
                        ),

                        SizedBox(width: leftSpacing * 1.15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
