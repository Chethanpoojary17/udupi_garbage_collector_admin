import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:udupi_garbage_collector_admin/models/garbageCollector.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<GoogleMapStateBase> _key = GlobalKey<GoogleMapStateBase>();

  List<GarbageCollector> _gCollector = [];
  List<Marker> customMarkers = [];

  Future<void> getData() async {
    _gCollector.clear();
    customMarkers.clear();
    final response = await http
        .get("https://www.xtoinfinity.tech/GCUdupi/admin/php/getAll.php");
    final data = json.decode(response.body);
    print(response.body);
    List gCollectorData = data["locations"];
    gCollectorData.map((e) {
      customMarkers.add(
          Marker(GeoCoord(double.parse(e["lat"]), double.parse(e["lon"]))));
      _gCollector.add(GarbageCollector(
        gcId: e["userId"],
        lat: e["lat"],
        long: e["lon"],
        time: e["date"],
      ));
    }).toList();
    return;
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<Object>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  GoogleMap(
                    key: _key,
                    initialPosition: GeoCoord(double.parse(_gCollector[0].lat),
                        double.parse(_gCollector[0].long)),
                    initialZoom: 15,
                    markers: customMarkers.toSet(),
                  ),
                  BottomCard(mediaQuery: _mediaQuery, gCollector: _gCollector)
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class BottomCard extends StatelessWidget {
  const BottomCard({
    Key key,
    @required Size mediaQuery,
    @required List<GarbageCollector> gCollector,
  })  : _mediaQuery = mediaQuery,
        _gCollector = gCollector,
        super(key: key);

  final Size _mediaQuery;
  final List<GarbageCollector> _gCollector;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        elevation: 8,
        child: Container(
          padding: EdgeInsets.all(10),
          height: _mediaQuery.height * 0.15,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Colors.blue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Total Houses",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(_gCollector.length.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center),
              )
            ],
          ),
        ),
      ),
    );
  }
}
