import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/widgets/choose_payment_widget.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment-screen';

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isCheck = false;
  bool isInit = true;
  bool isApplied = false;
  String finalAmount = '';
  String discount = '0';
  final TextEditingController _codeController = TextEditingController();

  Razorpay _razorpay;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Customer>(context, listen: false).getWallet().then((value) {
        setState(() {
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("SUCCESS: " + response.paymentId);
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("ERROR: " + response.code.toString() + " - " + response.message);
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET: " + response.walletName);
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  void openCheckout(
      BuildContext context, String amount, String currency) async {
    print('error: amount: ${(double.parse(amount) * 100).round()}');
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': (double.parse(amount) * 100).round(),
      'currency': currency == '₹' ? 'INR' : 'USD',
      'name': 'Test Service',
      'description':
          Provider.of<Auth>(context, listen: false).currentUser.isCustomer
              ? 'Customer'
              : 'Vendor',
      'image': 'https://rzp-mobile.s3.amazonaws.com/images/rzp.png',
      'prefill': {'contact': '9898989898', 'email': 'testuser@gmail.com'},
      'theme.color': '#0d1543',
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallet = Provider.of<Customer>(context, listen: false).wallet;
    final invoiceId = ModalRoute.of(context).settings.arguments as String;
    final invoice = Provider.of<Customer>(context)
        .invoices
        .firstWhere((element) => element.id == invoiceId);
    if (finalAmount.isEmpty) {
      finalAmount = invoice.finalAmount;
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Payment'),
          centerTitle: true,
          leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Work Completed',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: invoice.artistImage != null &&
                                invoice.artistImage != ''
                            ? NetworkImage(invoice.artistImage)
                            : AssetImage('assets/images/dummyuser_image.jpg'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              invoice.artistName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(invoice.categoryName),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.location_on,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: invoice.address,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                )),
                Divider(),
                Text('Apply PromoCode',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.grey, fontSize: 16)),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: !isApplied,
                    controller: _codeController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Write Code Here',
                      suffixIcon: FlatButton(
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            'Apply Code',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        onPressed: isCheck
                            ? null
                            : () {
                                setState(() {
                                  isCheck = true;
                                });
                                Provider.of<Customer>(context, listen: false)
                                    .checkCoupon(
                                        invoiceId, _codeController.text)
                                    .then((value) {
                                  setState(() {
                                    isCheck = false;
                                    isApplied = value.isNotEmpty;
                                    if (value.isNotEmpty) {
                                      finalAmount = value['final_amount'];
                                      discount = value['discount_amount'];
                                    }
                                  });
                                });
                              },
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 32.0,
                    padding: EdgeInsets.all(8.0),
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     width: 1.5,
                    //     color: Theme.of(context).primaryColor,
                    //   ),
                    //   borderRadius: BorderRadius.circular(8.0),
                    // ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Total Amount\n',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                          TextSpan(
                            text: '${invoice.currency}${invoice.totalAmount}',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 6.0),
                  child: FlatButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isDismissible: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return ChoosePaymentWidget(
                            amount: invoice.totalAmount,
                          );
                        },
                      ).then((value) {
                        if (value) {
                          openCheckout(
                              context, invoice.totalAmount, wallet.currency);
                        }
                      });
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 16.0,
                      child: Text(
                        'Online Payment',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                      ),
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6.0, bottom: 12.0),
                  child: FlatButton(
                    onPressed: () {
                      Provider.of<Customer>(context, listen: false)
                          .sendPayment(
                              amount: finalAmount,
                              couponCode: _codeController.text,
                              discount: discount,
                              invoiceId: invoiceId,
                              type: '1')
                          .then((value) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Payment Process'),
                            content: Text(
                                value ? 'Process Success' : 'Process Faild'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        ).then((value) => Navigator.of(context).pop());
                      });
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 16.0,
                      child: Text(
                        'Cash Payment',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                      ),
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    if (double.parse(wallet.amount) >=
                        double.parse(finalAmount)) {
                      Provider.of<Customer>(context, listen: false)
                          .sendPayment(
                              amount: finalAmount,
                              couponCode: _codeController.text,
                              discount: discount,
                              invoiceId: invoiceId,
                              type: '2')
                          .then((value) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Payment Process'),
                            content: Text(
                                value ? 'Process Success' : 'Process Faild'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        ).then((value) => Navigator.of(context).pop());
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: 'You don\'t have enough credit');
                    }
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 16.0,
                    child: Text(
                      'Pay By Wallet',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                    ),
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
