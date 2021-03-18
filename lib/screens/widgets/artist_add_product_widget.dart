import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';

class ArtistAddProductWidget extends StatefulWidget {
  ArtistAddProductWidget({Key key}) : super(key: key);

  @override
  _ArtistAddProductWidgetState createState() => _ArtistAddProductWidgetState();
}

class _ArtistAddProductWidgetState extends State<ArtistAddProductWidget> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  String name;
  String price;
  PickedFile _image;
  final ImagePicker _picker = ImagePicker();
  Future<void> _getImage(ImageSource source) async {
    final pickedImage = await _picker.getImage(source: source);

    setState(() {
      _image = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                'Add Product',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 150,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 150,
                  width: 100,
                  child: _image == null || _image.path.isEmpty
                      ? Container(
                          height: 150,
                          width: 100,
                          color: Theme.of(context).primaryColor,
                        )
                      : Image.file(File(_image.path)),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_a_photo_rounded,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
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
                )
              ],
            ),
          ),
          Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 4.0,
                      right: 4.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty || value.length < 3) {
                          return 'Please enter a valid Name!';
                        }
                      },
                      onSaved: (value) {
                        name = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Product Name',
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
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 4.0,
                      right: 4.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty || double.parse(value) <= 0) {
                          return 'Please enter a valid Price!';
                        }
                      },
                      onSaved: (value) {
                        price = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'My Rate',
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
                              width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (!_formkey.currentState.validate()) {
                      return;
                    }
                    _formkey.currentState.save();
                    Provider.of<Auth>(context, listen: false)
                        .uploadProductImage(
                      name: name,
                      filePath: _image.path,
                      price: price,
                    );
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
                      'Save',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.white,
                            fontSize: 18,
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
                            fontSize: 18,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
