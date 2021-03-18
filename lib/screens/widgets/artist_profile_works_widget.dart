import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/screens/widgets/star_rating_widget.dart';

class ArtistProfileWorksWidget extends StatelessWidget {
  const ArtistProfileWorksWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final artist = Provider.of<Auth>(context).artist;
    return ListView.builder(
      itemBuilder: (ctx, i) => Padding(
        padding: EdgeInsets.only(top: 4.0),
        child: ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Job Done For'),
              Text(
                artist.artistBooking[i]['username'],
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              StarRatingWidget(
                rating: double.parse(
                  artist.artistBooking[i]['rating'],
                ),
              ),
            ],
          ),
          trailing: Text(
            artist.artistBooking[i]['currency_type'] +
                artist.artistBooking[i]['price'],
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Theme.of(context).primaryColor),
          ),
          leading: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: CircleAvatar(
              backgroundImage:
                  NetworkImage(artist.artistBooking[i]['userImage']),
              radius: 25,
            ),
          ),
        ),
      ),
      itemCount: artist.artistBooking.length,
    );
  }
}
