import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/screens/book_artist_screen.dart';
import 'package:service_app/screens/book_service_screen.dart';
import 'package:service_app/screens/chat_details_screen.dart';
import 'package:service_app/screens/widgets/artist_gallery_widget.dart';
import 'package:service_app/screens/widgets/artist_info_widget.dart';
import 'package:service_app/screens/widgets/artist_profile_reviews_widget.dart';
import 'package:service_app/screens/widgets/artist_profile_works_widget.dart';

class ArtistDetailsScreen extends StatefulWidget {
  final artistId;
  const ArtistDetailsScreen({
    @required this.artistId,
  });
  @override
  _ArtistDetailsScreenState createState() => _ArtistDetailsScreenState();
}

class _ArtistDetailsScreenState extends State<ArtistDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool isInit = true;
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
      Provider.of<Auth>(context, listen: false)
          .getArtistInfo(widget.artistId)
          .then((value) {
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
                  'Info',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              new Tab(
                child: Text(
                  "Gallery",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              new Tab(
                child: Text(
                  "Works",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              new Tab(
                child: Text(
                  "Reviews",
                  style: TextStyle(fontSize: 10),
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
    final artist = Provider.of<Auth>(context).artist;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 4,
          right: 4,
        ),
        child: BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ChatDetailsScreen(
                              id: artist.id,
                              name: artist.name,
                            )));
                  },
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    child: Text(
                      'CHAT',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => BookArtistScreen(
                          currency: artist.currencyType,
                          price: double.parse(artist.price),
                          selectedList: '',
                          artistCat: artist.categoryName,
                          artistImage: artist.image,
                          artistName: artist.name,
                          artistId: artist.id,
                        ),
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    child: Text(
                      'BOOK',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => BookServiceScreen(
                          products: artist.products,
                          artistCat: artist.categoryName,
                          artistImage: artist.image,
                          artistName: artist.name,
                          artistId: artist.id,
                        ),
                      ),
                    );
                  },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Container(
                    child: Text(
                      'SERVICES',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text('Artist Profile'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              !isInit && artist.favStatus == '1'
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: isInit
                ? null
                : () {
                    artist.favStatus == '1'
                        ? Provider.of<Auth>(context, listen: false)
                            .removeFavouriteArtist(artist.id)
                        : Provider.of<Auth>(context, listen: false)
                            .addFavouriteArtist(artist.id);
                  },
          ),
        ],
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : NestedScrollView(
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ArtistInfoWidget(
                    avaRating: artist.avaRating,
                    bio: artist.bio,
                    currency: artist.currencyType,
                    jobDone: artist.jobDone,
                    location: artist.location,
                    percentages: artist.percentages,
                    price: artist.price,
                    rateType: artist.commissionType == '0'
                        ? 'Hour Rating'
                        : 'Fixed Rating',
                    qualifications: artist.qualifications,
                  ),
                  ArtistGalleryWidget(gallery: artist.gallery),
                  ArtistProfileWorksWidget(),
                  Padding(
                      padding: EdgeInsets.only(
                          right: 12, left: 12, top: 4.0, bottom: 4.0),
                      child: ArtistProfileReviewsWidget()),
                ],
              ),
              headerSliverBuilder: (ctx, _) => [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: CircleAvatar(
                                backgroundImage: artist.image != null &&
                                        artist.image.isNotEmpty
                                    ? NetworkImage(artist.image)
                                    : AssetImage(
                                        'assets/images/dummyuser_image.jpg'),
                                radius: 60,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      artist.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      artist.categoryName,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                ],
                              ),
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
