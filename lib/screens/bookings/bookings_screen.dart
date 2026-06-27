import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/Booking.dart';
import '../../services/booking_service.dart';
import '../trucks/trucks_screen.dart';
import 'payment_webview_screen.dart';

class BookingsScreen extends StatefulWidget {
  final VoidCallback? onNavigateToTrucks;
  const BookingsScreen({Key? key, this.onNavigateToTrucks}) : super(key: key);

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  void _fetchBookings() async {
    try {
      final res = await BookingService.getUserBookings();
      if (mounted) {
        setState(() {
          if (res['success'] && res['data'] != null) {
            _bookings = (res['data'] as List).map((i) => Booking.fromJson(i)).toList();
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _payBooking(Booking booking) async {
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
    final res = await BookingService.getSnapToken(booking.id!);
    if(mounted) Navigator.pop(context); // close dialog

    if (res['success']) {
      final snapToken = res['data']['snap_token'];
      final url = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken';
      
      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: PaymentWebViewScreen(
              url: url,
              onPaymentFinished: () {
                _fetchBookings(); // Refresh data saat ditutup/selesai
              },
            ),
          ),
        );
      }
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Gagal mendapatkan token pembayaran'), backgroundColor: Colors.red));
    }
  }

  void _cancelBooking(Booking booking) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Pesanan'),
        content: const Text('Apakah Anda yakin ingin membatalkan pesanan ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('TIDAK')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('YA, BATALKAN', style: TextStyle(color: Colors.red))),
        ],
      )
    );

    if (confirm != true) return;

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
    final res = await BookingService.cancelBooking(booking.id!);
    if (mounted) Navigator.pop(context);

    if (res['success']) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan berhasil dibatalkan'), backgroundColor: Colors.green));
      _fetchBookings();
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Gagal membatalkan pesanan'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 500;
                    if (isWide) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Riwayat Booking', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                              SizedBox(height: 4),
                              Text('Kelola dan pantau seluruh transaksi penyewaan armada truk Anda.', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: widget.onNavigateToTrucks,
                            icon: const Icon(Icons.add, color: Colors.white, size: 16),
                            label: const Text('Sewa Truk Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Riwayat Booking', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                          const SizedBox(height: 4),
                          const Text('Kelola dan pantau seluruh transaksi penyewaan armada truk Anda.', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: widget.onNavigateToTrucks,
                            icon: const Icon(Icons.add, color: Colors.white, size: 16),
                            label: const Text('Sewa Truk Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 32),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_bookings.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 64),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Column(
                      children: const [
                        Text('📦', style: TextStyle(fontSize: 48)),
                        SizedBox(height: 16),
                        Text('Anda belum memiliki riwayat pemesanan truk.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        SizedBox(height: 8),
                        Text('Armada kami siap melayani kebutuhan logistik Anda kapan saja.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                      ],
                    ),
                  )
                else
                  ..._bookings.map((b) => _buildBookingCard(b)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final canPay = booking.status == 'pending_payment';
    final canCancel = booking.status == 'pending_payment' || booking.status == 'waiting_confirmation';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  booking.bookingNumber, 
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: TextStyle(fontSize: 10, color: Colors.orange.shade700, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),
          Text('Tujuan: ${booking.destinationAddress}', style: const TextStyle(color: Color(0xFF475569))),
          const SizedBox(height: 8),
          Text('Tanggal: ${booking.pickupDate.toString().split(' ')[0]}', style: const TextStyle(color: Color(0xFF475569))),
          const SizedBox(height: 8),
          Text('Total: Rp ${booking.estimatedPrice}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
          if (canPay || canCancel) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F5F9)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (canCancel)
                  TextButton(
                    onPressed: () => _cancelBooking(booking),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Batalkan', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                if (canCancel && canPay) const SizedBox(width: 8),
                if (canPay)
                  ElevatedButton(
                    onPressed: () => _payBooking(booking),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Bayar Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
              ],
            )
          ]
        ],
      ),
    );
  }
}
