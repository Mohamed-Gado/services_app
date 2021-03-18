import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/widgets/wallet_history_item_widget.dart';

class AllWalletHistoryWideget extends StatefulWidget {
  AllWalletHistoryWideget({Key key}) : super(key: key);

  @override
  _AllWalletHistoryWidegetState createState() =>
      _AllWalletHistoryWidegetState();
}

class _AllWalletHistoryWidegetState extends State<AllWalletHistoryWideget> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Customer>(context, listen: false)
          .getAllWalletHistory()
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
    final walletHistory = Provider.of<Customer>(context).walletHistory;
    return isInit
        ? Center(
            child: CircularProgressIndicator(),
          )
        : walletHistory.length <= 0
            ? Center(
                child: Text(
                  'No History to Show',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                ),
              )
            : ListView(
                children: walletHistory
                    .map(
                      (item) => WalletHistoryItemWidget(item: item),
                    )
                    .toList(),
              );
  }
}
