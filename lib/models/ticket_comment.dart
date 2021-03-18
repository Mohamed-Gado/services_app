class TicketComment {
  String id;
  String ticketId;
  String comment;
  String role;
  String userId;
  String createdAt;
  String userName;

  TicketComment({
    this.comment,
    this.createdAt,
    this.id,
    this.role,
    this.ticketId,
    this.userName,
    this.userId,
  });
}
