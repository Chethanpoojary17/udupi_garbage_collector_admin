import 'package:flutter/material.dart';
import 'package:udupi_garbage_collector_admin/models/collectedGarbage.dart';
import 'package:udupi_garbage_collector_admin/models/user.dart';
import 'package:udupi_garbage_collector_admin/utils/getData.dart';

import '../models/collectedGarbage.dart';

class HomeBottomCard extends StatelessWidget {
  const HomeBottomCard({
    Key key,
    @required Size mediaQuery,
    @required GetData getData,
    @required DateTime date,
    @required List<User> user,
    @required List<CollectedGarbage> collectedGarbage,
  })  : _mediaQuery = mediaQuery,
        _getData = getData,
        _date = date,
        _collectedGarbage = collectedGarbage,
        _users = user,
        super(key: key);

  final Size _mediaQuery;
  final DateTime _date;
  final GetData _getData;
  final List<User> _users;
  final List<CollectedGarbage> _collectedGarbage;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        elevation: 8,
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Statistics",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  color: Theme.of(context).primaryColor,
                  thickness: 2,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Completed",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle),
                        child: Text(
                            "${_getData.completedLength(_date, _collectedGarbage)}",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Pending",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle),
                        child: Text(
                            "${_getData.incompleteLength(_date, _collectedGarbage, _users)}",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
