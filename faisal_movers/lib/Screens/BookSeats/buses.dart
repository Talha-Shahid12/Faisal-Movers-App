import 'package:faisal_movers/Screens/BookSeats/seatBook.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusListScreen extends StatefulWidget {
  @override
  _BusListScreenState createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  final DatabaseReference userRef = FirebaseDatabase.instance.ref('Buses');
  List<Map<String, dynamic>> busList = []; // List to hold bus data

  @override
  void initState() {
    super.initState();
    _fetchBuses();
  }

  void _fetchBuses() async {
    try {
      DatabaseEvent event = await userRef.once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.exists) {
        List<Map<String, dynamic>> buses = [];
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          buses.add(Map<String, dynamic>.from(value));
        });

        setState(() {
          busList = buses;
        });
      } else {
        setState(() {
          busList = [];
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        busList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> bus;
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 19, 161, 161), //fromARGB(255, 19, 161, 161)
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 19, 161, 161),
        title: Text(
          'Select Bus',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Color.fromARGB(255, 17, 17, 29),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: busList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: busList.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      bus = busList[index];
                      String ind = bus['From'] + "-" + bus['To'];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookSeats(
                                index: ind,
                                from: bus['From'],
                                to: bus['To'],
                                departTime: bus['departTime'],
                                arrivalTime: bus['arrivalTime'],
                                ticketPrice: bus['ticketPrice'])),
                      );
                    },
                    child: BusCard(bus: busList[index]));
              },
            ),
    );
  }
}

class BusCard extends StatelessWidget {
  final Map<String, dynamic> bus;

  const BusCard({
    Key? key,
    required this.bus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Card(
          color: Color.fromARGB(255, 17, 17, 29), //fromARGB(255, 16, 16, 31)
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Image.asset('assets/images/buslogo.png'),
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bus['From'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 100, // Adjust the width as needed
                      child: Divider(
                        color: Colors.red, // Divider color
                        thickness: 4.0, // Divider thickness
                      ),
                    ),
                    Text(
                      bus['To'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bus['arrivalTime'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                        width: 100, // Adjust the width as needed
                        child: Icon(
                          Icons.timeline,
                          color: Colors.white,
                        )),
                    Text(
                      bus['departTime'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
