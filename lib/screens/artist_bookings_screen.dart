import 'dart:math';

import 'package:flutter/material.dart';
import 'package:service_app/screens/widgets/accepted_bookings_widget.dart';
import 'package:service_app/screens/widgets/binding_bookings_widget.dart';
import 'package:service_app/screens/widgets/bottom_ff_navbar_widget.dart';
import 'package:service_app/screens/widgets/completed_bookings_widget.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:service_app/screens/widgets/rejected_bookings_widget.dart';

class ArtistBookingsScreen extends StatefulWidget {
  static const routeName = '/artist-booking-screen';
  ArtistBookingsScreen({Key key}) : super(key: key);

  @override
  _ArtistBookingsScreenState createState() => _ArtistBookingsScreenState();
}

class _ArtistBookingsScreenState extends State<ArtistBookingsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
    _tabController.addListener(_tabChanged);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _tabChanged() {
    if (_tabController.indexIsChanging) {
      print('tabChanged: ${_tabController.index}');
    }
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
                child: Icon(
                  Icons.access_time,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              new Tab(
                child: Icon(
                  Icons.fact_check,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              new Tab(
                child: Icon(
                  Icons.do_not_disturb_off,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              new Tab(
                child: Icon(
                  Icons.check_box,
                  color: Theme.of(context).primaryColor,
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
    return Scaffold(
      // drawer: AppDrawer(),
      bottomNavigationBar: BottomFFNavbarWidget(
        index: 1,
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => CustomDrawer.of(context).open(),
            );
          },
        ),
        title: Text('Bookings'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          makeTabBarHeader(),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                BindingBookingsWidget(),
                AcceptedBookingsWidget(),
                RejectedBookingsWidget(),
                CompletedBookingsWidget(),
              ],
            ),
          ),
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
