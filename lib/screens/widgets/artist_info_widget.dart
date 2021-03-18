import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_app/screens/widgets/star_rating_widget.dart';

class ArtistInfoWidget extends StatelessWidget {
  final String location;
  final String bio;
  final int avaRating;
  final String currency;
  final String price;
  final String rateType;
  final int percentages;
  final int jobDone;
  final List qualifications;
  const ArtistInfoWidget({
    Key key,
    @required this.location,
    @required this.bio,
    @required this.avaRating,
    @required this.currency,
    @required this.price,
    @required this.rateType,
    @required this.jobDone,
    @required this.percentages,
    @required this.qualifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qualificationList = qualifications
        .map(
          (item) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                isThreeLine: true,
                title: Text(
                  '${item['title']}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 16),
                ),
                subtitle: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Text(
                    '${item['description']}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        )
        .toList();
    qualificationList.insert(
        0,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Qualification',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            )
          ],
          mainAxisSize: MainAxisSize.min,
        ));
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                            child: Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        )),
                        TextSpan(
                          text: '($location',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    bio,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$currency$price $rateType',
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
                            color: Theme.of(context).accentColor,
                            rating: avaRating.toDouble(),
                          ),
                        ),
                        TextSpan(
                          text: '($avaRating/5)',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(CupertinoIcons.bag),
                        ),
                        TextSpan(
                          text: '$jobDone Jobs Completed',
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
                          text: '$percentages% Completion',
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
            ),
            SizedBox(height: 4.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: qualificationList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
