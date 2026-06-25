import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          children: [
            const Text('Hubungi Kami', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('Ada pertanyaan atau butuh bantuan darurat? Hubungi customer support kami.', style: TextStyle(color: Color(0xFF64748B), fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 48),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 800) {
                      return Row(
                        children: [
                          Expanded(child: _buildContactCard('📞', 'Telepon', '+62 812-3456-7890', 'Senin - Minggu (24 Jam)')),
                          const SizedBox(width: 24),
                          Expanded(child: _buildContactCard('✉️', 'E-mail', 'support@truckbooking.com', 'Balasan dalam waktu 1 jam')),
                          const SizedBox(width: 24),
                          Expanded(child: _buildContactCard('📍', 'Kantor Pusat', 'Gedung Logistik Jaya, Lt. 3, Jl. Gatot Subroto No. 45, Jakarta Selatan', '')),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildContactCard('📞', 'Telepon', '+62 812-3456-7890', 'Senin - Minggu (24 Jam)'),
                          const SizedBox(height: 24),
                          _buildContactCard('✉️', 'E-mail', 'support@truckbooking.com', 'Balasan dalam waktu 1 jam'),
                          const SizedBox(height: 24),
                          _buildContactCard('📍', 'Kantor Pusat', 'Gedung Logistik Jaya, Lt. 3, Jl. Gatot Subroto No. 45, Jakarta Selatan', ''),
                        ],
                      );
                    }
                  }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(String icon, String title, String value, String sub) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 16),
          Text(value, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF64748B), height: 1.5)),
          if (sub.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(sub, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          ]
        ],
      ),
    );
  }
}
