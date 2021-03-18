import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/screens/edit_artist_profile_screen.dart';
import 'package:service_app/screens/widgets/artist_profile_gallery_widget.dart';
import 'package:service_app/screens/widgets/artist_profile_info_widget.dart';
import 'package:service_app/screens/widgets/artist_profile_reviews_widget.dart';
import 'package:service_app/screens/widgets/artist_profile_services_widget.dart';
import 'package:service_app/screens/widgets/artist_profile_works_widget.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';

class ArtistProfileScreen extends StatefulWidget {
  static const routeName = '/artist-profile-screen';
  ArtistProfileScreen({Key key}) : super(key: key);

  @override
  _ArtistProfileScreenState createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen>
    with SingleTickerProviderStateMixin {
  bool isInit = true;
  TabController _tabController;
  PickedFile _image;
  final ImagePicker _picker = ImagePicker();
  Future<void> _getImage(ImageSource source) async {
    final pickedImage = await _picker.getImage(source: source);

    setState(() {
      _image = pickedImage;
    });
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 5,
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
      Provider.of<Auth>(context, listen: false).getArtistInfo('').then((value) {
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
                  "Service Vendor",
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
    final user = Provider.of<Auth>(context).currentUser;
    final artist = Provider.of<Auth>(context).artist;
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
        title: Text('Profile'),
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
                  ArtistProfileInfoWidget(),
                  ArtistProfileServicesWidget(),
                  ArtistProfileGalleryWidget(),
                  ArtistProfileWorksWidget(),
                  ArtistProfileReviewsWidget(),
                ],
              ),
              headerSliverBuilder: (ctx, _) => [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: CircleAvatar(
                                backgroundImage: _image == null
                                    ? NetworkImage(user.image)
                                    : FileImage(File(_image.path)),
                                radius: 60,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
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
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text(
                                              'Take Image from',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    _getImage(
                                                            ImageSource.camera)
                                                        .then((value) {
                                                      Provider.of<Auth>(
                                                        context,
                                                        listen: false,
                                                      )
                                                          .uploadProfilePicture(
                                                              _image.path)
                                                          .then(
                                                            (value) => Scaffold
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  value
                                                                      ? 'Profile has been updated successfully'
                                                                      : 'Faild to update!',
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                    });
                                                  },
                                                  child: Text(
                                                    'Camera',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        .copyWith(fontSize: 16),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 25,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    _getImage(
                                                            ImageSource.gallery)
                                                        .then((value) {
                                                      Provider.of<Auth>(
                                                        context,
                                                        listen: false,
                                                      ).uploadProfilePicture(
                                                          _image.path);
                                                    });
                                                  },
                                                  child: Text(
                                                    'Gallery',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        .copyWith(fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                        ),
                                        child: Text(
                                          'Change',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(color: Colors.white),
                                        ),
                                        height: 28,
                                        width: 68,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => EditArtistProfileScreen(
                                      bio: artist.bio,
                                      city: artist.city,
                                      categoryId: artist.categoryId,
                                      categoryName: artist.categoryName,
                                      country: artist.country,
                                      description: artist.aboutUs,
                                      lati: double.parse(artist.latitude),
                                      longi: double.parse(artist.longitude),
                                      name: artist.name,
                                      rate: artist.price,
                                      location: artist.location,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text(
                          artist.isOnline == '1' ? 'Online' : 'Offline',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        trailing: Switch(
                          value: artist.isOnline == '1',
                          onChanged: (val) {
                            Provider.of<Auth>(context, listen: false)
                                .changeIsOnline(val ? '1' : '0');
                          },
                        ),
                      ),
                      Center(
                        child: Text(
                          artist.categoryName,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: artist.location,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          artist.bio,
                          style: Theme.of(context).textTheme.headline6,
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
