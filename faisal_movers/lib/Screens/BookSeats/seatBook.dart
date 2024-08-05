import 'package:faisal_movers/Screens/BookSeats/Components/seatList.dart';
import 'package:flutter/material.dart';

class BookSeats extends StatefulWidget {
  @override
  State<BookSeats> createState() => _BookSeats();
}

class _BookSeats extends State<BookSeats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SeatBookingScreen());
  }
}
