import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/chat_details_screen.dart';
import 'package:service_app/screens/widgets/bottom_ff_navbar_widget.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';

class ChatsScreen extends StatefulWidget {
  static const routeName = '/chats-screen';
  const ChatsScreen({Key key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Auth>(context, listen: false).currentUser.isCustomer
          ? Provider.of<Customer>(context, listen: false)
              .getChatHistory()
              .then((value) {
              setState(() {
                isInit = false;
              });
            })
          : Provider.of<JobProvider>(context, listen: false)
              .getChatForArtist()
              .then(
                (value) => setState(() {
                  isInit = false;
                }),
              );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final isCustomer =
        Provider.of<Auth>(context, listen: false).currentUser.isCustomer;
    final chats = Provider.of<Customer>(context).chats;
    final artistChats = Provider.of<JobProvider>(context).artistChats;
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomFFNavbarWidget(
          index: 2,
        ),
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => CustomDrawer.of(context).open(),
              );
            },
          ),
          title: Text('Chats'),
        ),
        body: isInit
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(4.0),
                child: ListView.builder(
                  itemCount: isCustomer ? chats.length : artistChats.length,
                  itemBuilder: (ctx, i) => Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 2.0,
                      child: Container(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => ChatDetailsScreen(
                                  id: isCustomer
                                      ? chats[i].artistId
                                      : artistChats[i].userId,
                                  name: isCustomer
                                      ? chats[i].artistName
                                      : artistChats[i].userName,
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: isCustomer
                                ? chats[i].artistImage != null &&
                                        chats[i].artistImage != ''
                                    ? NetworkImage(chats[i].artistImage)
                                    : AssetImage(
                                        'assets/images/dummyuser_image.jpg')
                                : artistChats[i].userImage != null &&
                                        artistChats[i].userImage != ''
                                    ? NetworkImage(artistChats[i].userImage)
                                    : AssetImage(
                                        'assets/images/dummyuser_image.jpg'),
                          ),
                          title: Text(
                            isCustomer
                                ? chats[i].artistName
                                : artistChats[i].userName,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            isCustomer
                                ? chats[i].message
                                : artistChats[i].message,
                            maxLines: 1,
                          ),
                          trailing: Text(
                              ' ${numberOfMonths(isCustomer ? chats[i].date : artistChats[i].date)}'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  String numberOfMonths(String date) {
    int correctDate = int.parse(date);
    if (date.length < 13) {
      int diff = 13 - date.length;
      String val = '1';
      for (int i = 0; i < diff; i++) {
        val += '0';
      }
      correctDate = (int.parse(date) * int.parse(val)) +
          (DateTime.now().millisecondsSinceEpoch % int.parse(val));
    }
    final start = DateTime.fromMillisecondsSinceEpoch(correctDate);
    final minutes = DateTime.now().difference(start).inMinutes;
    if (minutes < 60) {
      return '$minutes Minutes ago';
    } else if ((minutes / 60).round() <= 24) {
      return '${(minutes / 60).round()} Hours ago';
    } else if ((minutes / (60 * 24)).round() <= 30) {
      return '${(minutes / (60 * 24)).round()} Days ago';
    } else {
      return '${(minutes / (60 * 24 * 30)).round()} Months ago';
    }
  }
}
