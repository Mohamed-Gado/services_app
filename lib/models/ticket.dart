class Ticket {
  String id;
  String userId;
  String reason;
  String description;
  String status;
  String createdAt;

  Ticket({
    this.createdAt,
    this.description,
    this.id,
    this.reason,
    this.status,
    this.userId,
  });
}
