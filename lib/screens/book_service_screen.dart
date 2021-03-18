import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:service_app/screens/book_artist_screen.dart';
import 'package:service_app/screens/show_image_screen.dart';

class BookServiceScreen extends StatefulWidget {
  final List products;
  final String artistId;
  final String artistName;
  final String artistCat;
  final String artistImage;
  const BookServiceScreen({
    Key key,
    @required this.products,
    @required this.artistName,
    @required this.artistCat,
    @required this.artistImage,
    @required this.artistId,
  }) : super(key: key);

  @override
  _BookServiceScreenState createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  List<String> selected = [];
  double totalPrice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          color: Colors.white,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            onPressed: () {
              if (selected.isEmpty) {
                Fluttertoast.showToast(
                    msg: 'Please select at least one product');
                return;
              }
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                        builder: (ctx) => BookArtistScreen(
                              artistCat: widget.artistCat,
                              artistImage: widget.artistImage,
                              artistName: widget.artistName,
                              currency: widget.products[0]['currency_type'],
                              price: totalPrice,
                              artistId: widget.artistId,
                              selectedList: selected.toString(),
                            )),
                  )
                  .then((value) => Navigator.of(context).pop());
            },
            color: Theme.of(context).primaryColor,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Text(
                selected.length <= 0 && widget.products.length <= 0
                    ? 'BOOK'
                    : 'BOOK ${widget.products[0]['currency_type']} $totalPrice',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text('Services'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.products.length,
        itemBuilder: (ctx, i) {
          return GridTile(
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ShowImageScreen(
                    imageUrl: widget.products[i]['product_image'],
                  ),
                ),
              ),
              child: FadeInImage(
                placeholder: AssetImage('assets/images/mapimg.jpg'),
                image: NetworkImage('${widget.products[i]['product_image']}'),
                fit: BoxFit.cover,
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black26,
              title: Text(widget.products[i]['product_name']),
              subtitle: Text(
                widget.products[i]['currency_type'] +
                    widget.products[i]['price'],
              ),
            ),
            header: GridTileBar(
              leading: SizedBox(),
              title: SizedBox(),
              trailing: IconButton(
                icon: Icon(
                  selected.contains(widget.products[i]['id'])
                      ? Icons.check_box
                      : Icons.crop_square,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  if (selected.contains(widget.products[i]['id'])) {
                    setState(() {
                      selected.remove(widget.products[i]['id']);
                      totalPrice = totalPrice -
                          double.parse(widget.products[i]['price'].toString());
                    });
                  } else {
                    setState(() {
                      selected.add(widget.products[i]['id']);
                      totalPrice = totalPrice +
                          double.parse(widget.products[i]['price'].toString());
                    });
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
