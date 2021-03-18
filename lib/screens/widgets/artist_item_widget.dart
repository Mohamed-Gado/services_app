import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/artist.dart';
import 'package:service_app/screens/artist_details_screen.dart';
import 'package:service_app/screens/widgets/star_rating_widget.dart';

class ArtistItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final artist = Provider.of<Artist>(context, listen: false);
    final size = MediaQuery.of(context).size;
    String _getPaidType() {
      if (artist.artistCommissionType == '0') {
        if (artist.commissionType == '0') {
          return '/hr';
        } else if (artist.commissionType == '1' && artist.flatType == '2') {
          return '/hr';
        } else if (artist.commissionType == '1' && artist.flatType == '1') {
          return '/hr';
        } else {
          return '/hr';
        }
      } else {
        if (artist.commissionType == '0') {
          return 'fixed rate';
        } else if (artist.commissionType == '1' && artist.flatType == '2') {
          return 'fixed rate';
        } else if (artist.commissionType == '1' && artist.flatType == '1') {
          return 'fixed rate';
        } else {
          return 'fixed rate';
        }
      }
    }

    int numberOfMonths(String date) {
      int correctDate = int.parse(date);
      if (date.length < 13) {
        int diff = 13 - date.length;
        String val = '1';
        for (int i = 0; i < diff; i++) {
          val += '0';
        }
        correctDate = (int.parse(date) * int.parse(val)) +
            (DateTime.now().millisecondsSinceEpoch % int.parse(val));
      }
      final start = DateTime.fromMillisecondsSinceEpoch(correctDate);
      final months = DateTime.now().difference(start).inHours / 24;
      print('start date $start');
      return months.round();
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0, right: 4.0, left: 4.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => ArtistDetailsScreen(
                artistId: artist.id,
              ),
            ));
          },
          child: Container(
            padding: EdgeInsets.only(
                bottom: 16.0, top: artist.featured == '1' ? 0.0 : 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (artist.featured == '1')
                  Container(
                    transform: Matrix4.rotationZ(25 * pi / 180)..translate(8.0),
                    child: Image.asset(
                      'assets/images/f_i_m.png',
                      height: 30,
                      width: 110,
                    ),
                  ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: artist.image != null && artist.image != ''
                        ? NetworkImage(artist.image)
                        : AssetImage('assets/images/dummyuser_image.jpg'),
                  ),
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: artist.name,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 16),
                        ),
                        WidgetSpan(
                          child: Icon(
                            artist.favStatus == '1'
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                        )
                      ],
                    ),
                  ),
                  subtitle: Text(artist.categoryName),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (artist.featured == '1') SizedBox(height: 20),
                      Text(
                        '${artist.currencyType}${artist.price} ${_getPaidType()}',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 16.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width / 3,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.location_on),
                                ),
                                TextSpan(
                                  text: artist.location,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                            maxLines: 3,
                          ),
                        ),
                        Container(
                          width: (size.width / 3) - 20,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.not_listed_location),
                                ),
                                TextSpan(
                                    text: '${artist.distance} Km from you'),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: (size.width / 3) - 20,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.access_time),
                                ),
                                TextSpan(
                                    text:
                                        ' ${numberOfMonths(artist.createdAt)} Month ago'),
                              ],
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: StarRatingWidget(
                              color: Colors.yellow,
                              rating: artist.avaRating.toDouble(),
                            ),
                          ),
                          TextSpan(
                            text: '(${artist.avaRating}/5)',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontSize: 16,
                                    ),
                          ),
                        ],
                      ),
                      maxLines: 3,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${artist.jobDone} Jobs Done',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            '${artist.completionRate}% Completion',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                // Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
