class Truck {
  final int? id;
  final String name;
  final String licensePlate;
  final String type;
  final double maxWeight;
  final double maxVolume;
  final double pricePerKm;
  final String? description;
  final String? photoPath;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Truck({
    this.id,
    required this.name,
    required this.licensePlate,
    required this.type,
    required this.maxWeight,
    required this.maxVolume,
    required this.pricePerKm,
    this.description,
    this.photoPath,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Truck.fromJson(Map<String, dynamic> json) {
    return Truck(
      id: json['id'],
      name: json['name'] ?? '',
      licensePlate: json['license_plate'] ?? '',
      type: json['type'] ?? '',
      maxWeight: double.parse(json['max_weight'].toString()),
      maxVolume: double.parse(json['max_volume'].toString()),
      pricePerKm: double.parse(json['price_per_km'].toString()),
      description: json['description'],
      photoPath: json['photo_url'],
      status: json['status'] ?? '',
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
      'name': name,
      'license_plate': licensePlate,
      'type': type,
      'max_weight': maxWeight,
      'max_volume': maxVolume,
      'price_per_km': pricePerKm,
      'description': description,
      'photo_path': photoPath,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
