import 'package:flutter/material.dart';
import 'package:myhours_logapp/constraints.dart';

class CustomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        color: Colors.black12,
        child: InkWell(
          onTap: () {},
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.home,
                      color: Theme.of(context).accentColor),
                    Text(homeLabel),
                  ],
                ),
            ),
          ),
        ),
    );
  }
}
