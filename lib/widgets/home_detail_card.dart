import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:udupi_garbage_collector_admin/models/collectedGarbage.dart';

class HomeDetailCard extends StatefulWidget {
  final CollectedGarbage selectedUser;
  final Function closeCard;

  HomeDetailCard(this.selectedUser, this.closeCard);

  @override
  _HomeDetailCardState createState() => _HomeDetailCardState();
}

class _HomeDetailCardState extends State<HomeDetailCard> {
  String convertDate() {
    if (widget.selectedUser.time == "") {
      return "Yet to collect";
    }
    final date = "Collected Time: " +
        DateFormat.jm().format(DateTime.parse(widget.selectedUser.time));
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: ListTile(
          trailing: GestureDetector(
              onTap: () {
                widget.closeCard();
              },
              child: Icon(Icons.close)),
          leading: Image.asset(
            widget.selectedUser.time != ""
                ? "assets/images/map_complete.png"
                : "assets/images/map_incomplete.png",
            height: 25,
            width: 25,
          ),
          title: RichText(
            text:
                TextSpan(style: DefaultTextStyle.of(context).style, children: [
              TextSpan(text: "User ID: "),
              TextSpan(
                  text: "${widget.selectedUser.userId}",
                  style: TextStyle(color: Theme.of(context).primaryColor))
            ]),
          ),
          subtitle: Text("${convertDate()}"),
        ));
  }
}
