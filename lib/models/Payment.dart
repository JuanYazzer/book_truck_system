class Payment {
  final int? id;
  final int bookingId;
  final String? midtransOrderId;
  final String? midtransTransactionId;
  final String paymentType;
  final double amount;
  final String status;
  final DateTime? paidAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Payment({
    this.id,
    required this.bookingId,
    this.midtransOrderId,
    this.midtransTransactionId,
    required this.paymentType,
    required this.amount,
    required this.status,
    this.paidAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      bookingId: json['booking_id'],
      midtransOrderId: json['midtrans_order_id'],
      midtransTransactionId: json['midtrans_transaction_id'],
      paymentType: json['payment_type'] ?? '',
      amount: double.parse(json['amount'].toString()),
      status: json['status'] ?? '',
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'midtrans_order_id': midtransOrderId,
      'midtrans_transaction_id': midtransTransactionId,
      'payment_type': paymentType,
      'amount': amount,
      'status': status,
      'paid_at': paidAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
