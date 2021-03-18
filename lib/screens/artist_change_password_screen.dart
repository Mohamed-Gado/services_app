import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:service_app/screens/widgets/customer_change_password_widget.dart';

class ArtistChangePasswordScreen extends StatelessWidget {
  static const routeName = '/artist-change-password-screen';
  const ArtistChangePasswordScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // drawer: AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => CustomDrawer.of(context).open(),
            );
          },
        ),
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Image.asset(
                  'assets/images/forgot_pass.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 4.0,
                left: 8.0,
                right: 8.0,
              ),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    isDismissible: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (_) {
                      return CustomerChangePasswordWidget();
                    },
                  );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2.0,
                  child: ListTile(
                    leading: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      'Change Password',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 4.0,
                left: 8.0,
                right: 8.0,
                bottom: 8.0,
              ),
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 2.0,
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    'Log Out',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
