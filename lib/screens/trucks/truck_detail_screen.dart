import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/Truck.dart';
import '../bookings/create_booking_screen.dart';
import '../auth/login_screen.dart';

class TruckDetailScreen extends StatelessWidget {
  final Truck truck;

  const TruckDetailScreen({Key? key, required this.truck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(truck.name, style: const TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: truck.photoPath != null
                  ? Image.network(
                      truck.photoPath!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.local_shipping, size: 100, color: Colors.lightBlue),
                    )
                  : const Icon(Icons.local_shipping, size: 100, color: Colors.lightBlue),
            ),
            const SizedBox(height: 24),
            Text(truck.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: truck.status == 'available' ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    truck.status.toUpperCase(),
                    style: TextStyle(
                      color: truck.status == 'available' ? Colors.green.shade800 : Colors.red.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text('Rp ${truck.pricePerKm} / km', style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Spesifikasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildSpecRow('Tipe', truck.type),
            _buildSpecRow('Plat Nomor', truck.licensePlate),
            _buildSpecRow('Kapasitas Berat', '${truck.maxWeight} Ton'),
            _buildSpecRow('Kapasitas Volume', '${truck.maxVolume} m³'),
            const SizedBox(height: 24),
            if (truck.description != null && truck.description!.isNotEmpty) ...[
              const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(truck.description!, style: const TextStyle(color: Colors.black87, height: 1.5)),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: truck.status == 'available'
              ? () async {
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('auth_token');
                  if (!context.mounted) return;
                  if (token == null || token.isEmpty) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBookingScreen(truck: truck)));
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('PESAN TRUK INI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
