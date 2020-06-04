import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:phr/list_of_infomation/list_of_information.dart';
import 'package:phr/screens/specific_search/map.dart';
import 'package:phr/screens/specific_search/search_result.dart';
import './search_card.dart';
class SpecificSearch extends StatefulWidget {
  @override
  _SpecificSearchState createState() => _SpecificSearchState();
}

class _SpecificSearchState extends State<SpecificSearch> {
  String _drName = '';

  String _location = '';
  TextEditingController _locationTextEditingController =
  TextEditingController();
  bool _isEditLocationEnable = false;
  bool _selectUserLocationFromMap = false;
  FocusNode _governorateFocusNode =FocusNode();

  String _specialty;

  String _governorate;

  Future<void> _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates =
    new Coordinates(position.latitude, position.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
//      _accountData['lat'] = position.latitude.toString();
//      _accountData['long'] = position.longitude.toString();
    if(addresses.isNotEmpty){
      setState(() {
        _locationTextEditingController.text = addresses.first.addressLine;
        _isEditLocationEnable = true;
        _selectUserLocationFromMap = !_selectUserLocationFromMap;
      });
      Navigator.of(context).pop();
    }
  }


  void selectLocationFromTheMap(String address, double lat, double long) {
      setState(() {
        _locationTextEditingController.text = address;
      });
      _location = address;
//      _accountData['lat'] = lat.toString();
//      _accountData['long'] = long.toString();
  }

  void selectUserLocationType() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        title: Text(
          'Location',
          textAlign: TextAlign.center,
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: _getUserLocation,
                  child: Material(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      type: MaterialType.card,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Get current Location',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => GetUserLocation(
                          getAddress: selectLocationFromTheMap,
                        )));
                    setState(() {
                      _isEditLocationEnable = true;
                      _selectUserLocationFromMap =
                      !_selectUserLocationFromMap;
                    });
                  },
                  child: Material(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      type: MaterialType.card,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Select Location from Map',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  _getSpecialtySelected(String x) {
    _specialty = x;
    print(x);print(_specialty);

  }

  _getGovernorateSelected(String x) {
    _governorate = x;
    print(x);print(_governorate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,),
      child:
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height*0.10,),
        FittedBox(
        child: Container(
            width: MediaQuery.of(context).size.width*0.71,
        child: Text(
         'Search By All Options or choice one or two of Them'
          ,maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),SizedBox(height: 10,),

            Container(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Dr /name',
                  focusedBorder: OutlineInputBorder(
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
                keyboardType: TextInputType.text,
// ignore: missing_return
                validator: (value) {
                  if (value.isEmpty || value.length < 2) {
                    return "Invalid Dr Name!";
                  }
                },
                onSaved: (value) {
                  _drName = value.trim();
                },
                onFieldSubmitted: (_) {
                  print(_specialty);
                  print(_governorate);
                  FocusScope.of(context).requestFocus(_governorateFocusNode);
                },
              ),
            ),
            SizedBox(height: 10,),
            InkWell(
                onTap: selectUserLocationType,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7.0),
                  height: 70,
                  child: TextFormField(
                    style: TextStyle(fontSize: 15),
                    controller: _locationTextEditingController,
                    textInputAction: TextInputAction.done,
                    enabled: _isEditLocationEnable,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: selectUserLocationType,
                        child: Icon(
                          Icons.my_location,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      labelText: 'Location',
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                )),
            SpecialtyAndGovernrateCard(
              name: 'Specialty',
              listData: listSpecialty,
              selected: _getSpecialtySelected,
            ),
            SpecialtyAndGovernrateCard(
              name: 'Governorate',
              listData: governorateList,
              selected: _getGovernorateSelected,
            ),
            InkWell(
              onTap: (){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchResult()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue,
                        blurRadius: 10.0, // has the effect of softening the shadow
                        spreadRadius: 1.0, // has the effect of extending the shadow

                      )
                    ]
                    ,color: Colors.blue
                    ,borderRadius: BorderRadius.circular(10.0)),
                child:  Center(
                  child: Text(
                    'Search',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
