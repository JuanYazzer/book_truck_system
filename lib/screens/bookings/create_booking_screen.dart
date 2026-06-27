import 'package:flutter/material.dart';
import '../../models/Truck.dart';
import '../../services/booking_service.dart';
import '../main_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateBookingScreen extends StatefulWidget {
  final Truck truck;

  const CreateBookingScreen({Key? key, required this.truck}) : super(key: key);

  @override
  _CreateBookingScreenState createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _weightController = TextEditingController();
  final _volumeController = TextEditingController();
  final _cargoTypeController = TextEditingController();
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  final _distanceController = TextEditingController();
  DateTime? _pickupDate;
  DateTime? _deliveryDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('user_name') ?? '';
    setState(() {
      _nameController.text = userName;
    });
  }

  void _submit() async {
    if (_pickupDate == null || _deliveryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih tanggal pickup dan pengiriman')));
      return;
    }

    setState(() => _isLoading = true);
    final res = await BookingService.createBooking({
      'truck_id': widget.truck.id,
      'customer_name': _nameController.text,
      'customer_phone': _phoneController.text,
      'cargo_weight': double.tryParse(_weightController.text) ?? 0,
      'cargo_volume': double.tryParse(_volumeController.text) ?? 0,
      'cargo_type': _cargoTypeController.text,
      'pickup_address': _pickupController.text,
      'destination_address': _destinationController.text,
      'distance_km': double.tryParse(_distanceController.text) ?? 0,
      'pickup_date': _pickupDate!.toIso8601String(),
      'delivery_date': _deliveryDate!.toIso8601String(),
    });
    setState(() => _isLoading = false);

    if (res['success']) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan berhasil dibuat!'), backgroundColor: Colors.green));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainLayout()), (route) => false);
      }
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Gagal membuat pesanan'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Buat Pesanan', style: TextStyle(color: Colors.black87)), backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black87)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildField(_nameController, 'Nama Pelanggan'),
            _buildField(_phoneController, 'Nomor Telepon', TextInputType.phone),
            _buildField(_cargoTypeController, 'Jenis Barang'),
            Row(
              children: [
                Expanded(child: _buildField(_weightController, 'Berat (Ton)', TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: _buildField(_volumeController, 'Volume (m³)', TextInputType.number)),
              ],
            ),
            _buildField(_pickupController, 'Alamat Pengambilan'),
            _buildField(_destinationController, 'Alamat Tujuan'),
            _buildField(_distanceController, 'Perkiraan Jarak (km)', TextInputType.number),
            ListTile(
              title: Text(_pickupDate == null ? 'Pilih Tanggal Pengambilan' : 'Pengambilan: ${_pickupDate!.toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
                if (date != null) setState(() => _pickupDate = date);
              },
            ),
            ListTile(
              title: Text(_deliveryDate == null ? 'Pilih Tanggal Pengiriman' : 'Pengiriman: ${_deliveryDate!.toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
                if (date != null) setState(() => _deliveryDate = date);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('BUAT PESANAN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, [TextInputType type = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
