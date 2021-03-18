import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/set_location_screen.dart';

class BookArtistScreen extends StatefulWidget {
  final double price;
  final String currency;
  final String artistId;
  final String artistName;
  final String artistImage;
  final String artistCat;
  final String selectedList;
  const BookArtistScreen({
    Key key,
    this.artistCat,
    this.artistImage,
    this.artistName,
    this.currency,
    this.price,
    this.selectedList,
    @required this.artistId,
  }) : super(key: key);

  @override
  _BookArtistScreenState createState() => _BookArtistScreenState();
}

class _BookArtistScreenState extends State<BookArtistScreen> {
  String address = '';
  String lati;
  String longi;
  final TextEditingController _dateController = TextEditingController(
      text:
          '${DateFormat.yMd().format(DateTime.now())} ${DateFormat.jm().format(DateTime.now())}');
  @override
  Widget build(BuildContext context) {
    if (address.isEmpty) {
      address = Provider.of<Auth>(context).currentUser.address;
      lati = Provider.of<Auth>(context).currentUser.lat;
      longi = Provider.of<Auth>(context).currentUser.long;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Information'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(false),
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  children: [
                    ListTile(
                      leading: Image.network(widget.artistImage),
                      title: Text(widget.artistName),
                      subtitle: Text(widget.artistCat),
                    ),
                    Divider(),
                    Text('Booking Price'),
                    Text('${widget.currency}${widget.price}'),
                  ],
                ),
              ),
            ),
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  children: [
                    Text('Booking Date'),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          DatePicker.showDateTimePicker(
                            context,
                            showTitleActions: true,
                            currentTime: DateTime.now(),
                            onConfirm: (time) {
                              final String formatted =
                                  '${DateFormat.yMd().format(time)} ${DateFormat.jm().format(time)}';
                              setState(() {
                                _dateController.text = formatted;
                              });
                              print(formatted);
                            },
                          );
                        },
                        child: TextFormField(
                          controller: _dateController,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            icon: Icon(Icons.date_range),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Text('Booking Address'),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.of(context)
                              .pushNamed(SetLocationScreen.routeName)
                              .then((value) {
                            List<String> values = value;
                            setState(() {
                              address = values[0];
                              lati = values[1];
                              longi = values[2];
                            });
                          });
                        },
                        child: TextFormField(
                          initialValue: address,
                          enabled: false,
                          onSaved: (value) {
                            address = value;
                          },
                          minLines: 2,
                          maxLines: 3,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.location_on,
                            ),
                            labelText: 'Address',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              onPressed: () async {
                String timezone;
                try {
                  timezone = await FlutterNativeTimezone.getLocalTimezone();
                } on PlatformException {
                  timezone = 'Unknown';
                }
                Provider.of<Customer>(context, listen: false)
                    .bookArtist(
                  address: address,
                  artistId: widget.artistId,
                  date: _dateController.text,
                  latitude: lati,
                  longitude: longi,
                  price: widget.price,
                  servicesIdsList: widget.selectedList,
                  timezone: timezone,
                )
                    .then((value) {
                  Fluttertoast.showToast(
                      msg: value
                          ? 'Booking confirmed successfully'
                          : 'Faild to complete process');
                  Navigator.of(context).pop(true);
                });
              },
              color: Theme.of(context).primaryColor,
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  'CONFIRM BOOKING',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
