import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/job.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/applicants_screen.dart';
import 'package:service_app/screens/update_job_screen.dart';

class JobListItemWidget extends StatelessWidget {
  const JobListItemWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, String> statusText = {
      '0': 'Open',
      '1': 'Confirmed',
      '2': 'Completed',
      '3': 'Rejected',
    };
    Map<String, Color> statusColor = {
      '0': Colors.yellow,
      '1': Colors.yellow,
      '2': Colors.green,
      '3': Colors.red,
    };
    final job = Provider.of<Job>(context);
    final customer = Provider.of<Customer>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => ApplicantsScreen(jobId: job.jobId)));
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Job ID: ${job.jobId}',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Date: ${job.jobDate} ${job.time}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        'Applied: ${job.appliedJob}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  Text(
                    '${job.currencySymbol}${job.price}',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
              Divider(
                thickness: 1.0,
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Services type: ',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: job.categoryName,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: statusColor[job.status],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      statusText[job.status],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            AssetImage('assets/images/dummyuser_image.jpg'),
                        radius: 30,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: job.avtar == null || job.avtar == ''
                              ? AssetImage('assets/images/dummyuser_image.jpg')
                              : NetworkImage(job.avtar),
                          radius: 30,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            job.title,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                            child: Text(
                              job.description,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.location_on,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: job.address,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (job.status == '0')
                Divider(
                  thickness: 1.0,
                  color: Colors.black,
                ),
              if (job.status == '0')
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (job.isEdit != 1) {
                            Fluttertoast.showToast(
                                msg:
                                    'You can\'t edit this job because Worker have already applied');
                            return;
                          }
                          Navigator.of(context)
                              .pushNamed(
                            UpdateJobScreen.routeName,
                            arguments: job.id,
                          )
                              .then(
                            (value) {
                              if (value == true) {
                                print('reload');
                                Provider.of<Customer>(
                                  context,
                                  listen: false,
                                ).getAllJobUser();
                              }
                            },
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: ' Edit ',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1.0,
                        color: Colors.black,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (ctx) => new AlertDialog(
                              content: new Text(
                                'Are you Sure you want to delete this job?',
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: new Text('No'),
                                ),
                                new FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    showLoadingDialog(context);
                                    customer.deleteJob(job.jobId).then((value) {
                                      Navigator.of(context).pop();
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(value),
                                        ),
                                      );
                                    });
                                  },
                                  child: new Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.do_not_disturb_alt,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: ' Delete',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1.0,
                        color: Colors.black,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (ctx) => new AlertDialog(
                              content: new Text(
                                'Are you Sure you want to complete this job?',
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: new Text('No'),
                                ),
                                new FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    showLoadingDialog(context);
                                    customer
                                        .completeJob(job.jobId)
                                        .then((value) {
                                      Navigator.of(context).pop();
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(value),
                                        ),
                                      );
                                    });
                                  },
                                  child: new Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.check,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: ' Complete',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
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
}
