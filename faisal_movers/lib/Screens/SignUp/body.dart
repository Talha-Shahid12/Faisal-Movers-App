import 'package:faisal_movers/Components/CustomButton.dart';
import 'package:faisal_movers/Components/CustomTextField.dart';
import 'package:faisal_movers/Screens/SignIn/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _Body();
}

class _Body extends State<Body> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  final DatabaseReference _database = FirebaseDatabase.instance
      .ref('User/${FirebaseAuth.instance.currentUser!.uid}');
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

  Future<void> RegisterUser(String? first_name, String? last_name,
      String? phone, String? email, String? password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      String? message = "Account Created Successfully";

      if (message == "Account Created Successfully") {
        createUser(first_name, last_name, phone, email, password);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      } else {
        return debugPrint("There is an error occur in second function");
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      displaySnackMessage(e.message!, context);
    }
  }

  Future<void> createUser(String? first_name, String? last_name, String? phone,
      String? email, String? password) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final DatabaseReference userRef =
          FirebaseDatabase.instance.ref('User/$uid');
      if (phone!.isNotEmpty &&
          password!.isNotEmpty &&
          first_name!.isNotEmpty &&
          last_name!.isNotEmpty &&
          email!.isNotEmpty) {
        userRef.set({
          'firstName': first_name,
          'lastName': last_name,
          'email': email,
          'phone': phone,
          'password': password
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account Created Successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add user data: $error')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No field should be empty')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No authenticated user found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Card(
                elevation: 5, // Shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.asset(
                          'assets/images/buslogo.png', // Replace with your image path
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                )),
            CustomTextField(
                controller: _firstNameController, labelText: "First Name"),
            CustomTextField(
                controller: _lastNameController, labelText: "Last Name"),
            CustomTextField(controller: _phoneController, labelText: "Phone"),
            CustomTextField(controller: _emailController, labelText: "Email"),
            CustomTextField(
                controller: _passwordController, labelText: "Password"),
            CustomTextField(
                controller: _rePasswordController,
                labelText: "Re-Enter Password"),
            CustomButton(
                text: "SignUp",
                onPressed: () {
                  if (_phoneController.text.trim().isNotEmpty &&
                      _passwordController.text.trim().isNotEmpty &&
                      _firstNameController.text.trim().isNotEmpty &&
                      _lastNameController.text.trim().isNotEmpty &&
                      _emailController.text.trim().isNotEmpty) {
                    RegisterUser(
                        _firstNameController.text.trim(),
                        _lastNameController.text.trim(),
                        _phoneController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim());
                  } else {
                    setState(() {
                      Text("Empty");
                    });
                  }
                })
          ],
        )));
  }
}
