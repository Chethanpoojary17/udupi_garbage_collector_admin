import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:udupi_garbage_collector_admin/models/collectedGarbage.dart';
import 'package:udupi_garbage_collector_admin/models/user.dart';
import 'package:udupi_garbage_collector_admin/utils/getData.dart';
import 'package:udupi_garbage_collector_admin/widgets/home_bottom_card.dart';
import 'package:udupi_garbage_collector_admin/widgets/home_detail_card.dart';
import 'package:udupi_garbage_collector_admin/widgets/home_top_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  List<CollectedGarbage> collectedGarbage = [];
  List<User> users = [];
  Set<Marker> customMarkers = {};
  GetData _getData = GetData();
  DateTime _selectedDate = DateTime.now();
  CollectedGarbage selectedUser;

  bool isLoad = true;
  bool check = false;
  bool isMarkerClick = false;

  closeCard() {
    isMarkerClick = false;
    setState(() {});
  }

  changeDate(DateTime date) async {
    _selectedDate = date;
    customMarkers.clear();
    await _getData.addMarkers(collectedGarbage, customMarkers, _selectedDate,
        context, users, changeSelectedUser);
    closeCard();
  }

  changeSelectedUser(CollectedGarbage user) {
    print(user.time);
    isMarkerClick = true;
    selectedUser = user;
    setState(() {});
  }

  Future<void> getData() async {
    collectedGarbage.clear();
    customMarkers.clear();
    await _getData.getData(collectedGarbage, users);
    await _getData.addMarkers(collectedGarbage, customMarkers, _selectedDate,
        context, users, changeSelectedUser);
    setState(() {
      isLoad = false;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    if (!check) {
      check = !check;
      getData();
    }

    return Scaffold(
      body: isLoad
          ? Center(
              child: Container(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(users[0].lat),
                          double.parse(users[0].lon)),
                      zoom: 18),
                  markers: customMarkers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                HomeBottomCard(
                  mediaQuery: _mediaQuery,
                  date: _selectedDate,
                  getData: _getData,
                  collectedGarbage: collectedGarbage,
                  user: users,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HomeTopCard(changeDate, _selectedDate),
                    if (isMarkerClick) HomeDetailCard(selectedUser, closeCard),
                  ],
                ),
              ],
            ),
    );
  }
}
