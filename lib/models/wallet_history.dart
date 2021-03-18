class WalletHistory {
  String id;
  String description;
  String amount;
  String invoiceId;
  String currency;
  String type;
  String status;
  String orderId;
  String createdAt;

  WalletHistory({
    this.amount,
    this.createdAt,
    this.currency,
    this.description,
    this.id,
    this.invoiceId,
    this.orderId,
    this.status,
    this.type,
  });
}
