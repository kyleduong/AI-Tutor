import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  
  // Controllers for email + password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Track loading to disable buttons while auth in progress
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Attempt sign-in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Get UID AFTER successful sign-in
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Signed in UID: ${user.uid}');
        // You could also navigate to a new screen here
      }

      // On success, authStateChanges will cause StreamBuilder to show HomeScreen
    } on FirebaseAuthException catch (e) {
        if (!mounted) return;  // If widget's gone, skip
      setState(() => _errorMessage = "Incorrect email or password");//e.message);
    } finally {
    if (!mounted) return;  // If widget's gone, skip
      setState(() => _isLoading = false);
    }
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Attempt sign-up
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Get UID AFTER successful registration
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Signed in UID: ${user.uid}');
        // You could also navigate to a new screen here
      }

      // On success, user is also signed in automatically
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = "Email or password already in Use" );//e.message);
    } finally {
    if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

    
    


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In / Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                if (_isLoading) 
                  const CircularProgressIndicator(),
                if (!_isLoading) ...[
                  ElevatedButton(
                    onPressed: _signIn,
                    child: const Text('Sign In'),
                  ),
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Register'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}