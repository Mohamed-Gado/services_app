import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/screens/widgets/star_rating_widget.dart';

class ArtistProfileReviewsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final artist = Provider.of<Auth>(context).artist;
    return ListView.builder(
      itemCount: artist.reviews.length + 1,
      itemBuilder: (ctx, i) {
        return i == 0
            ? Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Review(${artist.reviews.length})',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(artist.reviews[i - 1]['image']),
                      radius: 25,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Review By'),
                      Text(artist.reviews[i - 1]['name']),
                      StarRatingWidget(),
                      Text(artist.reviews[i - 1]['comment']),
                    ],
                  ),
                  Text(
                    DateFormat.yMEd().add_jms().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(artist.reviews[i - 1]['created_at']) *
                                  1000),
                        ),
                  ),
                ],
              );
      },
    );
  }
}
