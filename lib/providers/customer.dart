import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/models/applied_job.dart';
import 'package:service_app/models/artist.dart';
import 'package:service_app/models/chat.dart';
import 'package:service_app/models/customer_booking.dart';
import 'package:service_app/models/invoice.dart';
import 'package:service_app/models/job.dart';
import 'package:service_app/models/message.dart';
import 'package:service_app/models/wallet.dart';
import 'package:service_app/models/wallet_history.dart';
import '../models/category.dart';

const String base_url = 'https://srm.salepe.in/webservice';

class Customer with ChangeNotifier {
  final String _getAllCategory = 'getAllCaegory';
  final String _getAllArtists = 'getAllArtists';
  List<Category> _categories = [];
  List<Artist> _artists = [];
  List<Artist> _catArtist = [];
  List<CustomerBooking> _bookings = [];
  List<CustomerBooking> _searchBookings = [];
  List<Job> _searchJobs = [];
  List<Job> _jobs = [];
  List<Chat> _chatsList = [];
  List<Message> _messages = [];
  List<Invoice> _invoiceList = [];
  Wallet _wallet = Wallet();
  List<WalletHistory> _walletHistory = [];
  List<WalletHistory> _debitHistory = [];
  List<WalletHistory> _creditHistory = [];
  List<AppliedJob> _applicants = [];
  List<AppliedJob> _searchApplicants = [];
  List<Category> _subCategoriesList = [];

  String _userId;
  set userId(String userIdValue) {
    _userId = userIdValue;
  }

  Wallet get wallet {
    return _wallet;
  }

  List<Category> get subCategoriesList {
    return [..._subCategoriesList];
  }

  List<AppliedJob> get applicants {
    return _searchApplicants;
  }

  List<WalletHistory> get debitHistory {
    return [..._debitHistory];
  }

  List<WalletHistory> get creditHistory {
    return [..._creditHistory];
  }

  List<WalletHistory> get walletHistory {
    return [..._walletHistory];
  }

  List<Message> get messages {
    return [..._messages];
  }

  List<Invoice> get invoices {
    return [..._invoiceList];
  }

  List<Chat> get chats {
    return [..._chatsList];
  }

  List<Artist> get artists {
    return [..._artists];
  }

  List<Artist> get catArtist {
    return [..._catArtist];
  }

  List<Job> get jobsList {
    return [..._searchJobs];
  }

  List<CustomerBooking> get searchBooking {
    return [..._searchBookings];
  }

  List<Category> get categories {
    return [..._categories];
  }

  void filterByCategories(String catId) {
    if (catId == 'all') {
      _catArtist = _artists;
      print('$catId ${_catArtist.length}');
      notifyListeners();
    } else {
      final result = _artists
          .where(
            (element) => element.categoryId == catId,
          )
          .toList();
      _catArtist = result;
      notifyListeners();
    }
  }

  void searchJobs(String text) {
    if (text != null && text != '') {
      final searchResult = _jobs
          .where((element) => element.title
              .toLowerCase()
              .trim()
              .contains(text.toLowerCase().trim()))
          .toList();
      _searchJobs = searchResult;
      notifyListeners();
    } else {
      _searchJobs = _jobs;
      notifyListeners();
    }
  }

  void searchApplicants(String text) {
    if (text != null && text != '') {
      final searchResult = _applicants
          .where((element) => element.userName
              .toLowerCase()
              .trim()
              .contains(text.toLowerCase().trim()))
          .toList();
      _searchApplicants = searchResult;
      notifyListeners();
    } else {
      _searchApplicants = _applicants;
      notifyListeners();
    }
  }

  void searchBookings(String text) {
    if (text != null && text != '') {
      final searchResult = _bookings
          .where((element) => element.artistName
              .toLowerCase()
              .trim()
              .contains(text.toLowerCase().trim()))
          .toList();
      _searchBookings = searchResult;
      notifyListeners();
    } else {
      _searchBookings = _bookings;
      notifyListeners();
    }
  }

  Future<bool> bookArtist({
    String artistId,
    String date,
    String timezone,
    String address,
    String latitude,
    String longitude,
    double price,
    String servicesIdsList = '',
  }) async {
    final url = '$base_url/book_artist';
    final body = {
      'user_id': _userId,
      'artist_id': artistId,
      'date_string': date,
      'timezone': timezone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'price': price.toString(),
    };
    if (servicesIdsList.isNotEmpty) {
      body.addAll({
        'service_id': servicesIdsList,
      });
    }
    try {
      final response = await http.post(url, body: body);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['message'].toString() != 'Booking confirmed successfully.') {
        return false;
      }
      print('is: ${data['message']}');
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<String> acceptOrRejectApp(
      {String ajId, String jobId, String status}) async {
    var url = '$base_url/job_status_user';
    try {
      final response = await http.post(
        url,
        body: {
          'aj_id': ajId,
          'job_id': jobId,
          'status': status,
        },
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      print('object ${body['message']}');

      await getAllApplicants(jobId);
      return body['message'];
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> getChatHistory() async {
    final url = '$base_url/getChatHistoryForUser';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
        },
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body['message'] != 'Get chat history.') {
        return;
      }
      final data = List<Map<String, dynamic>>.from(body['my_chat']);
      final chatsList = data
          .map(
            (chat) => Chat(
              artistId: chat['artist_id'],
              artistImage: chat['artistImage'],
              artistName: chat['artistName'],
              chatType: chat['chat_type'],
              date: chat['date'],
              id: chat['id'],
              message: chat['message'],
              sender: chat['sender_name'],
            ),
          )
          .toList();
      _chatsList = chatsList;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getChat(bool isCustomer, String id) async {
    final url = '$base_url/getChat';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': isCustomer ? _userId : id,
          'artist_id': isCustomer ? id : _userId,
        },
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body['my_chat'] == null || body['my_chat'].isEmpty) {
        return;
      }
      final data = List<Map<String, dynamic>>.from(body['my_chat']);

      final messages = data
          .map(
            (message) => Message(
              chatType: message['chat_type'],
              date: message['date'],
              id: message['id'],
              image: message['image'],
              message: message['message'],
              sendBy: message['send_by'],
              sender: message['sender_name'],
            ),
          )
          .toList();
      messages.sort((a, b) => b.date.compareTo(a.date));
      _messages = messages;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> sendMessage(String filePath, Map<String, String> msgData) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$base_url/sendmsg'),
    );
    if (filePath != null && filePath != '') {
      var file = await http.MultipartFile.fromPath('image', filePath);
      request.files.add(file);
    }
    request..fields['artist_id'] = msgData['artist_id'];
    request..fields['user_id'] = msgData['user_id'];
    request..fields['message'] = msgData['message'];
    request..fields['send_by'] = _userId;
    request..fields['sender_name'] = msgData['sender_name'];
    request
      ..fields['chat_type'] = filePath != null && filePath != '' ? '2' : '1';
    try {
      final response = await request.send();
      print('res headers: ${response.headers}');
      print('res statusCode: ${response.statusCode}');
      final body = await response.stream.bytesToString();
      final responseData = json.decode(body) as Map<String, dynamic>;
      print(responseData);
      final data = List<Map<String, dynamic>>.from(responseData['my_chat']);
      final messages = data
          .map(
            (message) => Message(
              chatType: message['chat_type'],
              date: message['date'],
              id: message['id'],
              image: message['image'],
              message: message['message'],
              sendBy: message['send_by'],
              sender: message['sender_name'],
            ),
          )
          .toList();
      messages.sort((a, b) => b.date.compareTo(a.date));
      _messages = messages;
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<Map<String, dynamic>> checkCoupon(
      String invoiceId, String coupon) async {
    final url = '$base_url/checkCoupon';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
          'invoice_id': invoiceId,
          'coupon_code': coupon,
        },
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body['message'].toString() == 'Coupon code not valid.') {
        return {};
      }
      return {
        'final_amount': body['final_amount'],
        'discount_amount': body['discount_amount'],
      };
    } catch (err) {
      return {};
    }
  }

  Future<bool> sendPayment({
    String invoiceId,
    String couponCode,
    String amount,
    String type,
    String discount,
  }) async {
    final url = '$base_url/makePayment';
    try {
      final response = await http.post(url, body: {
        'invoice_id': invoiceId,
        'coupon_code': couponCode,
        'usr_id': _userId,
        'final_amount': amount,
        'payment_status': '1',
        'payment_type': type,
        'discount_amount': discount,
      });
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (!body['message'].toString().contains('successfully')) {
        return false;
      }
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<void> getMyInvoice(bool isCustomer) async {
    final url = '$base_url/getMyInvoice';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
          'role': isCustomer ? '2' : '1',
        },
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body['message'] != 'Get my invoice.') {
        return;
      }
      final data = List<Map<String, dynamic>>.from(body['data']);
      final invoiceList = data
          .map(
            (invoice) => Invoice(
              id: invoice['id'],
              address: invoice['address'],
              artistAmount: invoice['artist_amount'],
              artistId: invoice['artist_id'],
              artistImage: invoice['artistImage'],
              artistName: invoice['ArtistName'],
              bookingDate: invoice['booking_date'],
              bookingId: invoice['booking_id'],
              categoryAmount: invoice['category_amount'],
              categoryName: invoice['categoryName'],
              couponCode: invoice['coupon_code'],
              createdAt: invoice['created_at'],
              currency: invoice['currency_type'],
              discountAmount: invoice['discount_amount'],
              flag: invoice['flag'],
              invoiceId: invoice['invoice_id'],
              paymentStatus: invoice['payment_status'],
              referralAmount: invoice['referral_amount'],
              referralPercentage: invoice['referral_percentage'],
              tax: invoice['tax'],
              totalAmount: invoice['total_amount'],
              workingMin: invoice['working_min'],
              finalAmount: invoice['final_amount'],
            ),
          )
          .toList();
      _invoiceList = invoiceList;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<bool> editJob(Map<String, String> postData) async {
    print('userId $_userId postData $postData');
    var url = '$base_url/edit_post_job';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
          'job_id': postData['job_id'],
          'title': postData['title'],
          'description': postData['description'],
          'address': postData['address'],
          'lati': postData['lati'],
          'longi': postData['longi'],
          'category_id': postData['category_id'],
        },
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      print(responseData);
      return responseData['message'] == 'Job Updated Successfully.';
    } catch (err) {
      return false;
    }
  }

  Future<bool> editJobWithPhoto(
      String filePath, Map<String, String> postData) async {
    print('file $filePath postData $postData');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$base_url/edit_post_job'),
    );
    if (filePath != null && filePath.isNotEmpty) {
      var file = await http.MultipartFile.fromPath('avtar', filePath);
      request.files.add(file);
    }
    request..fields['user_id'] = _userId;
    request..fields['job_id'] = postData['job_id'];
    request..fields['title'] = postData['title'];
    request..fields['description'] = postData['description'];
    request..fields['address'] = postData['address'];
    request..fields['lati'] = postData['lati'];
    request..fields['longi'] = postData['longi'];
    request..fields['category_id'] = postData['category_id'];
    try {
      final response = await request.send();
      print('res headers: ${response.headers}');
      print('res statusCode: ${response.statusCode}');
      final body = await response.stream.bytesToString();
      final responseData = json.decode(body) as Map<String, dynamic>;
      print(responseData);
      return responseData['message'] == 'Job Updated Successfully.';
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> postJob(Map<String, String> postData) async {
    var url = '$base_url/post_job_new';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
          'title': postData['title'],
          'price': postData['price'],
          'description': postData['description'],
          'address': postData['address'],
          'lati': postData['lati'],
          'longi': postData['longi'],
          'category_id': postData['category_id'],
          'job_date': postData['date'],
        },
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['message'] != 'Job added successfully.') {
        print(responseData['message'].toString());
        return false;
      }
      print(responseData);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> postJobWithImage(
      String filePath, Map<String, String> postData) async {
    if (filePath.isEmpty) {
      bool isSuccess = await postJob(postData);
      print(isSuccess);
      return isSuccess;
    }
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$base_url/post_job_new'),
    );
    var file = await http.MultipartFile.fromPath('avtar', filePath);
    request.files.add(file);
    request..fields['user_id'] = _userId;
    request..fields['title'] = postData['title'];
    request..fields['price'] = postData['price'];
    request..fields['description'] = postData['description'];
    request..fields['address'] = postData['address'];
    request..fields['category_id'] = postData['category_id'];
    request..fields['lati'] = postData['lati'];
    request..fields['longi'] = postData['longi'];
    request..fields['job_date'] = postData['date'];

    try {
      final response = await request.send();
      print('res headers: ${response.headers}');
      print('res statusCode: ${response.statusCode}');
      final body = await response.stream.bytesToString();
      final responseData = json.decode(body) as Map<String, dynamic>;
      if (!responseData['message'].toString().contains('Successfully.')) {
        return false;
      }
      print(responseData);
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<void> getWallet() async {
    final url = '$base_url/getWallet';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
        },
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body['message'] != 'Get my wallet.') {
        return;
      }
      final data = Map<String, dynamic>.from(body['data']);
      _wallet = Wallet(amount: data['amount'], currency: data['currency_type']);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getWalletHistoryWithStatus(String status) async {
    final url = '$base_url/getWalletHistory';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
          'status': status,
        },
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body['message'] != 'Get my wallet history.') {
        return;
      }
      final data = List<Map<String, dynamic>>.from(body['data']);
      final historyList = data
          .map(
            (item) => WalletHistory(
              amount: item['amount'],
              createdAt: item['created_at'],
              currency: item['currency_type'],
              description: item['description'],
              id: item['id'],
              invoiceId: item['invoice_id'],
              orderId: item['order_id'],
              status: item['status'],
              type: item['type'],
            ),
          )
          .toList();
      if (status == '1') {
        _debitHistory = historyList;
        notifyListeners();
      } else {
        _creditHistory = historyList;
        notifyListeners();
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> getAllWalletHistory() async {
    final url = '$base_url/getWalletHistory';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
        },
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body['message'] != 'Get my wallet history.') {
        return;
      }
      final data = List<Map<String, dynamic>>.from(body['data']);
      final historyList = data
          .map(
            (item) => WalletHistory(
              amount: item['amount'],
              createdAt: item['created_at'],
              currency: item['currency_type'],
              description: item['description'],
              id: item['id'],
              invoiceId: item['invoice_id'],
              orderId: item['order_id'],
              status: item['status'],
              type: item['type'],
            ),
          )
          .toList();
      _walletHistory = historyList;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<String> cancelBooking(String bookingId) async {
    final url = '$base_url/decline_booking';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
          'booking_id': bookingId,
          'decline_by': '2',
          'decline_reason': 'Busy',
        },
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body['message'] == 'Booking Decline successfully.') {
        _bookings.removeWhere((element) => element.id == bookingId);
        _searchBookings.removeWhere((element) => element.id == bookingId);
        notifyListeners();
      }
      return body['message'];
    } catch (err) {
      throw err;
    }
  }

  Future<String> completeJob(String jobId) async {
    final url = '$base_url/jobComplete';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
          'job_id': jobId,
        },
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body['message'] == 'Job finished successfully.') {
        await getAllJobUser();
      }
      return body['message'];
    } catch (err) {
      throw err;
    }
  }

  Future<String> deleteJob(String jobId) async {
    final url = '$base_url/deletejob';
    try {
      final response = await http.post(
        url,
        body: {
          'job_id': jobId,
          'status': '4',
        },
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body['message'] == 'Job deleted successfully.') {
        await getAllJobUser();
      }
      return body['message'];
    } catch (err) {
      throw err;
    }
  }

  Future<void> getMyCurrentBookingUser() async {
    final url = '$base_url/getMyCurrentBookingUser';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
        },
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['message'] != 'Get my current booking.') {
        return;
      }
      final bookingData = List<Map<String, dynamic>>.from(data['data']);
      print(bookingData);
      final bookingsList = bookingData
          .map(
            (booking) => CustomerBooking(
              artistImage: booking['artistImage'],
              artistLocation: booking['artistLocation'],
              artistName: booking['artistName'],
              bookingDate: booking['booking_date'],
              bookingFlag: booking['booking_flag'],
              bookingTime: booking['booking_time'],
              categoryName: booking['category_name'],
              completePercentages: booking['completePercentages'],
              currencyType: booking['currency_type'],
              description: booking['description'],
              id: booking['id'],
              jobDone: booking['jobDone'],
              price: booking['price'],
              status: booking['status'],
              bookingType: booking['booking_type'],
              invoice: booking['invoice'] != null
                  ? Map<String, String>.from(booking['invoice'])
                  : {},
            ),
          )
          .toList();
      _bookings = bookingsList;
      _searchBookings = bookingsList;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getAllApplicants(String jobId) async {
    final url = '$base_url/get_applied_job_by_id';
    try {
      final response = await http.post(url, body: {
        'job_id': jobId,
      });
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body['message'] != 'All Jobs Found') {
        _applicants = [];
        _searchApplicants = [];
        notifyListeners();
        return;
      }
      if (body['data'] == null) {
        _applicants = [];
        _searchApplicants = [];
        notifyListeners();
        return;
      }
      final data = List<Map<String, dynamic>>.from(body['data']);

      final applicants = data
          .map(
            (job) => AppliedJob(
              id: job['aj_id'],
              userId: job['user_id'],
              artistId: job['artist_id'],
              jobId: job['job_id'],
              price: job['price'],
              description: job['description'],
              status: job['status'],
              createdAt: job['created_at'],
              updatedAt: job['updated_at'],
              currencySymbol: job['currency_symbol'],
              categoryName: job['category_name'],
              userImage: job['artist_image'],
              userName: job['artist_name'],
              userAddress: job['artist_address'],
              title: job['title'],
              jobDate: job['job_date'],
              time: job['time'],
              jobTimestamp: job['job_timestamp'],
              userMobile: job['artist_mobile'],
              userEemail: job['artist_email'],
              rate: job['ava_rating'],
            ),
          )
          .toList();
      _applicants = applicants;
      _searchApplicants = applicants;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getAllJobUser() async {
    final url = '$base_url/get_all_job_user';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
        },
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['message'] != 'All Jobs Found') {
        return;
      }
      final jobsData = List<Map<String, dynamic>>.from(responseData['data']);
      print(jobsData);
      final jobsList = jobsData
          .map(
            (job) => Job(
              id: job['id'],
              userId: job['user_id'],
              jobId: job['job_id'],
              address: job['address'],
              appliedJob: job['applied_job'],
              avtar: job['avtar'],
              categoryId: job['category_id'],
              categoryName: job['category_name'],
              categoryPrice: job['category_price'],
              createdAt: job['created_at'],
              currencySymbol: job['currency_symbol'],
              description: job['description'],
              isEdit: job['is_edit'],
              jobDate: job['job_date'],
              jobTimestamp: job['job_timestamp'],
              lati: job['lati'],
              longi: job['longi'],
              price: job['price'],
              status: job['status'],
              time: job['time'],
              title: job['title'],
              updatedAt: job['updated_at'],
            ),
          )
          .toList();
      _jobs = jobsList;
      _searchJobs = jobsList;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getAllCategories() async {
    final url = '$base_url/$_getAllCategory';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
        },
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['message'] != 'Get all Categories') {
        return;
      }
      final data = List<Map<String, dynamic>>.from(responseData['data']);
      final categoriesList = data
          .map((json) => Category(
                id: json['id'],
                currency: json['currency_type'],
                name: json['cat_name'],
                price: json['price'],
                subCategories: json['subcategories'],
                image: json['image'] != null &&
                        json['image'].toString().isNotEmpty
                    ? 'https://groceryone.salepe.in/assets/category/${json['image']}'
                    : '',
              ))
          .toList();
      _categories = categoriesList;
      notifyListeners();

      print('res type: ${categoriesList.length} ${responseData['data']}');
    } catch (err) {
      throw err;
    }
  }

  Future<void> getAllArtists() async {
    final url = '$base_url/$_getAllArtists';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
        },
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['message'] != 'Get all vendors') {
        return;
      }
      print('res artists: ${responseData['data']}');
      final data = List<Map<String, dynamic>>.from(responseData['data']);
      final artistsList = data
          .map(
            (json) => Artist(
              id: json['user_id'],
              name: json['name'],
              categoryId: json['category_id'],
              description: json['description'],
              aboutUs: json['about_us'],
              skills: json['skills'],
              image: json['image'],
              completionRate: json['completion_rate'],
              featured: json['featured'],
              createdAt: json['created_at'],
              updatedAt: json['updated_at'],
              bio: json['bio'],
              longitude: json['longitude'],
              latitude: json['latitude'],
              location: json['location'],
              liveLat: json['live_lat'],
              liveLong: json['live_long'],
              city: json['city'],
              country: json['country'],
              videoUrl: json['video_url'],
              price: json['price'],
              bookingFlag: json['booking_flag'],
              artistCommissionType: json['artist_commission_type'],
              isOnline: json['is_online'],
              gender: json['gender'],
              preference: json['preference'],
              updateProfile: json['update_profile'],
              bannerImage: json['banner_image'],
              total: json['total'],
              percentages: json['percentages'],
              jobDone: json['jobDone'],
              categoryName: json['category_name'],
              currencyType: json['currency_type'],
              commissionType: json['commission_type'],
              flatType: json['flat_type'],
              categoryPrice: json['category_price'],
              distance: json['distance'],
              avaRating: json['ava_rating'],
              favStatus: json['fav_status'],
            ),
          )
          .toList();
      _artists = artistsList;
      notifyListeners();
    } catch (err) {
      print('artists error $err');
      throw err;
    }
  }

  Future<void> getSubCategories(String catId) async {
    _subCategoriesList = [];
    final url = '$base_url/$_getAllCategory/$catId';
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': _userId,
        },
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['message'] != 'Get all Categories') {
        return null;
      }
      print('res type: ${responseData['data']}');
      final data = List<Map<String, dynamic>>.from(responseData['data']);
      final categoriesList = data
          .map(
            (json) => Category(
              id: json['id'],
              currency: json['currency_type'],
              name: json['cat_name'],
              price: json['price'],
              subCategories: json['subcategories'],
              image:
                  json['image'] != null && json['image'].toString().isNotEmpty
                      ? 'https://srm.salepe.in/assets/category/${json['image']}'
                      : '',
            ),
          )
          .toList();

      _subCategoriesList = categoriesList;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
