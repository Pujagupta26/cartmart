import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants.dart';
import '../controllers/product_controller.dart';
import 'commonComponents/screen_title.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isEmailLogin = true;
  final ProductController controller = ProductController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: screenTitle('Login'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            ToggleButtons(
              children: [
                Text("FakeApi"),
                Text("Google"),
              ],
              isSelected: [isEmailLogin, !isEmailLogin],
              onPressed: (index) {
                setState(() {
                  isEmailLogin = index == 0;
                });
              },
            ),
            SizedBox(height: defaultPadding),
            isEmailLogin
                ? buildLoginForm("Username", false)
                : buildLoginForm("Email", true),
            SizedBox(height: defaultPadding),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'signup');
              },
              child: Text(
                "Don't have an account? Sign Up",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for building the login form
  Widget buildLoginForm(String hintText, bool isEmail) {
    return Column(
      children: [
        TextFormField(
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          textInputAction: TextInputAction.next,
          cursorColor: kPrimaryColor,
          controller: isEmail ? usernameController : usernameController,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: defaultPadding),
        TextFormField(
          textInputAction: TextInputAction.done,
          obscureText: true,
          cursorColor: kPrimaryColor,
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Your password",
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        SizedBox(height: defaultPadding),
        ElevatedButton(
          onPressed: () {
            isEmailLogin
                ? handleLogin(usernameController.text, passwordController.text)
                : handleGoogleLogin(
                    usernameController.text, passwordController.text);
          },
          child: Text(
            "Login".toUpperCase(),
          ),
        ),
        SizedBox(height: defaultPadding),
      ],
    );
  }

  // Function to handle login (with Fake API)
  Future<void> handleLogin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://fakestoreapi.com/auth/login'),
        body: jsonEncode({
          'username': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        if (token != null) {
          ProductController().fetchProducts(context);
        }
      } else if (response.statusCode == 401) {
        showAlertDialog(
            'Login Failed', 'Invalid email or password. Please try again.');
      } else {
        showAlertDialog('Error',
            'An error occurred while logging in. Please try again later.');
      }
    } catch (e) {
      showAlertDialog('Error',
          'An error occurred while logging in. Please try again later.');
    }
  }

  // Function to handle Google login
  Future<void> handleGoogleLogin(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      ProductController().fetchProducts(context);
    } catch (e) {
      showAlertDialog(
          'Login Failed', 'Invalid email or password. Please try again.');
    }
  }

  // Function to show an alert dialog with a given title and message
  void showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
