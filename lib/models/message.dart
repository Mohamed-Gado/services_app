class Message {
  String id;
  String message;
  String date;
  String sender;
  String sendBy;
  String chatType;
  String image;

  Message({
    this.chatType,
    this.date,
    this.id,
    this.image,
    this.message,
    this.sendBy,
    this.sender,
  });
}
