import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/applied_job.dart';
import 'package:service_app/providers/jobs_provider.dart';

class AppliedJobItemWidget extends StatelessWidget {
  const AppliedJobItemWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, String> statusText = {
      '0': 'Pending',
      '1': 'Confirmed',
      '2': 'Completed',
      '3': 'Rejected',
      '5': 'In progress'
    };
    Map<String, Color> statusColor = {
      '0': Colors.red,
      '1': Colors.yellow,
      '2': Colors.green,
      '3': Colors.red,
      '5': Colors.red,
    };
    final job = Provider.of<AppliedJob>(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.all(8.0),
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     width: 1.5,
          //     color: Theme.of(context).primaryColor,
          //   ),
          //   borderRadius: BorderRadius.circular(8.0),
          // ),
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
                        'job Title: ${job.title}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        'Date: ${job.jobDate} ${job.time}',
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
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.white),
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
                          backgroundImage: job.userImage == null ||
                                  job.userImage == ''
                              ? AssetImage('assets/images/dummyuser_image.jpg')
                              : NetworkImage(job.userImage),
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
                            job.userName,
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
                                    Icons.phone_android,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: job.userMobile,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.alternate_email,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: job.userEemail,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
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
                                  text: job.userAddress,
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
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<JobProvider>(context, listen: false)
                            .rejectJob(
                          ajId: job.id,
                          jobId: job.jobId,
                          status: '3',
                        )
                            .then((value) {
                          showDialog(
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
                          ).then((value) => Navigator.of(context).pop());
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Theme.of(context).primaryColor,
                        ),
                        width: (MediaQuery.of(context).size.width / 2) - 20,
                        child: Text(
                          'Reject',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (job.status == '1')
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () async {
                        String timezone;
                        var dateTime = DateTime.now();
                        var offset = dateTime.timeZoneOffset;
                        var hours = offset.inHours > 0 ? offset.inHours : 1;
                        if (!offset.isNegative) {
                          timezone = 'GMT+' +
                              offset.inHours.toString().padLeft(2, '0') +
                              ':' +
                              (offset.inMinutes % (hours * 60))
                                  .toString()
                                  .padLeft(2, '0');
                        } else {
                          timezone = 'GMT-' +
                              offset.inHours.toString().padLeft(2, '0') +
                              ":" +
                              (offset.inMinutes % (hours * 60))
                                  .toString()
                                  .padLeft(2, '0');
                        }
                        String date =
                            DateFormat.yMMM().add_jm().format(dateTime);
                        print(date);
                        print('date: $date timezone: $timezone');
                        Provider.of<JobProvider>(context, listen: false)
                            .startJob(
                          jobId: job.jobId,
                          price: job.price,
                          userId: job.userId,
                          date: date,
                          timezone: timezone,
                        )
                            .then((value) {
                          showDialog(
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
                          );
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Theme.of(context).primaryColor,
                        ),
                        width: (MediaQuery.of(context).size.width) - 60,
                        child: Text(
                          'Start Job',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (job.status == '5')
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.green,
                      ),
                      width: (MediaQuery.of(context).size.width) - 60,
                      child: Text(
                        'In progress',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
