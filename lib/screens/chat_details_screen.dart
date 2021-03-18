import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/widgets/message_item_widget.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String id;
  final String name;

  ChatDetailsScreen({
    this.id,
    @required this.name,
  });
  _ChatDetailsScreen createState() => _ChatDetailsScreen();
}

class _ChatDetailsScreen extends State<ChatDetailsScreen> {
  Future<void> _fMessages;
  Map<String, String> _msgData = {
    'user_id': '',
    'artist_id': '',
    'message': '',
    'sender_name': '',
  };
  TextEditingController textFieldController;
  TextInputAction _textInputAction = TextInputAction.newline;
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
    _fMessages = Provider.of<Customer>(
      context,
      listen: false,
    ).getChat(Provider.of<Auth>(context, listen: false).currentUser.isCustomer,
        widget.id);

    textFieldController = TextEditingController()
      ..addListener(() {
        setState(() {
          _msgData['message'] = textFieldController.text;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).currentUser;
    final messages = Provider.of<Customer>(context).messages;
    if (user.isCustomer) {
      _msgData['artist_id'] = widget.id;
      _msgData['user_id'] = user.id;
    } else {
      _msgData['artist_id'] = user.id;
      _msgData['user_id'] = widget.id;
    }
    _msgData['sender_name'] = user.name;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(widget.name),
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
                              Provider.of<Customer>(context, listen: false)
                                  .getChat(user.isCustomer, widget.id);
                        });
                      },
                      child: ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, i) {
                          return MessageItemWidget(
                            image: messages[i].image,
                            content: messages[i].message,
                            timestamp: DateTime.fromMillisecondsSinceEpoch(
                                int.parse(messages[i].date) * 1000),
                            isYou: messages[i].sendBy == user.id,
                            fontSize: 14,
                          );
                        },
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
                if (_image != null)
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerRight,
                    height: 150,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Image.file(
                        File(_image.path),
                      ),
                    ),
                  ),
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
                            IconButton(
                              color: Colors.grey,
                              icon: Icon(Icons.attach_file),
                              onPressed: () async {
                                await _getImage(ImageSource.gallery);
                              },
                            ),
                            _msgData['message'].isEmpty ||
                                    _msgData['message'] == null
                                ? IconButton(
                                    color: Colors.grey,
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: () async {
                                      await _getImage(ImageSource.camera);
                                    },
                                  )
                                : Container(),
                            Flexible(
                              child: TextField(
                                controller: textFieldController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textInputAction: _textInputAction,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(0.0),
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
                                color: _msgData['message'].isEmpty ||
                                        _msgData['message'] == null
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                              ),
                              onPressed: _msgData['message'].isEmpty ||
                                      _msgData['message'] == null
                                  ? null
                                  : () {
                                      Provider.of<Customer>(context,
                                              listen: false)
                                          .sendMessage(
                                              _image != null ? _image.path : '',
                                              _msgData)
                                          .then((value) {
                                        _image = null;
                                        textFieldController.text = '';
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
}
