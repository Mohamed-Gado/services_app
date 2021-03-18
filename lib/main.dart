import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/artist_applied_jobs_screen.dart';
import 'package:service_app/screens/artist_bookings_screen.dart';
import 'package:service_app/screens/artist_change_password_screen.dart';
import 'package:service_app/screens/artist_current_bookings_screen.dart';
import 'package:service_app/screens/artist_profile_screen.dart';
import 'package:service_app/screens/chats_screen.dart';
import 'package:service_app/screens/choose_user_screen.dart';
import 'package:service_app/screens/edit_artist_profile_screen.dart';
import 'package:service_app/screens/forget_password_screen.dart';
import 'package:service_app/screens/home_screen.dart';
import 'package:service_app/screens/my_booking_screen.dart';
import 'package:service_app/screens/my_earnings_screen.dart';
import 'package:service_app/screens/my_wallet_screen.dart';
import 'package:service_app/screens/near_by_screen.dart';
import 'package:service_app/screens/notifications_screen.dart';
import 'package:service_app/screens/customer_profile_screen.dart';
import 'package:service_app/screens/payment_screen.dart';
import 'package:service_app/screens/post_job_screen.dart';
import 'package:service_app/screens/receipt_details_screen.dart';
import 'package:service_app/screens/receipt_screen.dart';
import 'package:service_app/screens/search_jobs_screen.dart';
import 'package:service_app/screens/set_location_screen.dart';
import 'package:service_app/screens/splash_screen.dart';
import 'package:service_app/screens/terms_screen.dart';
import 'package:service_app/screens/tickets_screen.dart';
import 'package:service_app/screens/update_job_screen.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isInit = true;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (message) async {
        print('onMessage: $message');
        showNotification(
          message['data'] != null
              ? message['data']['title'] ?? 'Service App'
              : 'Service App',
          message['data'] != null
              ? message['data']['body'] ?? 'Service App'
              : 'Service App',
        );
      },
      onResume: (message) async {
        print('onResume: $message');
      },
      onLaunch: (message) async {
        print('onLaunch: $message');
      },
    );
  }

  Future onSelectNotification(String text) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Uclab"),
          content: Text("Uclab : $text"),
        );
      },
    );
  }

  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, JobProvider>(
          create: (_) => JobProvider(),
          update: (_, auth, previousProvider) {
            previousProvider
              ..userId = auth.currentUser != null ? auth.currentUser.id : null;
            return previousProvider;
          },
        ),
        ChangeNotifierProxyProvider<Auth, Customer>(
          create: (_) => Customer(),
          update: (_, auth, previousCustomer) {
            previousCustomer
              ..userId = auth.currentUser != null ? auth.currentUser.id : null;
            return previousCustomer;
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Service App',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.amber,
            errorColor: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Poppins',
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                  button: TextStyle(color: Colors.white),
                ),
            appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                    ),
                  ),
            ),
          ),
          routes: {
            CustomerProfileScreen.routeName: (ctx) => CustomerProfileScreen(),
            ChatsScreen.routeName: (ctx) => ChatsScreen(),
            MyBookingScreen.routeName: (ctx) => MyBookingScreen(),
            ReceiptScreen.routeName: (ctx) => ReceiptScreen(),
            SearchJobsScreen.routeName: (ctx) => SearchJobsScreen(),
            MyWalletScreen.routeName: (ctx) => MyWalletScreen(),
            NotificationsScreen.routeName: (ctx) => NotificationsScreen(),
            SetLocationScreen.routeName: (ctx) => SetLocationScreen(),
            PostJobScreen.routeName: (ctx) => PostJobScreen(),
            NearByScreen.routeName: (ctx) => NearByScreen(),
            ReceiptDetailsScreen.routeName: (ctx) => ReceiptDetailsScreen(),
            PaymentScreen.routeName: (ctx) => PaymentScreen(),
            UpdateJobScreen.routeName: (ctx) => UpdateJobScreen(),
            ForgetPasswordScreen.routeName: (ctx) => ForgetPasswordScreen(),
            TermsScreen.routeName: (ctx) => TermsScreen(),
            ArtistAppliedJobsScreen.routeName: (ctx) =>
                ArtistAppliedJobsScreen(),
            ArtistCurrentBookingsScreen.routeName: (ctx) =>
                ArtistCurrentBookingsScreen(),
            ArtistBookingsScreen.routeName: (ctx) => ArtistBookingsScreen(),
            ArtistProfileScreen.routeName: (ctx) => ArtistProfileScreen(),
            ArtistChangePasswordScreen.routeName: (ctx) =>
                ArtistChangePasswordScreen(),
            EditArtistProfileScreen.routeName: (ctx) =>
                EditArtistProfileScreen(),
            MyEarningsScreen.routeName: (ctx) => MyEarningsScreen(),
            TicketsScreen.routeName: (ctx) => TicketsScreen(),
          },
          home: auth.isAuth
              ? CustomDrawer(child: HomeScreen())
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : ChooseUserScreen(),
                ),
        ),
      ),
    );
  }
}
