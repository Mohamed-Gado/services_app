import 'package:flutter/cupertino.dart';

class Artist with ChangeNotifier {
  String id;
  String userId;
  String name;
  String categoryId;
  String description;
  String aboutUs;
  String skills;
  String image;
  String completionRate;
  String createdAt;
  String updatedAt;
  String bio;
  String longitude;
  String latitude;
  String location;
  String videoUrl;
  String price;
  String bookingFlag;
  String isOnline;
  String gender;
  String preference;
  String updateProfile;
  int total;
  int percentages;
  int jobDone;
  String categoryName;
  String categoryPrice;
  String distance;
  int avaRating;
  String favStatus;
  String featured;
  String commissionType;
  String flatType;
  String artistCommissionType;
  String currencyType;
  String bannerImage;
  String liveLat;
  String liveLong;
  String city;
  String country;
  List<Map<String, dynamic>> qualifications;
  List<Map<String, dynamic>> artistBooking;
  List<Map<String, dynamic>> products;
  List<Map<String, dynamic>> reviews;
  List<Map<String, dynamic>> gallery;

  Artist({
    this.aboutUs,
    this.artistCommissionType,
    this.avaRating,
    this.bannerImage,
    this.bio,
    this.bookingFlag,
    this.categoryId,
    this.categoryName,
    this.categoryPrice,
    this.commissionType,
    this.completionRate,
    this.createdAt,
    this.currencyType,
    this.description,
    this.distance,
    this.favStatus,
    this.featured,
    this.flatType,
    this.gender,
    this.id,
    this.image,
    this.isOnline,
    this.jobDone,
    this.latitude,
    this.location,
    this.longitude,
    this.name,
    this.percentages,
    this.preference,
    this.price,
    this.skills,
    this.total,
    this.updateProfile,
    this.updatedAt,
    this.userId,
    this.videoUrl,
    this.city,
    this.country,
    this.liveLat,
    this.liveLong,
    this.artistBooking,
    this.gallery,
    this.products,
    this.qualifications,
    this.reviews,
  });
}
