import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/applied_job.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/artist_details_screen.dart';
import 'package:service_app/screens/chat_details_screen.dart';
import 'package:service_app/screens/widgets/star_rating_widget.dart';

class ApplicantsItemWidget extends StatelessWidget {
  final AppliedJob job;
  const ApplicantsItemWidget({
    @required this.job,
  });
  @override
  Widget build(BuildContext context) {
    Map<String, String> statusText = {
      '0': 'Applied',
      '1': 'Confirmed',
      '2': 'Completed',
      '3': 'Rejected',
      '5': 'In progress'
    };
    Map<String, Color> statusColor = {
      '0': Colors.yellow,
      '1': Colors.yellow,
      '2': Colors.green,
      '3': Colors.red,
      '5': Colors.green,
    };
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
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) =>
                          ArtistDetailsScreen(artistId: job.artistId),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                            backgroundImage:
                                job.userImage == null || job.userImage == ''
                                    ? AssetImage(
                                        'assets/images/dummyuser_image.jpg')
                                    : NetworkImage(job.userImage),
                            radius: 30,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 150,
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
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: StarRatingWidget(
                                color: Theme.of(context).accentColor,
                                rating: job.rate.toDouble(),
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            CupertinoIcons.chat_bubble_2_fill,
                            color: Theme.of(context).primaryColor,
                            size: 35,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => ChatDetailsScreen(
                                  id: job.artistId,
                                  name: job.userName,
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
              if (job.status == '0')
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<Customer>(context, listen: false)
                              .acceptOrRejectApp(
                            ajId: job.id,
                            jobId: job.jobId,
                            status: '1',
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
                            'Accept',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Provider.of<Customer>(context, listen: false)
                              .acceptOrRejectApp(
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
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (job.status == '1')
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
                        'Worker will soon',
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
