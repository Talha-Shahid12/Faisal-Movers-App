import 'package:faisal_movers/Components/CustomButton.dart';
import 'package:faisal_movers/Components/CustomTextField.dart';
import 'package:faisal_movers/Screens/BookSeats/seatBook.dart';
import 'package:faisal_movers/Screens/SignUp/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isSigningUp = false;

  void displaySnackMessage(String message, BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.orange,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> SignInUser(String? email, String? password, context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      String? message = "Login Successfull";

      if (message == "Login Successfull") {
        displaySnackMessage("Login SuccessFull", context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookSeats()),
        );
      } else {
        return debugPrint("There is an error occur in second function");
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      displaySnackMessage(e.message!, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: Image.asset('assets/images/comlogo.png'),
            ),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
            ),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
            CustomButton(
                text: "SignIn",
                onPressed: () async {
                  SignInUser(_emailController.text.trim(),
                      _passwordController.text.trim(), context);
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('New Here?', style: TextStyle(color: Colors.white)),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  child: Text(
                    '\tSignUp',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              ],
            ),
            Image.asset('assets/images/buslogo.png')
          ],
        ),
      ),
    );
  }
}
