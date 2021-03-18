import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/models/customer_booking.dart';
import 'package:service_app/providers/customer.dart';

class BookingListItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final booking = Provider.of<CustomerBooking>(context);

    String bookingStatus() {
      if (booking.bookingType == '0' || booking.bookingType == '3') {
        if (booking.bookingFlag == '0') {
          return 'Waiting for Worker response';
        } else if (booking.bookingFlag == '1') {
          return 'Request accepted by Worker';
        } else if (booking.bookingFlag == '3') {
          return 'Your work in progress';
        } else if (booking.bookingFlag == '4') {
          if (booking.invoice['flag'] == '1') {
            return 'Invoice Paid';
          } else {
            return 'Invoice Generated';
          }
        }
      } else if (booking.bookingType == '2') {
        if (booking.bookingFlag == '0') {
          return 'Waiting for Worker response';
        } else if (booking.bookingFlag == '1') {
          return 'Request accepted by Worker';
        } else if (booking.bookingFlag == '3') {
          return 'Your work in progress';
        } else if (booking.bookingFlag == '4') {
          if (booking.invoice['flag'] == '1') {
            return 'Invoice Paid';
          } else {
            return 'Invoice Generated';
          }
        }
      }
      return 'Unknown';
    }

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
              Padding(
                padding: EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: Center(
                  child: Text(
                    'Booking With ${booking.artistName}',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 4.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: booking.artistImage != null &&
                              booking.artistImage != ''
                          ? NetworkImage(booking.artistImage)
                          : AssetImage('assets/images/dummyuser_image.jpg'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 6.0),
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(
                              booking.categoryName,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(
                              '${booking.currencyType}${booking.price}',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.date_range,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' Date: ${booking.bookingDate} ${booking.bookingTime}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.location_on,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                TextSpan(text: ' ${booking.artistLocation}'),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.label,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${bookingStatus()}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.monetization_on,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                TextSpan(text: ' ${booking.description}'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              CupertinoIcons.bag,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: '${booking.jobDone} Jobs Completed',
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1.0,
                      color: Colors.black,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              CupertinoIcons.percent,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          TextSpan(
                              text:
                                  '${booking.completePercentages} Completion'),
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
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (ctx) => new AlertDialog(
                        content: new Text(
                          'Are you Sure to cancel booking with ${booking.artistName}?',
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
                              Provider.of<Customer>(context, listen: false)
                                  .cancelBooking(booking.id)
                                  .then(
                                    (value) => Navigator.of(context).pop(),
                                  );
                            },
                            child: new Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      'Cancel Booking',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
