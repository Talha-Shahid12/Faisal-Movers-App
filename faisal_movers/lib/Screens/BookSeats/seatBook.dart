import 'package:faisal_movers/Screens/BookSeats/Components/seatList.dart';
import 'package:flutter/material.dart';

class BookSeats extends StatefulWidget {
  final index; // Assuming index is of type int
  final from;
  final to;
  final departTime;
  final arrivalTime;
  final ticketPrice;
  BookSeats(
      {Key? key,
      required this.index,
      required this.from,
      required this.to,
      required this.departTime,
      required this.arrivalTime,
      required this.ticketPrice})
      : super(key: key); // Properly pass the index to the State class

  @override
  State<BookSeats> createState() =>
      _BookSeatsState(); // Correctly reference the State class
}

class _BookSeatsState extends State<BookSeats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SeatBookingScreen(
        index: widget.index,
        from: widget.from,
        to: widget.to,
        departTime: widget.departTime,
        arrivalTime: widget.arrivalTime,
        ticketPrice: widget.ticketPrice,
      ), // Ensure this widget is properly imported and defined
    );
  }
}
