import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/artist_details_screen.dart';

class NearByScreen extends StatefulWidget {
  static const routeName = '/near-by-screen';

  @override
  _NearByScreenState createState() => _NearByScreenState();
}

class _NearByScreenState extends State<NearByScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).currentUser;
    final artists = Provider.of<Customer>(context).artists;
    final markers = artists
        .map(
          (artist) => Marker(
            infoWindow: InfoWindow(
              onTap: () {
                print('info tapped!');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return ArtistDetailsScreen(
                        artistId: artist.id,
                      );
                    },
                  ),
                );
              },
              title: artist.name,
              snippet: artist.categoryName,
            ),
            markerId: MarkerId(artist.id),
            position: LatLng(
              double.parse(artist.latitude),
              double.parse(artist.longitude),
            ),
          ),
        )
        .toSet();
    markers.add(
      Marker(
        markerId: MarkerId('user-location'),
        infoWindow: InfoWindow(title: user.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(
          double.parse(user.liveLat),
          double.parse(user.liveLong),
        ),
      ),
    );
    final appBar = AppBar(
      centerTitle: true,
      title: Text('Service'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: Container(
        height:
            MediaQuery.of(context).size.height - appBar.preferredSize.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
              target: LatLng(
                double.parse(user.liveLat),
                double.parse(user.liveLong),
              ),
              zoom: 14),
          onMapCreated: (GoogleMapController controller) {},
          markers: markers,
        ),
      ),
    );
  }
}
