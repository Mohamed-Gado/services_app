import 'package:flutter/widgets.dart';

class CustomerBooking with ChangeNotifier {
  String id;
  String artistName;
  String artistImage;
  String categoryName;
  String price;
  String bookingDate;
  String bookingTime;
  String artistLocation;
  String description;
  String currencyType;
  String status;
  String bookingFlag;
  String bookingType;
  int jobDone;
  int completePercentages;
  Map<String, String> invoice = {};

  CustomerBooking({
    this.artistImage,
    this.artistLocation,
    this.artistName,
    this.bookingDate,
    this.bookingFlag,
    this.bookingTime,
    this.categoryName,
    this.completePercentages,
    this.currencyType,
    this.description,
    this.id,
    this.jobDone,
    this.price,
    this.status,
    this.bookingType,
    this.invoice,
  });
}
