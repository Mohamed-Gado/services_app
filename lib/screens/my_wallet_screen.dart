import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/add_money_screen.dart';
import 'package:service_app/screens/widgets/all_wallet_history_widget.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:service_app/screens/widgets/status_wallet_history_widget.dart';

class MyWalletScreen extends StatefulWidget {
  static const routeName = '/my-wallet-screen';

  @override
  _MyWalletScreenState createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen>
    with SingleTickerProviderStateMixin {
  bool isInit = true;
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController.addListener(_tabChanged);
    super.initState();
  }

  void _tabChanged() {
    if (_tabController.indexIsChanging) {
      print('tabChanged: ${_tabController.index}');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  SliverPersistentHeader makeTabBarHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 50.0,
        child: Container(
          color: Colors.white,
          child: TabBar(
            onTap: (val) {},
            unselectedLabelColor: Colors.grey.shade700,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 2.0,
            labelColor: Theme.of(context).primaryColor,
            controller: _tabController,
            tabs: <Widget>[
              new Tab(
                child: Text(
                  'All',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              new Tab(
                child: Text(
                  "Debit",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              new Tab(
                child: Text(
                  "Credit",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ],
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wallet = Provider.of<Customer>(context).wallet;

    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => CustomDrawer.of(context).open(),
            );
          },
        ),
        elevation: 0,
        title: Text('My Wallet'),
        centerTitle: true,
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : NestedScrollView(
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  AllWalletHistoryWideget(),
                  StatusWalletHistoryWidget(status: '1'),
                  StatusWalletHistoryWidget(status: '0'),
                ],
              ),
              headerSliverBuilder: (ctx, isb) => [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding: EdgeInsets.all(16.0),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Current Amount\n',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            color: Colors.grey, fontSize: 16),
                                  ),
                                  TextSpan(
                                    text: '${wallet.currency}${wallet.amount}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 45,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => AddMoneyWidget(
                                      amount: wallet.amount,
                                      currency: wallet.currency,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                makeTabBarHeader(),
              ],
            ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
