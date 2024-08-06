import 'package:faisal_movers/Components/CustomButton.dart';
import 'package:faisal_movers/Screens/BookSeats/buses.dart';
import 'package:faisal_movers/Screens/Confimation/confirmationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeatBookingScreen extends StatefulWidget {
  final index;
  final from;
  final to;
  final departTime;
  final arrivalTime;
  final ticketPrice;
  const SeatBookingScreen(
      {Key? key,
      required this.index,
      required this.from,
      required this.to,
      required this.departTime,
      required this.arrivalTime,
      required this.ticketPrice})
      : super(key: key);

  @override
  _SeatBookingScreenState createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  List<List<String>> seats =
      List.generate(11, (i) => List.filled(4, 'available'));
  late int selectedRow;
  late int selectedCol;
  String seatStatus = 'available'; // Track current status
  Set<int> bookedSeats = {}; // Use Set to avoid duplicates
  User? user = FirebaseAuth.instance.currentUser;
  String? fullname;
  String? phone;
  String? user_id;

  @override
  void initState() {
    super.initState();
    // fetchUserData();
  }

  void _handleSeatClick(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
      String currentStatus = seats[row][col];

      // Determine the next status
      seatStatus = _getNextStatus(currentStatus);

      if (seatStatus == 'available') {
        // Remove seat from bookedSeats if it was booked
        bookedSeats.remove(row * 4 + col);
        seats[row][col] = seatStatus;
      } else {
        if (_shouldShowConfirmationDialog(
            currentStatus, seatStatus, row, col)) {
          _showConfirmationDialog(row, col, seatStatus);
        } else {
          seats[row][col] = seatStatus;
          bookedSeats.add(row * 4 + col); // Add to bookedSeats if not available
        }
      }
    });
  }

  String _getNextStatus(String currentStatus) {
    switch (currentStatus) {
      case 'available':
        return 'male';
      case 'male':
        return 'female';
      case 'female':
        return 'available';
      default:
        return 'available';
    }
  }

  bool _shouldShowConfirmationDialog(
      String currentStatus, String nextStatus, int row, int col) {
    if (nextStatus == 'male' &&
        _isAdjacentSeatBookedByGender('female', row, col)) {
      return true;
    } else if (nextStatus == 'female' &&
        _isAdjacentSeatBookedByGender('male', row, col)) {
      return true;
    }
    return false;
  }

  bool _isAdjacentSeatBookedByGender(String gender, int row, int col) {
    if (col > 0 && seats[row][col - 1] == gender) return true;
    if (col < seats[row].length - 1 && seats[row][col + 1] == gender)
      return true;
    return false;
  }

  void _showConfirmationDialog(int row, int col, String newStatus) {
    String adjacentGender = _getAdjacentSeatGender(row, col);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Status Change'),
          content: Text(
              'The adjacent seat is booked by $adjacentGender. Do you want to proceed with booking this seat as $newStatus?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                setState(() {
                  seats[selectedRow][selectedCol] = newStatus;
                  if (newStatus != 'available') {
                    bookedSeats.add(selectedRow * 4 +
                        selectedCol); // Add to bookedSeats if not available
                  } else {
                    bookedSeats.remove(selectedRow * 4 +
                        selectedCol); // Remove from bookedSeats if available
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                // Reset the status to its previous state if cancelled
                setState(() {
                  seats[selectedRow][selectedCol] = _getNextStatus(seatStatus);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getAdjacentSeatGender(int row, int col) {
    if (col > 0 && seats[row][col - 1] != 'available') {
      return seats[row][col - 1];
    } else if (col < seats[row].length - 1 &&
        seats[row][col + 1] != 'available') {
      return seats[row][col + 1];
    }
    return 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 129, 175, 197),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 129, 175, 197),
        title: Text(
          "Select Seats",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Color.fromARGB(255, 17, 17, 29),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ...seats.asMap().entries.map((entry) {
                int row = entry.key;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...entry.value.asMap().entries.map((seatEntry) {
                      int col = seatEntry.key;
                      String status = seatEntry.value;

                      Color seatColor;
                      if (status == 'male') {
                        seatColor = Color.fromARGB(255, 57, 60, 228);
                      } else if (status == 'female') {
                        seatColor = const Color.fromARGB(255, 184, 33, 83);
                      } else {
                        seatColor = Color.fromARGB(255, 17, 17, 29);
                      }

                      Widget seatIcon = Padding(
                        padding: const EdgeInsets.all(
                            8.0), // Adjust padding as needed
                        child: InkWell(
                          onTap: () {
                            _handleSeatClick(row, col);
                          },
                          child: Icon(
                            Icons.event_seat,
                            color: seatColor,
                            size: 40,
                          ),
                        ),
                      );

                      // Add space after the first 2 columns
                      if (col == 1) {
                        return Row(
                          children: [
                            seatIcon,
                            SizedBox(width: 50), // Adjust the width as needed
                          ],
                        );
                      } else {
                        return seatIcon;
                      }
                    }).toList(),
                  ],
                );
              }).toList(),
              CustomButton(
                text: "Next",
                onPressed: () async {
                  if (bookedSeats.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Confirmationscreen(
                                bookedSeats: bookedSeats,
                                index: widget.index,
                                from: widget.from,
                                to: widget.to,
                                departTime: widget.departTime,
                                arrivalTime: widget.arrivalTime,
                                ticketPrice: widget.ticketPrice,
                              )),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("You have to must select at least one seat"),
                      ),
                    );
                  }
                },
                width: 300.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
