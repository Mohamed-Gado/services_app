import 'package:flutter/cupertino.dart';

class Job with ChangeNotifier {
  String id;
  String userId;
  String jobId;
  String title;
  String description;
  String categoryId;
  String status;
  String avtar;
  String address;
  String price;
  String lati;
  String longi;
  String jobDate;
  String time;
  String jobTimestamp;
  String createdAt;
  String updatedAt;
  int isEdit;
  String categoryName;
  int appliedJob;
  String currencySymbol;
  String categoryPrice;

  Job({
    this.address,
    this.appliedJob,
    this.avtar,
    this.categoryId,
    this.categoryName,
    this.categoryPrice,
    this.createdAt,
    this.currencySymbol,
    this.description,
    this.id,
    this.isEdit,
    this.jobDate,
    this.jobId,
    this.jobTimestamp,
    this.lati,
    this.time,
    this.longi,
    this.price,
    this.status,
    this.title,
    this.updatedAt,
    @required this.userId,
  });
}
