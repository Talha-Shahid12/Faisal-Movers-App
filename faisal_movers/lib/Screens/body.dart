import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _Body();
}

class _Body extends State<Body> {
  final TextEditingController phoneNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '\n\n\tBus Travel\n Made \n\tSafe And Easy',
              style: TextStyle(
                  color: const Color.fromARGB(255, 235, 109, 100),
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            Container(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/buslogo.png')),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: phoneNo,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: phoneNo,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder()),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              width: 300,
              height: 80,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    onPressed: () {},
                    child: Text(
                      'SignIn',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('New Here?', style: TextStyle(color: Colors.white)),
                Text(
                  '\tSignUp',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue,
                      fontStyle: FontStyle.italic),
                )
              ],
            )
          ],
        )));
  }
}
