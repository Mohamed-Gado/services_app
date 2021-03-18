import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';

class ArtistProfileGalleryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final artist = Provider.of<Auth>(context).artist;
    PickedFile _image;
    final ImagePicker _picker = ImagePicker();
    Future<void> _getImage(ImageSource source) async {
      final pickedImage = await _picker.getImage(source: source);
      _image = pickedImage;
    }

    return GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: artist.gallery.length + 1,
        itemBuilder: (ctx, i) {
          return i == 0
              ? GridTile(
                  child: GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            'Take Image from',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
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
                                  _getImage(ImageSource.camera).then((value) {
                                    Provider.of<Auth>(context, listen: false)
                                        .uploadGalleryImage(
                                            filePath: _image.path)
                                        .then((value) => showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title:
                                                    Text('An error Occurred!'),
                                                content: Text(value),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            ));
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
                                  _getImage(ImageSource.gallery).then((value) {
                                    Provider.of<Auth>(context, listen: false)
                                        .uploadGalleryImage(
                                            filePath: _image.path)
                                        .then((value) => showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title:
                                                    Text('An error Occurred!'),
                                                content: Text(value),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            ));
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
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
                    image: NetworkImage(artist.gallery[i - 1]['image']),
                    fit: BoxFit.cover,
                  ),
                  header: GridTileBar(
                    trailing: IconButton(
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
                                      .deleteGallery(
                                          artist.gallery[i - 1]['id']);
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
        });
  }
}
