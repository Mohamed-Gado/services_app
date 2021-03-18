import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/screens/widgets/artist_add_product_widget.dart';

class ArtistProfileServicesWidget extends StatefulWidget {
  @override
  _ArtistProfileServicesWidgetState createState() =>
      _ArtistProfileServicesWidgetState();
}

class _ArtistProfileServicesWidgetState
    extends State<ArtistProfileServicesWidget> {
  @override
  Widget build(BuildContext context) {
    final artist = Provider.of<Auth>(context).artist;
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: artist.products.length + 1,
      itemBuilder: (ctx, i) {
        return i == 0
            ? GridTile(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isDismissible: false,
                      isScrollControlled: true,
                      context: context,
                      builder: (_) => ArtistAddProductWidget(),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Add',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                    ),
                  ),
                ),
              )
            : GridTile(
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/mapimg.jpg'),
                  image: NetworkImage(
                      '${artist.products[i - 1]['product_image']}'),
                  fit: BoxFit.cover,
                ),
                footer: GridTileBar(
                  backgroundColor: Colors.black26,
                  title: Text(artist.products[i - 1]['product_name']),
                  subtitle: Text(
                    artist.products[i - 1]['currency_type'] +
                        artist.products[i - 1]['price'],
                  ),
                ),
                header: GridTileBar(
                  leading: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => new AlertDialog(
                          title: new Text('Uclab Service App?'),
                          content: new Text(
                              'Are you sure you want to delete this Product?'),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: new Text('No'),
                            ),
                            new FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Provider.of<Auth>(context, listen: false)
                                    .deleteProduct(
                                        artist.products[i - 1]['id']);
                              },
                              child: new Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
      },
    );
  }
}
