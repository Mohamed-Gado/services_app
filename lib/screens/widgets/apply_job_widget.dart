import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/jobs_provider.dart';

class ApplyJobWidget extends StatefulWidget {
  final String jobId;
  final String userId;
  ApplyJobWidget({Key key, @required this.jobId, @required this.userId})
      : super(key: key);

  @override
  _ApplyJobWidgetState createState() => _ApplyJobWidgetState();
}

class _ApplyJobWidgetState extends State<ApplyJobWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String desc = '';
  String price = '';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Apply Job',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Required field!';
                  }
                },
                onSaved: (value) {
                  desc = value;
                },
                minLines: 3,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Write A Description',
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty || double.parse(value) <= 0) {
                    return 'Invalid Price!';
                  }
                },
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  price = value;
                },
                decoration: InputDecoration(
                  labelText: 'Price',
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      print(
                          'widget.jobId${widget.jobId},widget.userId${widget.userId},desc$desc,price$price');
                      Provider.of<JobProvider>(context, listen: false)
                          .applyToJob(
                        jobId: widget.jobId,
                        userId: widget.userId,
                        description: desc,
                        price: price,
                      )
                          .then((value) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            content: Text(value),
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
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Theme.of(context).primaryColor,
                      ),
                      width: (size.width / 2) - 20,
                      child: Text(
                        'Submit',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Theme.of(context).primaryColor,
                      ),
                      width: (size.width / 2) - 20,
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
