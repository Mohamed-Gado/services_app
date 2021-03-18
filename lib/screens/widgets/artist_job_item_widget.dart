import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/job.dart';
import 'package:service_app/screens/widgets/apply_job_widget.dart';

class ArtistJobItemWidget extends StatelessWidget {
  const ArtistJobItemWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final job = Provider.of<Job>(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.all(8.0),
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
                        'Applied: ${job.appliedJob != null ? job.appliedJob : 0}',
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
              Divider(
                thickness: 1.0,
                color: Colors.black,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isDismissible: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (_) {
                        return ApplyJobWidget(
                          jobId: job.jobId,
                          userId: job.userId,
                        );
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    width: MediaQuery.of(context).size.width / 3,
                    height: 50,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.check,
                              size: 26,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: ' APPLY',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
