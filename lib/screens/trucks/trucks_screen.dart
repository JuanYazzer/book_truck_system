import 'package:flutter/material.dart';
import '../../models/Truck.dart';
import '../../services/truck_service.dart';
import 'truck_detail_screen.dart';

class TrucksScreen extends StatefulWidget {
  const TrucksScreen({Key? key}) : super(key: key);

  @override
  _TrucksScreenState createState() => _TrucksScreenState();
}

class _TrucksScreenState extends State<TrucksScreen> {
  List<Truck> _allTrucks = [];
  List<Truck> _trucks = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'Semua Jenis';

  @override
  void initState() {
    super.initState();
    _fetchTrucks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchTrucks() async {
    try {
      final res = await TruckService.getTrucks();
      if (mounted) {
        setState(() {
          if (res['success'] && res['data'] != null) {
            _allTrucks = (res['data'] as List).map((i) => Truck.fromJson(i)).toList();
            _trucks = List.from(_allTrucks);
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

  void _filterTrucks() {
    setState(() {
      _trucks = _allTrucks.where((truck) {
        final query = _searchController.text.toLowerCase();
        final matchesQuery = truck.name.toLowerCase().contains(query) || 
                             truck.licensePlate.toLowerCase().contains(query) || 
                             (truck.description?.toLowerCase().contains(query) ?? false);
        
        final matchesType = _selectedType == 'Semua Jenis' || truck.type.toLowerCase() == _selectedType.toLowerCase();
        
        return matchesQuery && matchesType;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          children: [
            const Text('Armada Truk Tersedia', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
            const SizedBox(height: 8),
            const Text('Temukan armada truk yang paling pas untuk kapasitas berat dan volume muatan logistik Anda.', style: TextStyle(color: Color(0xFF64748B), fontSize: 16)),
            const SizedBox(height: 48),

            // FILTER SECTION
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(flex: 2, child: _buildSearchField()),
                          const SizedBox(width: 16),
                          Expanded(flex: 2, child: _buildTypeField()),
                          const SizedBox(width: 16),
                          Expanded(flex: 1, child: _buildFilterButton()),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSearchField(),
                          const SizedBox(height: 16),
                          _buildTypeField(),
                          const SizedBox(height: 16),
                          _buildFilterButton(),
                        ],
                      );
                    }
                  }
                ),
              ),
            ),

            const SizedBox(height: 48),

            // TRUCKS GRID
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_trucks.isEmpty)
              const Center(child: Text('Tidak ada armada truk.'))
            else
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: _trucks.map((truck) => SizedBox(width: 310, child: _buildTruckCard(truck))).toList(),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildTruckCard(Truck truck) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TruckDetailScreen(truck: truck)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(color: Color(0xFFF8FAFC), borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: truck.photoPath != null
                        ? Image.network(
                            truck.photoPath!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Center(child: Text('🚚', style: TextStyle(fontSize: 64))),
                          )
                        : const Center(child: Text('🚚', style: TextStyle(fontSize: 64))),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: truck.status == 'available' ? Colors.green.shade50 : Colors.red.shade50,
                        border: Border.all(color: truck.status == 'available' ? Colors.green.shade200 : Colors.red.shade200),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        truck.status.toUpperCase(),
                        style: TextStyle(color: truck.status == 'available' ? Colors.green.shade700 : Colors.red.shade700, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(truck.type.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.lightBlue)),
                  const SizedBox(height: 4),
                  Text(truck.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 4),
                  Text(truck.licensePlate, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  const SizedBox(height: 16),
                  Text(truck.description ?? '', maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('CARI TRUK', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
        const SizedBox(height: 4),
        TextField(
          controller: _searchController,
          onSubmitted: (_) => _filterTrucks(),
          decoration: InputDecoration(
            hintText: 'Misal: Mitsubishi, Hino...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        )
      ],
    );
  }

  Widget _buildTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('JENIS TRUK', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _selectedType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: ['Semua Jenis', 'Box', 'Flatbed'].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedType = val;
              });
              _filterTrucks();
            }
          },
        )
      ],
    );
  }

  Widget _buildFilterButton() {
    return ElevatedButton(
      onPressed: _filterTrucks,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Cari & Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
