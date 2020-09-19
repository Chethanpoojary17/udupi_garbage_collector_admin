import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:udupi_garbage_collector_admin/models/collectedGarbage.dart';
import 'package:udupi_garbage_collector_admin/models/user.dart';

class GetData {
  Future<void> getData(List<CollectedGarbage> _cB, List<User> _users) async {
    final response = await http
        .get("https://www.xtoinfinity.tech/GCUdupi/admin/php/getAll.php");
    final jsonResponse = json.decode(response.body);
    final allData = jsonResponse['allData'];
    List collectGarbageData = allData["locations"];
    List userData = allData["users"];

    collectGarbageData.map((e) {
      return _cB.add(CollectedGarbage(
        id: e['id'],
        userId: e["userId"],
        lat: e["lat"],
        lon: e["lon"],
        time: e["time"],
      ));
    }).toList();

    userData.map((e) {
      return _users.add(User(
        id: e['id'],
        userId: e["user_id"],
        lat: e["lat"],
        lon: e["lon"],
      ));
    }).toList();

    return;
  }

  Future<void> addMarkers(
      List<CollectedGarbage> cb,
      Set<Marker> cm,
      DateTime todayDate,
      BuildContext context,
      List<User> users,
      Function changeSelectedUser) async {
    //create map icon
    BitmapDescriptor completeIcon, incompleteIcon;
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    completeIcon = await BitmapDescriptor.fromAssetImage(
        configuration, 'assets/images/map_complete.png');
    incompleteIcon = await BitmapDescriptor.fromAssetImage(
        configuration, 'assets/images/map_incomplete.png');

    //create list of all garbage collected today
    List<CollectedGarbage> todayList = [];
    cb.map((e) {
      DateTime _date = DateTime.parse(e.time);
      if (todayDate.year == _date.year &&
          todayDate.month == _date.month &&
          todayDate.day == _date.day) {
        todayList.add(e);
      }
    }).toList();

    //iterate through all users and check if their garbage is collected on the day
    users.map((e) {
      //flag is 0 if garbage not collected
      int flag = 0;
      CollectedGarbage tempCb;
      todayList.map((f) {
        if (f.id == e.id) {
          tempCb = f;
          flag = 1;
        }
      }).toList();

      if (flag == 0) {
        cm.add(
          Marker(
              markerId: MarkerId(e.userId),
              position: LatLng(
                double.parse(e.lat),
                double.parse(e.lon),
              ),
              icon: incompleteIcon,
              onTap: () {
                changeSelectedUser(CollectedGarbage(
                    id: e.id,
                    lat: e.lat,
                    lon: e.lon,
                    time: "",
                    userId: e.userId));
              }),
        );
      } else {
        cm.add(
          Marker(
              markerId: MarkerId(e.userId),
              position: LatLng(
                double.parse(e.lat),
                double.parse(e.lon),
              ),
              icon: completeIcon,
              onTap: () => changeSelectedUser(tempCb)),
        );
      }
    }).toList();
    return;
  }

  String completedLength(DateTime todayDate, List<CollectedGarbage> cb) {
    List<CollectedGarbage> todayList = [];
    cb.map((e) {
      DateTime _date = DateTime.parse(e.time);
      if (todayDate.year == _date.year &&
          todayDate.month == _date.month &&
          todayDate.day == _date.day) {
        todayList.add(e);
      }
    }).toList();

    return todayList.length.toString();
  }

  String incompleteLength(
      DateTime todayDate, List<CollectedGarbage> cb, List<User> users) {
    List<CollectedGarbage> todayList = [];
    cb.map((e) {
      DateTime _date = DateTime.parse(e.time);
      if (todayDate.year == _date.year &&
          todayDate.month == _date.month &&
          todayDate.day == _date.day) {
        todayList.add(e);
      }
    }).toList();

    return (users.length - todayList.length).toString();
  }
}
