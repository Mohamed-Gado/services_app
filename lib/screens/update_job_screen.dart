import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/category.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/set_location_screen.dart';

class UpdateJobScreen extends StatefulWidget {
  static const routeName = '/update-job-screen';
  @override
  _UpdateJobScreenState createState() => _UpdateJobScreenState();
}

class _UpdateJobScreenState extends State<UpdateJobScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  PickedFile _image;
  final ImagePicker _picker = ImagePicker();
  String category = '';
  Map<String, String> _postData = {
    'job_id': '',
    'title': '',
    'description': '',
    'address': '',
    'category_id': '',
    'lati': '',
    'longi': '',
  };
  TextEditingController _locationController = TextEditingController();
  Future<void> _getImage(ImageSource source) async {
    final pickedImage = await _picker.getImage(source: source);
    setState(() {
      _image = pickedImage;
    });
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
                        category = subCategories[i].name;
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

  Future<void> _showMessageDialog(String message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    final jobId = ModalRoute.of(context).settings.arguments as String;
    final job = Provider.of<Customer>(context)
        .jobsList
        .firstWhere((element) => element.id == jobId);
    final categories = Provider.of<Customer>(context).categories;
    final subCategories = Provider.of<Customer>(context).subCategoriesList;
    _postData['job_id'] = job.jobId;
    _postData['category_id'] = job.categoryId;
    if (_locationController.text.isEmpty) {
      _locationController.text = job.address;
      _postData['address'] = job.address;
      _postData['lati'] = job.lati;
      _postData['longi'] = job.longi;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Job'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
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
                          _getImage(ImageSource.camera);
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
                          _getImage(ImageSource.gallery);
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
                      text: 'Update Picture',
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
            onTap: () {
              if (!_formKey.currentState.validate()) {
                // Invalid!
                return;
              }
              _formKey.currentState.save();
              showLoadingDialog(context);
              _image != null
                  ? Provider.of<Customer>(context, listen: false)
                      .editJobWithPhoto(_image.path, _postData)
                      .then((isSuccess) {
                      Navigator.of(context).pop();
                      _showMessageDialog(isSuccess
                              ? 'Job Updated Successfully'
                              : 'An error Occurred!')
                          .then(
                        (value) => Navigator.of(context).pop(isSuccess),
                      );
                    })
                  : Provider.of<Customer>(context, listen: false)
                      .editJob(_postData)
                      .then((isSuccess) {
                      Navigator.of(context).pop();
                      _showMessageDialog(isSuccess
                              ? 'Job Updated Successfully'
                              : 'An error Occurred!')
                          .then(
                        (value) => Navigator.of(context).pop(isSuccess),
                      );
                    });
            },
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
                'Update',
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
                      isDismissible: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (_) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (ctx, i) {
                              return ListTile(
                                onTap: () {
                                  if (categories[i].subCategories > 0) {
                                    Provider.of<Customer>(context,
                                            listen: false)
                                        .getSubCategories(categories[i].id);
                                    //   .then((value) {
                                    // if (value != null && value.length > 0) {
                                    _showSubCategoryDialog(subCategories);
                                    //   } else {
                                    //     setState(() {
                                    //       _postData['category_id'] =
                                    //           categories[i].id;
                                    //       category = categories[i].name;
                                    //     });
                                    //     Provider.of<Customer>(context,
                                    //             listen: false)
                                    //         .filterByCategories(
                                    //             categories[i].id);
                                    //   }
                                    // });
                                  } else {
                                    setState(() {
                                      category = categories[i].name;
                                    });
                                    Provider.of<Customer>(context,
                                            listen: false)
                                        .filterByCategories(categories[i].id);
                                  }
                                  Navigator.pop(context);
                                },
                                title: Text(
                                  categories[i].name,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  leading: Icon(Icons.check_circle),
                  title: Text(
                    category.isEmpty ? job.categoryName : category,
                    style: Theme.of(context)
                        .appBarTheme
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
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
                        initialValue: job.title,
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
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(SetLocationScreen.routeName)
                              .then((value) {
                            List<String> values = value;
                            _locationController..text = values[0];
                            _postData['lati'] = values[1];
                            _postData['longi'] = values[2];
                          });
                        },
                        child: TextFormField(
                          controller: _locationController,
                          enabled: false,
                          onSaved: (value) {
                            _postData['address'] = value;
                          },
                          maxLines: 2,
                          decoration: InputDecoration(
                            icon: Icon(Icons.location_on),
                            labelText: 'Address',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Required Section!';
                          }
                        },
                        onSaved: (value) {
                          _postData['description'] = value;
                        },
                        minLines: 3,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        initialValue: job.description,
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: _image == null || _image.path.isEmpty
                      ? job.avtar == null || job.avtar.isEmpty
                          ? Center()
                          : Image.network(job.avtar)
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
