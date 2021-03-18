import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_app/screens/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseUserScreen extends StatefulWidget {
  const ChooseUserScreen({Key key}) : super(key: key);

  @override
  _ChooseUserScreenState createState() => _ChooseUserScreenState();
}

class _ChooseUserScreenState extends State<ChooseUserScreen> {
  bool isInit = true;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void didChangeDependencies() {
    if (isInit) {
      SharedPreferences.getInstance().then((prefs) {
        if (prefs.containsKey('token')) {
          isInit = false;
          return;
        }
        _firebaseMessaging.getToken().then((value) async {
          prefs.setString('token', value);
          print('Token: $value');
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Uclab Service App?'),
            content: new Text('Do you want to close Service App?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final deviceSize = MediaQuery.of(context).size;
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: isIos
          ? CupertinoPageScaffold(
              child: bodyWidget(context, deviceSize),
            )
          : Scaffold(
              body: bodyWidget(context, deviceSize),
            ),
    );
  }

  Widget bodyWidget(BuildContext context, Size deviceSize) {
    return Container(
      color: Colors.white,
      height: deviceSize.height,
      width: deviceSize.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Welcome to Uclab Service App',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Image.asset(
            'assets/images/mapimg.jpg',
            fit: BoxFit.cover,
            height: deviceSize.height / 1.5,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0, top: 16.0),
            child: GestureDetector(
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => SignInScreen(
                      isCustomer: true,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  'I am Customer',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => SignInScreen(
                      isCustomer: false,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  'I am Service Provider',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
