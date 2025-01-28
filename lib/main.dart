
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
      title: "AI Tutor",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),

    );
  }
}

/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );  
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }


}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  var selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {

  Widget page;
  switch (selectedIndex) {
    case 0:
      page = GeneratorPage();
      break;
    case 1:
      page = FavoritesPage();
      break;
    default:
      throw UnimplementedError('no widget for $selectedIndex');
  }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState((){
                selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary, 
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
        pair.asLowerCase, 
        style: style,
        semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/openai_service.dart';

Future<void> main() async {
await dotenv.load(fileName: ".env");

  //runApp(MyApp());
  runApp(HomePage());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    final OpenAIService _openAIService = OpenAIService(apiKey);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('OpenAI API Example')),
        body: Center(
          child: FutureBuilder(
            future: _openAIService.generateResponse("What is Dart programming?"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text('Response: ${snapshot.data}');
              }
            },
          ),
        ),
      ),
    );
  }
}
*/

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double containerWidth = screenSize.width * 0.6; // 80% of screen width
    final double containerHeight = screenSize.height * 0.5; // 50% of screen height
    final double leftSpacing = screenSize.width * 0.1; // 80% of screen width
    final double buttonSpacing = screenSize.width * 0.005; // Spacing between buttons

    return Scaffold( // Remove MaterialApp, it should be at the root
      appBar: AppBar(
        title: Text('Tinder for Kids MADE BY RAYNE, FOR RAYNE'),
        centerTitle: true,
        elevation: 10,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Distribute space
        children: [
          SizedBox.shrink(), // Empty space at the top
          // Center the scrollable box
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              children: [
                Spacer(),
                Center(
                  child: Container(
                    width: containerWidth,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Add your content here
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'This is some sample text inside the scrollable box. ' * 10,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Container(height: 200, color: Colors.blue[100]),
                          Container(height: 150, color: Colors.green[100]),
                          Container(height: 300, color: Colors.red[100]),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: leftSpacing),
              ],
            ),
          ),
          SizedBox(height:0),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Center the buttons
              crossAxisAlignment: CrossAxisAlignment.center, // Center the buttons
              children: [
                Spacer(),
                  Expanded( // Make TextField take available space
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  //height: 50,
                  ElevatedButton(
                    onPressed: () {
                      print('Left Button Pressed!');
                    },
                    child: Text('Left Button'),
                  ),
                
                SizedBox(width: buttonSpacing), // Space between buttons
                
                  
                  ElevatedButton(
                    onPressed: () {
                      print('Right Button Pressed!');
                    },
                    child: Text('Find Match'),
                  ),
                
                SizedBox(width: leftSpacing * 1.05),
              ],  
            ),
          ),
        ],
      ),
    );
  }
}