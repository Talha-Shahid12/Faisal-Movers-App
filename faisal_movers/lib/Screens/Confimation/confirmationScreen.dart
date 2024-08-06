import 'package:faisal_movers/Screens/Confimation/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Confirmationscreen extends StatefulWidget {
  @override
  final index;
  final from;
  final to;
  final departTime;
  final arrivalTime;
  final ticketPrice;
  final Set<int> bookedSeats;
  Confirmationscreen(
      {Key? key,
      required this.index,
      required this.bookedSeats,
      required this.from,
      required this.to,
      required this.departTime,
      required this.arrivalTime,
      required this.ticketPrice})
      : super(key: key);
  State<Confirmationscreen> createState() => _Confirmationscreen();
}

class _Confirmationscreen extends State<Confirmationscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Body(
          index: widget.index,
          bookedSeats: widget.bookedSeats,
          from: widget.from,
          to: widget.to,
          departTime: widget.departTime,
          arrivalTime: widget.arrivalTime,
          ticketPrice: widget.ticketPrice,
        ));
  }
}
