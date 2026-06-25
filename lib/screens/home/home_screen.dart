import 'package:flutter/material.dart';
import '../../models/Truck.dart';
import '../../services/truck_service.dart';
import '../trucks/truck_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToTrucks;

  const HomeScreen({Key? key, this.onNavigateToTrucks}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Truck> _showcaseTrucks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchShowcaseTrucks();
  }

  void _fetchShowcaseTrucks() async {
    try {
      final res = await TruckService.getTrucks();
      if (mounted && res['success'] && res['data'] != null) {
        final allTrucks = (res['data'] as List).map((i) => Truck.fromJson(i)).toList();
        setState(() {
          // Hanya ambil 3 truk untuk showcase beranda seperti di web
          _showcaseTrucks = allTrucks.take(3).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HERO SECTION
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                children: [
                  const Text(
                    'Pengangkutan Barang Cepat,',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A), // slate-900
                      height: 1.2,
                    ),
                  ),
                  const Text(
                    'Aman, dan Tepercaya',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.lightBlue, // sky-500
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sistem Booking Truk Berbasis Web memudahkan Anda memesan truk pengangkutan barang secara daring, membayar uang muka aman via payment gateway, dan memantau status secara langsung.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF475569), // slate-600
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: widget.onNavigateToTrucks,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Mulai Sewa Truk Sekarang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SERVICES SECTION
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                children: [
                  const Text(
                    'Layanan Unggulan Kami',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Menyediakan berbagai solusi kebutuhan distribusi barang Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 32),
                  _buildServiceCard(
                    icon: '📦',
                    title: 'Booking Daring Mudah',
                    desc: 'Pilih armada truk yang sesuai dengan kubikasi volume dan berat muatan Anda secara langsung dari sistem.',
                  ),
                  const SizedBox(height: 16),
                  _buildServiceCard(
                    icon: '💳',
                    title: 'Pembayaran DP Aman',
                    desc: 'Proses pembayaran uang muka (DP) aman terintegrasi dengan Snap payment gateway Midtrans.',
                  ),
                  const SizedBox(height: 16),
                  _buildServiceCard(
                    icon: '🗺️',
                    title: 'Pelacakan Status',
                    desc: 'Pantau tahapan status pengiriman barang Anda secara real-time dari panel riwayat transaksi.',
                  ),
                ],
              ),
            ),

            // SHOWCASE SECTION
            Container(
              color: const Color(0xFFF8FAFC), // slate-50
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                children: [
                  const Text(
                    'Armada Tersedia',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Daftar beberapa truk siap jalan yang siap mengantarkan muatan Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 32),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_showcaseTrucks.isEmpty)
                    const Text('Tidak ada truk yang ditampilkan saat ini.', style: TextStyle(color: Colors.grey))
                  else
                    ..._showcaseTrucks.map((truck) => _buildTruckCard(truck)).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({required String icon, required String title, required String desc}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 8),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Color(0xFF475569))),
        ],
      ),
    );
  }

  Widget _buildTruckCard(Truck truck) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TruckDetailScreen(truck: truck)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Center(child: Text('🚚', style: TextStyle(fontSize: 64))),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    truck.type.toUpperCase(),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.lightBlue, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    truck.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  if (truck.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      truck.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFF8FAFC), thickness: 2),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tarif per KM', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                          Text('Rp ${truck.pricePerKm}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Kapasitas Berat', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                          Text('${truck.maxWeight} kg', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
