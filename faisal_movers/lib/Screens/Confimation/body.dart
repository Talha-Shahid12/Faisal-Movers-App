// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:faisal_movers/Components/CustomButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Body extends StatefulWidget {
  @override
  final index;
  final Set<int> bookedSeats;
  final from;
  final to;
  final departTime;
  final arrivalTime;
  final ticketPrice;
  Body(
      {Key? key,
      required this.index,
      required this.bookedSeats,
      required this.from,
      required this.to,
      required this.departTime,
      required this.arrivalTime,
      required this.ticketPrice})
      : super(key: key);
  State<Body> createState() => _Body();
}

class _Body extends State<Body> {
  String? fullname;
  String? phone;
  String? user_id;
  User? user = FirebaseAuth.instance.currentUser;
  String? bookingID;

  // Get the first 4 digits

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final DatabaseReference userRef =
          FirebaseDatabase.instance.ref('User/$uid');
      try {
        final snapshot = await userRef.get();
        if (snapshot.exists) {
          final userData = snapshot.value as Map<dynamic, dynamic>;
          setState(() {
            fullname = userData['firstName'] + " " + userData['lastName'];
            phone = userData['phone'];
            user_id = uid;
          });
          bookingID =
              "${fullname!.substring(0, 5)}${phone!.substring(phone!.length - 4)} ";
        } else {
          print('No user data available for UID: $uid');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('No authenticated user found');
    }
  }

  Future<void> createBooking(String? full_name, String? phone) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final DatabaseReference bookingRef =
          FirebaseDatabase.instance.ref('Bookings/$uid');
      String? buss;

      final DatabaseReference busRef =
          FirebaseDatabase.instance.ref('Buses/${widget.index}/Seats');

      if (phone!.isNotEmpty &&
          full_name!.isNotEmpty &&
          user_id!.isNotEmpty &&
          widget.bookedSeats.isNotEmpty) {
        try {
          // Update booking information
          await bookingRef.set({
            'fullName': full_name,
            'phone': phone,
            'bookedSeats':
                widget.bookedSeats.toList(), // Convert Set to List for Firebase
          });

          // Update seat status in Buses node
          Map<String, bool> seatUpdates = {};
          for (var seat in widget.bookedSeats) {
            seatUpdates[seat.toString()] = true; // Set the seat status to true
          }
          await busRef.update(seatUpdates);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking Created Successfully')),
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => Confirmationscreen()),
          // );
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add bookings: $error')),
          );
        }
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
    DateTime now = DateTime.now();
    String formattedDateTime = '${now.day} / ${now.month} / ${now.year}';
    String f_name = fullname ?? "User12345";

    List<int> ticketNo = widget.bookedSeats.toList();
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 129, 175, 197),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Confirm Booking",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Color.fromARGB(255, 17, 17, 29),
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 129, 175, 197),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.departTime,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.radio_button_off_rounded,
                      size: 12,
                    ),
                    Text(
                      widget.from,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 130, // Adjust the width as needed
                  child: Divider(
                    color:
                        const Color.fromARGB(255, 155, 82, 76), // Divider color
                    thickness: 4.0, // Divider thickness
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.arrivalTime,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.radio_button_on_rounded,
                      size: 15,
                    ),
                    Text(
                      widget.to,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Card(
              color: Color.fromARGB(255, 17, 17, 29),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Color.fromARGB(255, 129, 175, 197),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "$fullname",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Color.fromARGB(255, 129, 175, 197),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              formattedDateTime,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          "Booking ID : ",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Color.fromARGB(255, 129, 175, 197),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          bookingID ?? "xyz1234",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 300, // Adjust the width as needed
                    child: Divider(
                      color: const Color.fromARGB(
                          255, 155, 82, 76), // Divider color
                      thickness: 2.0, // Divider thickness
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "No of tickets",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Color.fromARGB(255, 129, 175, 197),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${widget.bookedSeats.length}',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 90,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/ticket.png'),
                                // fit: BoxFit
                                //     .cover, // Adjusts the image to cover the container
                              ),
                            ),
                          ),
                          // Overlay text on top of the image

                          Text(
                            bookingID ?? "xyz1234",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ticket Numbers",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Color.fromARGB(255, 129, 175, 197),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 50.0, // Set a fixed height for the ListView
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ticketNo.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 80.0, // Adjust the width as needed
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Icon as the background
                                    Icon(
                                      Icons.event_seat,
                                      size: 50.0, // Adjust the size as needed
                                      color: Color.fromARGB(
                                          255, 155, 82, 76), // Icon color
                                    ),
                                    // Number on top of the icon
                                    Center(
                                      child: Text(
                                        '${ticketNo[index]}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 300, // Adjust the width as needed
                    child: Divider(
                      color: const Color.fromARGB(
                          255, 155, 82, 76), // Divider color
                      thickness: 2.0, // Divider thickness
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Total Payable",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Color.fromARGB(255, 129, 175, 197),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'PKR ${widget.ticketPrice * widget.bookedSeats.length}',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 100),
          CustomButton(text: "Confirm Booking", onPressed: () {})
        ],
      )),
    );
  }
}
