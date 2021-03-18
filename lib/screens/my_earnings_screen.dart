import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';

class MyEarningsScreen extends StatefulWidget {
  static const routeName = '/my-earnings-screen';

  @override
  _MyEarningsScreenState createState() => _MyEarningsScreenState();
}

class _MyEarningsScreenState extends State<MyEarningsScreen> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<JobProvider>(context, listen: false)
          .getArtistEarnings()
          .then((value) {
        setState(() {
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final earnings = Provider.of<JobProvider>(context).earnings;
    return Scaffold(
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
        title: Text('My Earnings'),
        centerTitle: true,
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Wallet Amount\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.grey, fontSize: 16),
                        ),
                        TextSpan(
                          text:
                              '${earnings.currencySymbol}${earnings.walletAmount}',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Online Earnings',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  trailing: Text(
                    '${earnings.currencySymbol}${earnings.onlineEarning.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Cash Earnings',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  trailing: Text(
                    '${earnings.currencySymbol}${earnings.cashEarning.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Complete',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  trailing: Text(
                    '${earnings.completePercentages.toStringAsFixed(2)}%',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Total Earnings',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  trailing: Text(
                    '${earnings.currencySymbol}${earnings.totalEarning.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Job Done',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  trailing: Text(
                    earnings.jobDone.toString(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Total Job',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  trailing: Text(
                    earnings.totalJob.toString(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 4.0,
                    bottom: 4.0,
                  ),
                  child: RaisedButton(
                    child: Center(
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          'Withdraw Money',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (double.parse(earnings.walletAmount) >= 0) {
                        showDialog(
                          context: context,
                          builder: (context) => new AlertDialog(
                            title: new Text('Uclab Service App?'),
                            content: new Text(
                                'Are you confirm do you want to process your payment?'),
                            actions: <Widget>[
                              new FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: new Text('No'),
                              ),
                              new FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Provider.of<JobProvider>(context,
                                          listen: false)
                                      .walletRequest()
                                      .then((value) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Wallet Request'),
                                        content: Text(value),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                },
                                child: new Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Wallet Request'),
                            content: Text(
                              'you can\'t request for payment because insufficient balance in your walletVendor',
                            ),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                )
              ],
            ),
    );
  }
}
