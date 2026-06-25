import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          children: [
            const Text('Tentang Kami', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('Kenali lebih dekat perjalanan logistik digital kami.', style: TextStyle(color: Color(0xFF64748B), fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 48),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Siapa Kami', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 16),
                    const Text('Truck Booking System adalah penyedia solusi transportasi logistik terintegrasi berbasis teknologi. Didirikan pada tahun 2020, kami berkomitmen untuk mendigitalisasi proses sewa truk bagi UKM dan industri besar untuk efisiensi rantai pasok.\n\nKami membangun platform ini dengan tujuan menghilangkan perantara dan memberikan transparansi harga penuh bagi para penyewa barang, meminimalkan waktu tunggu, dan memaksimalkan pendapatan para pemilik truk mitra logistik kami.', style: TextStyle(color: Color(0xFF475569), height: 1.6)),
                    const SizedBox(height: 32),
                    const Divider(color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 32),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 600) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildVisi()),
                              const SizedBox(width: 32),
                              Expanded(child: _buildMisi()),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildVisi(),
                              const SizedBox(height: 32),
                              _buildMisi(),
                            ],
                          );
                        }
                      }
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildVisi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Visi Kami', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        SizedBox(height: 16),
        Text('Menjadi platform logistik terdepan di Indonesia yang mengutamakan keselamatan, transparansi harga, dan pelayanan prima.', style: TextStyle(color: Color(0xFF475569), height: 1.6)),
      ],
    );
  }

  Widget _buildMisi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Misi Kami', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        SizedBox(height: 16),
        Text('Menyediakan pilihan armada truk terstandarisasi yang lengkap, mempermudah transaksi keuangan aman lewat gateway pembayaran tepercaya, serta memperluas konektivitas rantai logistik nusantara.', style: TextStyle(color: Color(0xFF475569), height: 1.6)),
      ],
    );
  }
}
