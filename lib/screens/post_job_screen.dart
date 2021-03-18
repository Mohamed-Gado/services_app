import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/category.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/set_location_screen.dart';

class PostJobScreen extends StatefulWidget {
  static const routeName = '/post-job-screen';
  const PostJobScreen({Key key}) : super(key: key);

  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  PickedFile _image;
  final ImagePicker _picker = ImagePicker();
  Map<String, String> _postData = {
    'title': '',
    'price': '',
    'description': '',
    'address': '',
    'date': '',
    'category_name': '',
    'category_id': '',
    'lati': '',
    'longi': '',
  };
  Future<void> _getImage(ImageSource source) async {
    final pickedImage = await _picker.getImage(source: source);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> _post() async {
    print('_image.path $_postData');
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    if (_postData['category_id'].isEmpty) {
      Fluttertoast.showToast(msg: 'Enter A Category');
      return;
    }
    if (_postData['address'].isEmpty) {
      Fluttertoast.showToast(msg: 'Enter An Address');
      return;
    }
    if (_postData['date'].isEmpty) {
      Fluttertoast.showToast(msg: 'Enter A Date');
      return;
    }
    _formKey.currentState.save();
    showLoadingDialog(context);
    Provider.of<Customer>(context, listen: false)
        .postJobWithImage(_image == null ? '' : _image.path, _postData)
        .then((value) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content:
              Text(value ? 'Job added successfully' : 'Faild try again later'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop(value);
              },
              child: Text('OK'),
            ),
          ],
        ),
      ).then((value) => Navigator.of(context).pop(value));
    });
  }

  showLoadingDialog(BuildContext ctx) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Row(
            children: [
              CircularProgressIndicator(),
              Container(
                margin: EdgeInsets.only(left: 7),
                child: Text("Please Wait..."),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSubCategoryDialog(List<Category> subCategories) async {
    return await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text('Select Subcategory'),
        content: Container(
          height: MediaQuery.of(context).size.height / 2,
          child: ListView.builder(
            itemCount: subCategories.length,
            itemBuilder: (ctx, i) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        _postData['category_name'] = subCategories[i].name;
                        _postData['category_id'] = subCategories[i].id;
                      });
                      Provider.of<Customer>(context, listen: false)
                          .filterByCategories(subCategories[i].id);
                      Navigator.pop(context);
                    },
                    title: Text(
                      subCategories[i].name,
                    ),
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<Customer>(context).categories;
    final subCategories = Provider.of<Customer>(context).subCategoriesList;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Job'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      bottomNavigationBar: ButtonBar(
        buttonHeight: 40,
        mainAxisSize: MainAxisSize.min,
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    'Take Image from',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          _getImage(ImageSource.camera).then((value) {});
                        },
                        child: Text(
                          'Camera',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          _getImage(ImageSource.gallery).then((value) {});
                        },
                        child: Text(
                          'Gallery',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 16),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).primaryColor,
                        size: 26,
                      ),
                    ),
                    TextSpan(
                      text: 'Add Picture',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _post,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Post',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 8.0,
                child: ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (_) {
                        return DraggableScrollableSheet(
                          expand: false,
                          builder: (ctx, controller) => Container(
                            child: ListView.builder(
                              controller: controller,
                              itemCount: categories.length + 1,
                              itemBuilder: (ctx, i) {
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        if (categories[i].subCategories > 0) {
                                          Provider.of<Customer>(context,
                                                  listen: false)
                                              .getSubCategories(
                                                  categories[i].id);
                                          _showSubCategoryDialog(subCategories);
                                        } else {
                                          setState(() {
                                            _postData['category_id'] =
                                                categories[i].id;
                                            _postData['category_name'] =
                                                categories[i].name;
                                          });
                                          Provider.of<Customer>(context,
                                                  listen: false)
                                              .filterByCategories(
                                                  categories[i].id);
                                        }
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        categories[i].name,
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  leading: Icon(Icons.check_circle),
                  title: Text(
                    _postData['category_name'].isEmpty
                        ? 'Select Categories'
                        : _postData['category_name'],
                    style: Theme.of(context)
                        .appBarTheme
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Invalid Title!';
                            }
                          },
                          onSaved: (value) {
                            _postData['title'] = value;
                          },
                          maxLines: 1,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Title',
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
                        padding: EdgeInsets.all(4.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Invalid Budget!';
                            }
                          },
                          onSaved: (value) {
                            _postData['price'] = value;
                          },
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Budget',
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
                        padding: EdgeInsets.all(4.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required Section!';
                            }
                          },
                          minLines: 3,
                          maxLines: 5,
                          onSaved: (value) {
                            _postData['description'] = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Enter Your Description',
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
                        padding: EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.of(context)
                                .pushNamed(SetLocationScreen.routeName)
                                .then((value) {
                              setState(() {
                                List<String> values = value;
                                setState(() {
                                  _addressController..text = values[0];
                                  _postData['address'] = values[0];
                                  _postData['lati'] = values[1];
                                  _postData['longi'] = values[2];
                                });
                              });
                            });
                          },
                          child: TextFormField(
                            controller: _addressController,
                            enabled: false,
                            onSaved: (value) {
                              _postData['address'] = value;
                            },
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
                                  _postData['date'] = formatted;
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
                    ],
                  ),
                  key: _formKey,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Container(
                  height: 100,
                  width: 100,
                  child: _image == null || _image.path.isEmpty
                      ? Center()
                      : Image.file(File(_image.path)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
