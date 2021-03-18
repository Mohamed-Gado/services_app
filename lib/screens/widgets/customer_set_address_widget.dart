import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/screens/set_location_screen.dart';

class CustomerSetAddressWidget extends StatefulWidget {
  @override
  _CustomerSetAddressWidgetState createState() =>
      _CustomerSetAddressWidgetState();
}

class _CustomerSetAddressWidgetState extends State<CustomerSetAddressWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isInit = true;
  final _controller = TextEditingController();
  Map<String, String> _newData = {
    'address': '',
    'city': '',
    'country': '',
    'office_address': '',
    'lat': '',
    'long': '',
  };
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).currentUser;
    final size = MediaQuery.of(context).size;

    if (isInit) {
      isInit = false;
      _controller..text = user.officeAddress;
    }
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Set Address',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: TextFormField(
                  onSaved: (value) {
                    _newData['address'] = value;
                  },
                  initialValue: user.address,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Address',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: TextFormField(
                  onSaved: (value) {
                    _newData['city'] = value;
                  },
                  initialValue: user.city,
                  decoration: InputDecoration(
                    labelText: 'City',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: TextFormField(
                  initialValue: user.country,
                  onSaved: (value) {
                    _newData['country'] = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Country',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(SetLocationScreen.routeName)
                        .then((value) {
                      List<String> values = value;
                      _controller.text = values[0];
                      _newData['lat'] = values[1];
                      _newData['long'] = values[2];
                    });
                  },
                  child: TextFormField(
                    controller: _controller,
                    onSaved: (value) {
                      _newData['office_address'] = value;
                    },
                    decoration: InputDecoration(
                      enabled: false,
                      labelText: 'Set Location',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        _formKey.currentState.save();
                        Navigator.of(context).pop();
                        Provider.of<Auth>(context, listen: false)
                            .setAddress(_newData);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Theme.of(context).primaryColor,
                        ),
                        width: (size.width / 2) - 20,
                        child: Text(
                          'Save',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Theme.of(context).primaryColor,
                        ),
                        width: (size.width / 2) - 20,
                        child: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
