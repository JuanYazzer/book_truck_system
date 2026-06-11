class Booking {
  final int? id;
  final String bookingNumber;
  final int userId;
  final int truckId;
  final String customerName;
  final String customerPhone;
  final double cargoWeight;
  final double cargoVolume;
  final String cargoType;
  final String pickupAddress;
  final String destinationAddress;
  final double distanceKm;
  final DateTime pickupDate;
  final DateTime deliveryDate;
  final double estimatedPrice;
  final double dpAmount;
  final double remainingAmount;
  final String status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Booking({
    this.id,
    required this.bookingNumber,
    required this.userId,
    required this.truckId,
    required this.customerName,
    required this.customerPhone,
    required this.cargoWeight,
    required this.cargoVolume,
    required this.cargoType,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.distanceKm,
    required this.pickupDate,
    required this.deliveryDate,
    required this.estimatedPrice,
    required this.dpAmount,
    required this.remainingAmount,
    required this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      bookingNumber: json['booking_number'] ?? '',
      userId: json['user_id'],
      truckId: json['truck_id'],
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      cargoWeight: double.parse(json['cargo_weight'].toString()),
      cargoVolume: double.parse(json['cargo_volume'].toString()),
      cargoType: json['cargo_type'] ?? '',
      pickupAddress: json['pickup_address'] ?? '',
      destinationAddress: json['destination_address'] ?? '',
      distanceKm: double.parse(json['distance_km'].toString()),
      pickupDate: DateTime.parse(json['pickup_date']),
      deliveryDate: DateTime.parse(json['delivery_date']),
      estimatedPrice: double.parse(json['estimated_price'].toString()),
      dpAmount: double.parse(json['dp_amount'].toString()),
      remainingAmount: double.parse(json['remaining_amount'].toString()),
      status: json['status'] ?? '',
      notes: json['notes'],
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
      'booking_number': bookingNumber,
      'user_id': userId,
      'truck_id': truckId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'cargo_weight': cargoWeight,
      'cargo_volume': cargoVolume,
      'cargo_type': cargoType,
      'pickup_address': pickupAddress,
      'destination_address': destinationAddress,
      'distance_km': distanceKm,
      'pickup_date': pickupDate.toIso8601String(),
      'delivery_date': deliveryDate.toIso8601String(),
      'estimated_price': estimatedPrice,
      'dp_amount': dpAmount,
      'remaining_amount': remainingAmount,
      'status': status,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
