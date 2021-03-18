import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/message_item_widget.dart';

class TicketsCommentsScreen extends StatefulWidget {
  final String id;

  TicketsCommentsScreen({
    @required this.id,
  });
  _TicketsCommentsScreen createState() => _TicketsCommentsScreen();
}

class _TicketsCommentsScreen extends State<TicketsCommentsScreen> {
  Future<void> _fMessages;
  String message = '';
  TextEditingController textFieldController;
  TextInputAction _textInputAction = TextInputAction.newline;

  @override
  void initState() {
    _fMessages = Provider.of<JobProvider>(
      context,
      listen: false,
    ).getTicketComments(widget.id);

    textFieldController = TextEditingController()
      ..addListener(() {
        setState(() {
          message = textFieldController.text;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<JobProvider>(context).ticketComments;
    final user = Provider.of<Auth>(context).currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text('Comment'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: FutureBuilder(
              future: _fMessages,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    );
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _fMessages =
                              Provider.of<JobProvider>(context, listen: false)
                                  .getTicketComments(widget.id);
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: ListView.builder(
                          // reverse: true,
                          itemCount: comments.length,
                          itemBuilder: (context, i) {
                            return MessageItemWidget(
                              content: comments[i].comment,
                              timestamp: DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(comments[i].createdAt) * 1000),
                              isYou: comments[i].userId != user.id,
                              fontSize: 14,
                            );
                          },
                        ),
                      ),
                    );
                }
                return null; //
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(const Radius.circular(30.0)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                controller: textFieldController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textInputAction: _textInputAction,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.only(left: 4.0),
                                  hintText: 'Type a message',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  counterText: '',
                                ),
                                onSubmitted: (String text) {
                                  if (_textInputAction ==
                                      TextInputAction.send) {}
                                },
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                maxLength: 100,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: message == null || message.isEmpty
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                              ),
                              onPressed: message == null || message.length <= 0
                                  ? null
                                  : () async {
                                      FocusScope.of(context).unfocus();
                                      String comment = textFieldController.text;
                                      textFieldController.text = '';
                                      message = '';
                                      await Provider.of<JobProvider>(context,
                                              listen: false)
                                          .sendComment(widget.id, comment)
                                          .then((isSent) {
                                        if (!isSent) {
                                          _showErrorDialog(
                                            'Unable to send your comment, please try again later',
                                          );
                                        }
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
