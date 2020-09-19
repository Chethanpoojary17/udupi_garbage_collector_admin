import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeTopCard extends StatefulWidget {
  final Function changeDate;
  final DateTime date;

  HomeTopCard(this.changeDate, this.date);

  @override
  _HomeTopCardState createState() => _HomeTopCardState();
}

class _HomeTopCardState extends State<HomeTopCard> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != widget.date) widget.changeDate(picked);
  }

  String convertDate() {
    String date = DateFormat.yMEd().format(widget.date).toString();
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        child: SafeArea(
          child: InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                            text: "Selected Date: ",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: "${convertDate()}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
