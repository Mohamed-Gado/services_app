import 'package:flutter/widgets.dart';

class Invoice with ChangeNotifier {
  String id;
  String artistId;
  String invoiceId;
  String bookingId;
  String workingMin;
  String totalAmount;
  String artistAmount;
  String tax;
  String currency;
  String couponCode;
  String paymentStatus;
  String categoryAmount;
  String flag;
  String createdAt;
  String referralAmount;
  String referralPercentage;
  String discountAmount;
  String bookingDate;
  String artistName;
  String categoryName;
  String artistImage;
  String address;
  String finalAmount;

  Invoice({
    this.address,
    this.artistAmount,
    this.artistId,
    this.artistImage,
    this.artistName,
    this.bookingId,
    this.bookingDate,
    this.categoryAmount,
    this.categoryName,
    this.couponCode,
    this.createdAt,
    this.currency,
    this.discountAmount,
    this.flag,
    this.id,
    this.invoiceId,
    this.paymentStatus,
    this.referralAmount,
    this.referralPercentage,
    this.tax,
    this.totalAmount,
    this.workingMin,
    this.finalAmount,
  });
}
