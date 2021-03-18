import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/widgets/artist_item_widget.dart';

class ArtistsListWidget extends StatefulWidget {
  @override
  _ArtistsListWidgetState createState() => _ArtistsListWidgetState();
}

class _ArtistsListWidgetState extends State<ArtistsListWidget> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Customer>(context, listen: false)
          .getAllArtists()
          .then((value) {
        setState(() {
          Provider.of<Customer>(context, listen: false)
              .filterByCategories('all');
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final artistsList = Provider.of<Customer>(context).catArtist;
    return isInit
        ? Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : artistsList.length <= 0
            ? Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Center(
                    child: Text(
                  'No Workers Found',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                      ),
                )),
              )
            : ListView.builder(
                itemCount: artistsList.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: artistsList[i],
                  child: ArtistItemWidget(),
                ),
              );
  }
}
