import 'package:faisal_movers/Screens/body.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  final TextEditingController phoneNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Body());
  }
}
