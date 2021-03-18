import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/widgets/wallet_history_item_widget.dart';

class StatusWalletHistoryWidget extends StatefulWidget {
  final String status;
  StatusWalletHistoryWidget({
    Key key,
    @required this.status,
  }) : super(key: key);

  @override
  _StatusWalletHistoryWidgetState createState() =>
      _StatusWalletHistoryWidgetState();
}

class _StatusWalletHistoryWidgetState extends State<StatusWalletHistoryWidget> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Customer>(context, listen: false)
          .getWalletHistoryWithStatus(widget.status)
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
    final walletHistory = widget.status == '1'
        ? Provider.of<Customer>(context).debitHistory
        : Provider.of<Customer>(context).creditHistory;
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
