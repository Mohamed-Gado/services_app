import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/screens/widgets/artist_add_qualification_widget.dart';
import 'package:service_app/screens/widgets/star_rating_widget.dart';

class ArtistProfileInfoWidget extends StatefulWidget {
  const ArtistProfileInfoWidget({Key key}) : super(key: key);

  @override
  _ArtistProfileInfoWidgetState createState() =>
      _ArtistProfileInfoWidgetState();
}

class _ArtistProfileInfoWidgetState extends State<ArtistProfileInfoWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  String gender = '';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).currentUser;
    final artist = Provider.of<Auth>(context).artist;
    if (_nameController.text.isEmpty) {
      _nameController..text = artist.name;
    }
    if (_emailController.text.isEmpty) {
      _emailController..text = user.email;
    }
    if (_mobileController.text.isEmpty) {
      _mobileController..text = user.mobile;
    }
    if (gender.isEmpty) {
      gender = user.gender;
    }
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Rate',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 16),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: StarRatingWidget(
                            color: Colors.yellow,
                            rating: artist.avaRating.toDouble(),
                          ),
                        ),
                        TextSpan(
                          text: '(${artist.avaRating}/5)',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(CupertinoIcons.bag),
                      ),
                      TextSpan(
                        text: '${artist.jobDone} Jobs Completed',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(CupertinoIcons.hand_thumbsup),
                      ),
                      TextSpan(
                        text: '${artist.percentages}% Completion',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                'Select Rate Type',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
            ),
            ListTile(
              title: Text(
                artist.commissionType == '0' ? 'Hourly Rate' : 'Fixed Rate',
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: GestureDetector(
                onTap: () {
                  Provider.of<Auth>(context, listen: false)
                      .changeArtistRateType(
                          artist.commissionType == '0' ? '1' : '0');
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Text(
                    'Change',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            ListTile(
              isThreeLine: true,
              title: Text(
                'About',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              subtitle: Text(
                artist.aboutUs,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            ListTile(
              title: Text(
                'Qualifications',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Theme.of(context).primaryColor,
                  size: 35,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    isDismissible: false,
                    isScrollControlled: true,
                    context: context,
                    builder: (_) => ArtistAddQualificationWidget(),
                  );
                },
              ),
            ),
            Column(
              children: artist.qualifications
                  .map(
                    (item) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          isThreeLine: true,
                          title: Text('${item['title']}'),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  '${item['description']}',
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        isDismissible: false,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (_) =>
                                            ArtistAddQualificationWidget(
                                          id: item['id'],
                                          isEdit: true,
                                          title: item['title'],
                                          desc: item['description'],
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Edit',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => new AlertDialog(
                                          title: new Text('Uclab Service App?'),
                                          content: new Text(
                                              'Are you sure you want to delete this item?'),
                                          actions: <Widget>[
                                            new FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: new Text('No'),
                                            ),
                                            new FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Provider.of<Auth>(context,
                                                        listen: false)
                                                    .deleteQualification(
                                                        item['id']);
                                              },
                                              child: new Text('Yes'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Delete',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  )
                  .toList(),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value.isEmpty || value.length < 3) {
                          return 'Please enter a valid Name!';
                        }
                      },
                      onSaved: (value) {},
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
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
                  Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    child: TextFormField(
                      enabled: false,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
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
                  Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    child: TextFormField(
                      controller: _mobileController,
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'Please enter a valid Mobile!';
                        }
                      },
                      onSaved: (value) {},
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Mobile',
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
                ],
              ),
            ),
            Text(
              'Gender',
              style: Theme.of(context).textTheme.headline6,
            ),
            Row(
              children: [
                Radio(
                  value: '1',
                  groupValue: gender,
                  onChanged: (val) {
                    setState(() {
                      gender = val;
                    });
                  },
                ),
                Text('Male'),
                Radio(
                  value: '0',
                  groupValue: gender,
                  onChanged: (val) {
                    setState(() {
                      gender = val;
                    });
                  },
                ),
                Text('Female'),
                Radio(
                  value: '2',
                  groupValue: gender,
                  onChanged: (val) {
                    setState(() {
                      gender = val;
                    });
                  },
                ),
                Text('Other'),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: RaisedButton(
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  Provider.of<Auth>(context, listen: false)
                      .updateArtistHeadInfo(
                        _nameController.text,
                        _mobileController.text,
                        gender,
                      )
                      .then((value) => showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
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
                          ));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    child: Text(
                      'Update',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
