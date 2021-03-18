import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:service_app/screens/widgets/receipt_item_widget.dart';

class ReceiptScreen extends StatefulWidget {
  static const routeName = '/receipt-screen';

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  bool isInit = true;
  String isPaid = '1';
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Customer>(context, listen: false)
          .getMyInvoice(
              Provider.of<Auth>(context, listen: false).currentUser.isCustomer)
          .then((value) {
        setState(() {
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final invoices = Provider.of<Customer>(context)
        .invoices
        .where((invoice) => invoice.flag == isPaid)
        .toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Receipt'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => CustomDrawer.of(context).open(),
            );
          },
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          setState(() {
            isPaid == '1' ? isPaid = '0' : isPaid = '1';
          });
        },
        child: Container(
          alignment: Alignment.center,
          width: 100,
          height: 40,
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 4,
            bottom: 4,
          ),
          child: Text(
            isPaid == '1' ? 'Unpaid' : 'Paid',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: invoices[i],
                child: ReceiptItemWidget(),
              ),
              itemCount: invoices.length,
            ),
    );
  }
}
