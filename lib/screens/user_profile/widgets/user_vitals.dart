import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';


class UserVitals extends StatefulWidget {
  @override
  _UserVitalsState createState() => _UserVitalsState();
}

class _UserVitalsState extends State<UserVitals> {
  _cardWithTextForm({String typeName, String measureType, String textResult}) {
    return Material(
        shadowColor: Colors.blueAccent,
        elevation: 8.0,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        type: MaterialType.card,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeText(
                  typeName,
                  presetFontSizes: [18, 16, 14],
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 90,
                  child: TextFormField(
                    enabled: false,
                    initialValue: textResult,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  measureType,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ));
  }
  bool _showVitals = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Material(
        shadowColor: Colors.blueAccent,
        elevation: 8.0,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        type: MaterialType.card,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    setState(() {
                      _showVitals = !_showVitals;
                    });
                  },
                  child:
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Vitals",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        Icon(
                          _showVitals
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 25,
                        ),
                      ],
                    ),
                  )),
            ),
            _showVitals?Divider(
              color: Colors.grey,
              height: 4,
            ):SizedBox(),
            _showVitals
                ? Padding(
              padding: const EdgeInsets.only(bottom: 8.0,left: 15,right: 15,top: 6.0),
              child:  Container(
                  height: 280,
                  //width: double.infinity,
                  child: GridView(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.4,
                        crossAxisSpacing: 8),
                    children: <Widget>[
                      _cardWithTextForm(
                          typeName: 'BloodPressure',
                          measureType: 'mmHg',
                          textResult: '120/56'),
                      _cardWithTextForm(
                          typeName: 'PlusRate',
                          measureType: 'bpm',
                          textResult: '55'),
                      _cardWithTextForm(
                          typeName: 'OxygenSaturation',
                          measureType: '%',
                          textResult: '80'),
                      _cardWithTextForm(
                          typeName: 'RespiratoryRate',
                          measureType: 'br/min',
                          textResult: '60'),
                    ],
                  ))
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
