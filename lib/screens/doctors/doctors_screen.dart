import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/api_service.dart';
import '../../core/models/doctor_model.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/doctor/doctor_card_widget.dart';
import 'doctor_detail_screen.dart';
import '../appointments/book_appointment_screen.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final _apiService = ApiService();
  final _searchController = TextEditingController();
  List<DoctorModel> _allDoctors = [];
  List<DoctorModel> _filtered = [];
  String? _selectedSpecialty;
  bool _isLoading = true;

  final List<String> _specialties = [
    'All',
    'General Medicine',
    'Cardiology',
    'Dermatology',
    'Orthopedics',
    'Pediatrics',
    'Neurology',
  ];

  @override
  void initState() {
    super.initState();
    _loadDoctors();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    setState(() => _isLoading = true);
    try {
      final data = await _apiService.getDoctors();
      if (mounted) {
        setState(() {
          _allDoctors = data;
          _filtered = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _allDoctors.where((d) {
        final matchSearch = query.isEmpty ||
            d.name.toLowerCase().contains(query) ||
            d.specialty.toLowerCase().contains(query);
        final matchSpecialty = _selectedSpecialty == null ||
            _selectedSpecialty == 'All' ||
            d.specialty.toLowerCase() == _selectedSpecialty!.toLowerCase();
        return matchSearch && matchSpecialty;
      }).toList();
    });
  }

  void _selectSpecialty(String sp) {
    setState(() {
      _selectedSpecialty = sp == 'All' ? null : sp;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.doctors,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: AppStrings.searchDoctors,
                  hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          // Specialty filters
          Container(
            height: 48,
            color: Colors.white,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _specialties.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final sp = _specialties[i];
                final selected = (sp == 'All' && _selectedSpecialty == null) ||
                    sp == _selectedSpecialty;
                return ChoiceChip(
                  label: Text(sp, style: const TextStyle(fontSize: 12)),
                  selected: selected,
                  onSelected: (_) => _selectSpecialty(sp),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textPrimary,
                    fontSize: 12,
                  ),
                  backgroundColor: AppColors.background,
                  side: BorderSide(
                    color: selected
                        ? AppColors.primary
                        : const Color(0xFFE5E7EB),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                );
              },
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // Doctor list
          Expanded(
            child: _isLoading
                ? const LoadingWidget(message: 'Loading doctors...')
                : _filtered.isEmpty
                    ? _buildEmpty()
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: _loadDoctors,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filtered.length,
                          itemBuilder: (ctx, i) => DoctorCard(
                            doctor: _filtered[i],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DoctorDetailScreen(doctor: _filtered[i]),
                              ),
                            ),
                            onBook: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookAppointmentScreen(
                                    preSelectedDoctor: _filtered[i]),
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          const Text(
            AppStrings.noDoctors,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different search or specialty',
            style: TextStyle(fontSize: 13, color: AppColors.textLight),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              _searchController.clear();
              _selectSpecialty('All');
            },
            child: const Text('Clear filters',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

