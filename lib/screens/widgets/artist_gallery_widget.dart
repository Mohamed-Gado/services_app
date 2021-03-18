import 'package:flutter/material.dart';

class ArtistGalleryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> gallery;
  const ArtistGalleryWidget({
    Key key,
    @required this.gallery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: gallery.length,
      itemBuilder: (ctx, i) {
        return GridTile(
          child: FadeInImage(
            placeholder: AssetImage('assets/images/mapimg.jpg'),
            image: NetworkImage(gallery[i]['image']),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
