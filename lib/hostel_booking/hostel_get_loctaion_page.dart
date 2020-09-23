import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class GetLocationPage extends StatefulWidget {
  @override
  _GetLocationPageState createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State<GetLocationPage> {
//  DirectionsService.init('API_KEY');
  String textToShow = 'Setting Up....';
  String distance;
  String duration;
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  String apiKey = 'AIzaSyBHxUKxPLl8cAgGGq-Be9fjsV1ruV3W9iE';
  Map<String, double> destination = {'lat': 8.480339, 'long': 4.637326};

  Future<void> getUserLatAndLong() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    if (mounted) {
      setState(() {
        textToShow = 'Connecting To server...';
      });
    }

    try {
      _locationData = await location.getLocation();
      print(_locationData);
      if (mounted) {
        setState(() {
          textToShow = 'User Location Gotten.. \n $_locationData';
        });
      }
      getRouteCoordinates(
        originLat: _locationData.latitude,
        originLong: _locationData.longitude,
      );
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          textToShow = 'Error: $e';
        });
      }
    }
  }

  Future<void> getRouteCoordinates({
    @required double originLat,
    @required double originLong,
  }) async {
    if (mounted) {
      setState(() {
        textToShow = 'Calculating Distance......';
      });
    }

    String url = "https://maps.googleapis.com/maps/api/directions/json?origin"
        "=$originLat,$originLong&destination=${destination['lat']},"
        "${destination['long']}&key=$apiKey";

    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
//    print(values);
    print(values['routes'][0]['legs'][0]['distance']);
    print(values['routes'][0]['legs'][0]['duration']);
    if (mounted) {
      setState(() {
        distance = values['routes'][0]['legs'][0]['distance']['text'];
        duration = values['routes'][0]['legs'][0]['duration']['text'];
        textToShow = values['routes'][0]['legs'][0]['distance'].toString();
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserLatAndLong();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: (distance == null && duration == null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(child: CircularProgressIndicator()),
                    Center(
                      child: Text(
                        '$textToShow',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Distance: $distance',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Duration: $duration',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}
