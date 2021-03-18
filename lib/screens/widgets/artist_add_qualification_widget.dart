import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';

class ArtistAddQualificationWidget extends StatefulWidget {
  final bool isEdit;
  final String id;
  final String title;
  final String desc;
  const ArtistAddQualificationWidget({
    Key key,
    this.isEdit = false,
    this.title = '',
    this.desc = '',
    this.id,
  }) : super(key: key);

  @override
  _ArtistAddQualificationWidgetState createState() =>
      _ArtistAddQualificationWidgetState();
}

class _ArtistAddQualificationWidgetState
    extends State<ArtistAddQualificationWidget> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  String title = '';
  String desc = '';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    title = widget.title;
    desc = widget.desc;
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
                widget.isEdit ? 'Edit Qualification' : 'Add Qualification',
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
                      initialValue: widget.title,
                      validator: (value) {
                        if (value.isEmpty || value.length < 3) {
                          return 'Please enter a valid Title!';
                        }
                      },
                      onSaved: (value) {
                        title = value;
                      },
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
                      initialValue: widget.desc,
                      validator: (value) {
                        if (value.isEmpty || value.length < 3) {
                          return 'Please enter a valid description!';
                        }
                      },
                      onSaved: (value) {
                        desc = value;
                      },
                      maxLines: 3,
                      minLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
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
                    widget.isEdit
                        ? Provider.of<Auth>(context, listen: false)
                            .updateQualification(widget.id, title, desc)
                        : Provider.of<Auth>(context, listen: false)
                            .addQualification(title, desc);
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
