import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chatStack.dart';
import 'mainContent.dart';
import 'services/user_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Auto-generated by flutterfire configure
import 'package:firebase_auth/firebase_auth.dart';

import 'testFireStore.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );

  // Wait for the initial auth state to be loaded, this way the signout function works
  await FirebaseAuth.instance.authStateChanges().first;

  // This signs out the user on startup.
  await FirebaseAuth.instance.signOut();

  // load env and get key
  await dotenv.load(fileName: ".env");

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
      home: const AuthGate(),
    );
  }
}

/// AuthGate decides which screen to show based on login state.
class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.authStateChanges() is a Stream of User? 
    // that emits whenever the user signs in/out.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If snapshot has data, user is logged in -> show Home
        
        if (snapshot.hasData) {
          return HomePage();
        }
        // Else show SignInScreen
        return const SignInScreen();
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  int _currentChatIndex = 0;

  void _handleNewChat(int index) {
    setState(() {
      _currentChatIndex = index;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final Size screenSize = MediaQuery.of(context).size;
    final double containerWidth = screenSize.width * 0.7;//MediaQuery.of(context).size.width; // 80% of screen width
    final double containerHeight = screenSize.height * 0.5;//MediaQuery.of(context).size.height; // 50% of screen height

    // Spacings
    final double sidebarSpace = screenSize.width * 0.1; // space from the NavigationRail
    final double buttonSpacing = screenSize.width * 0.005;
    final double buttonWidth   = screenSize.width * 0.07;
    final double buttonHeight  = screenSize.height * 0.05;

    

    return Scaffold(
      appBar: AppBar(
        title: Text('Tinder for Kids MADE BY RAYNE, FOR RAYNE'),
        centerTitle: true,
        elevation: 10,
      ),
      body: Row(
        children: [
          ChatStack(
            onChatSelected: (newIndex) {
              setState(() => _currentChatIndex = newIndex);
            },
            onNewChat: _handleNewChat,
          ),
          Expanded(
            child: MainContent(
              chatIndex: _currentChatIndex,
              onNewChat: _handleNewChat,
            ),
          ),
          // Main Content Area
          
        ],
      ),
    );
  }
}
