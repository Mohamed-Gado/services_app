import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_app/screens/show_image_screen.dart';

class MessageItemWidget extends StatelessWidget {
  final String content;
  final DateTime timestamp;
  final bool isYou;
  final double fontSize;
  final String image;

  MessageItemWidget({
    this.content,
    this.timestamp,
    this.isYou,
    this.fontSize,
    this.image = '',
  });

  @override
  Widget build(BuildContext context) {
    return _buildMessage(context);
  }

  Widget _buildMessage(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment:
              isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.grey,
                          offset: new Offset(1.0, 1.0),
                          blurRadius: 1.0)
                    ],
                    color: isYou ? Colors.purple[200] : Colors.grey[400],
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                constraints: BoxConstraints(
                  minWidth: 100.0,
                  maxWidth: 280.0,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    if (image != '')
                      GestureDetector(
                        onTap: () => Navigator.of(ctx).push(
                          MaterialPageRoute(
                            builder: (ctx) => ShowImageScreen(imageUrl: image),
                          ),
                        ),
                        child: Container(
                          height: 150,
                          width: 100,
                          color: Colors.transparent,
                          child: Image.network(image),
                          alignment: Alignment.center,
                        ),
                      ),
                    Container(
                      constraints: BoxConstraints(
                        minWidth: 100.0,
                      ),
                      child: Text(
                        content,
                        style: Theme.of(ctx).textTheme.headline6,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 100.0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(
                                width: 4.0,
                              ),
                              isYou
                                  ? Icon(
                                      Icons.done_all,
                                      size: 18.0,
                                      color: Colors.grey,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Center(
          child: Text(
            DateFormat.yMEd().add_jms().format(timestamp),
            style: Theme.of(ctx).textTheme.headline6.copyWith(
                  fontSize: 10,
                  color: Colors.grey,
                ),
          ),
        ),
      ],
    );
  }
}
