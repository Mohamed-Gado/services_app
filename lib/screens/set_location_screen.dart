import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetLocationScreen extends StatefulWidget {
  static const routeName = '/set-location-screen';
  final double longi;
  final double lati;
  const SetLocationScreen({
    Key key,
    this.lati = 40.712776,
    this.longi = -74.005974,
  }) : super(key: key);
  @override
  _SetLocationScreenState createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  String location = '';
  String long = '';
  String lat = '';
  LatLng _pickedLocation;
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Location'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildGoogleMap(context),
          _buildContainer(context),
        ],
      ),
    );
  }

  Widget _buildContainer(BuildContext ctx) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 120,
        width: MediaQuery.of(ctx).size.width - 20.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Text(location),
          trailing: CircleAvatar(
            backgroundColor: Theme.of(ctx).primaryColor,
            radius: 25,
            child: IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () {
                if (location == null || location == '') {
                  return;
                }
                Navigator.of(ctx).pop([location, lat, long]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext ctx) {
    return Container(
      height: MediaQuery.of(ctx).size.height,
      width: MediaQuery.of(ctx).size.width,
      child: GoogleMap(
        onTap: (position) async {
          try {
            setState(() {
              _pickedLocation = position;
            });
            final newPlace = await placemarkFromCoordinates(
                position.latitude, position.longitude,
                localeIdentifier: 'en_US');
            lat = '${position.latitude}';
            long = '${position.longitude}';
            setState(() {
              location =
                  '${newPlace[0].name}, ${newPlace[0].subLocality}, ${newPlace[0].locality},${newPlace[0].administrativeArea},${newPlace[0].country}';
            });
            print('new place: $location');
          } catch (err) {
            print(err);
          }
        },
        zoomControlsEnabled: false,
        initialCameraPosition:
            CameraPosition(target: LatLng(widget.lati, widget.longi), zoom: 14),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(
            draggable: true,
            onDragEnd: (position) async {
              try {
                setState(() {
                  _pickedLocation = position;
                });
                final newPlace = await placemarkFromCoordinates(
                    position.latitude, position.longitude,
                    localeIdentifier: 'en_US');
                lat = '${position.latitude}';
                long = '${position.longitude}';
                setState(() {
                  location =
                      '${newPlace[0].name}, ${newPlace[0].subLocality}, ${newPlace[0].locality},${newPlace[0].administrativeArea},${newPlace[0].country}';
                });
                print('new place: $location');
              } catch (err) {
                print(err);
              }
            },
            markerId: MarkerId('user-location'),
            position: _pickedLocation == null
                ? LatLng(widget.lati, widget.longi)
                : _pickedLocation,
          ),
        },
      ),
    );
  }
}
