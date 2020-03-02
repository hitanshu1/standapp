import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final IconData icons;
  final String names;
  SettingsCard({this.icons, this.names});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        height: MediaQuery.of(context).size.width / 6,
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 20, right: 10),
                      child: (Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(icons, size: 30, color: Colors.black54),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            names,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ))))
            ])));
  }
}
