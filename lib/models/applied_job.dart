import 'package:flutter/cupertino.dart';

class AppliedJob with ChangeNotifier {
  String id;
  String userId;
  String artistId;
  String jobId;
  String price;
  String description;
  String status;
  String createdAt;
  String updatedAt;
  String currencySymbol;
  String categoryName;
  String userName;
  String userImage;
  String userAddress;
  String title;
  String jobDate;
  String time;
  String jobTimestamp;
  String userMobile;
  String userEemail;
  int rate;

  AppliedJob({
    this.artistId,
    this.categoryName,
    this.createdAt,
    this.currencySymbol,
    this.description,
    this.id,
    this.jobDate,
    this.jobId,
    this.jobTimestamp,
    this.price,
    this.status,
    this.time,
    this.title,
    this.updatedAt,
    this.userAddress,
    this.userEemail,
    this.userId,
    this.userImage,
    this.userMobile,
    this.userName,
    this.rate,
  });
}
