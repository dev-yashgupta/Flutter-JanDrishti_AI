import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/api_service.dart';
import '../../core/models/doctor_model.dart';
import '../../widgets/common/loading_widget.dart';

class BookAppointmentScreen extends StatefulWidget {
  final DoctorModel? preSelectedDoctor;
  const BookAppointmentScreen({super.key, this.preSelectedDoctor});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _apiService = ApiService();
  final _notesController = TextEditingController();

  List<DoctorModel> _doctors = [];
  List<DoctorModel> _filteredDoctors = [];
  DoctorModel? _selectedDoctor;
  String? _selectedSpecialty;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  bool _isLoading = true;
  bool _isBooking = false;

  final List<String> _specialties = [
    'All',
    'General Medicine',
    'Cardiology',
    'Dermatology',
    'Orthopedics',
    'Pediatrics',
    'Neurology',
    'Gynecology',
    'Ophthalmology',
    'ENT',
    'Psychiatry',
  ];

  final List<String> _defaultSlots = [
    '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM', '02:00 PM', '02:30 PM',
    '03:00 PM', '03:30 PM', '04:00 PM', '04:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    _loadDoctors();
    if (widget.preSelectedDoctor != null) {
      _selectedDoctor = widget.preSelectedDoctor;
      _selectedSpecialty = widget.preSelectedDoctor!.specialty;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    setState(() => _isLoading = true);
    try {
      final data = await _apiService.getDoctors();
      if (mounted) {
        setState(() {
          _doctors = data;
          _filteredDoctors = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filterBySpecialty(String? specialty) {
    setState(() {
      _selectedSpecialty = specialty;
      _selectedDoctor = null;
      if (specialty == null || specialty == 'All') {
        _filteredDoctors = _doctors;
      } else {
        _filteredDoctors = _doctors
            .where((d) =>
                d.specialty.toLowerCase() == specialty.toLowerCase())
            .toList();
      }
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 90)),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedTimeSlot = null;
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (_selectedDoctor == null) {
      _showSnack('Please select a doctor', isError: true);
      return;
    }
    if (_selectedDate == null) {
      _showSnack('Please select a date', isError: true);
      return;
    }
    if (_selectedTimeSlot == null) {
      _showSnack('Please select a time slot', isError: true);
      return;
    }

    setState(() => _isBooking = true);
    try {
      final success = await _apiService.bookAppointment(
        doctorId: _selectedDoctor!.id,
        doctorName: _selectedDoctor!.name,
        specialty: _selectedDoctor!.specialty,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        time: _selectedTimeSlot!,
        notes: _notesController.text.trim(),
      );
      if (!mounted) return;
      if (success) {
        _showSnack(AppStrings.appointmentBooked);
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) Navigator.pop(context, true);
      } else {
        _showSnack('Failed to book appointment', isError: true);
      }
    } catch (_) {
      if (mounted) _showSnack('Error booking appointment', isError: true);
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  List<String> get _availableSlots {
    if (_selectedDoctor != null && _selectedDoctor!.availableSlots.isNotEmpty) {
      return _selectedDoctor!.availableSlots;
    }
    return _defaultSlots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Appointment',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Loading doctors...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Select Specialty'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _specialties.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (ctx, i) {
                        final sp = _specialties[i];
                        final selected = _selectedSpecialty == sp ||
                            (_selectedSpecialty == null && sp == 'All');
                        return ChoiceChip(
                          label: Text(sp),
                          selected: selected,
                          onSelected: (_) => _filterBySpecialty(
                              sp == 'All' ? null : sp),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : AppColors.textPrimary,
                            fontSize: 12,
                          ),
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: selected
                                ? AppColors.primary
                                : const Color(0xFFE5E7EB),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  _sectionTitle('Select Doctor'),
                  const SizedBox(height: 8),

                  if (_filteredDoctors.isEmpty)
                    _buildEmptyDoctors()
                  else
                    ..._filteredDoctors.map((doc) => _buildDoctorTile(doc)),

                  const SizedBox(height: 20),
                  _sectionTitle('Select Date'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedDate != null
                              ? AppColors.primary
                              : const Color(0xFFE5E7EB),
                        ),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDate != null
                                ? DateFormat('EEEE, MMMM d, yyyy')
                                    .format(_selectedDate!)
                                : 'Tap to select date',
                            style: TextStyle(
                              fontSize: 14,
                              color: _selectedDate != null
                                  ? AppColors.textPrimary
                                  : AppColors.textLight,
                              fontWeight: _selectedDate != null
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_selectedDate != null) ...[
                    const SizedBox(height: 20),
                    _sectionTitle('Select Time Slot'),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _availableSlots.length,
                      itemBuilder: (ctx, i) {
                        final slot = _availableSlots[i];
                        final selected = _selectedTimeSlot == slot;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedTimeSlot = slot),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              slot,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: selected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 20),
                  _sectionTitle('Reason / Notes (optional)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe your symptoms or reason for visit...',
                      hintStyle: const TextStyle(
                          color: AppColors.textLight, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Booking Summary
                  if (_selectedDoctor != null &&
                      _selectedDate != null &&
                      _selectedTimeSlot != null)
                    _buildBookingSummary(),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: AppColors.primaryShadow,
                      ),
                      child: ElevatedButton(
                        onPressed: _isBooking ? null : _bookAppointment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isBooking
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                AppStrings.confirmBooking,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildDoctorTile(DoctorModel doc) {
    final selected = _selectedDoctor?.id == doc.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedDoctor = doc),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selected ? AppColors.primary : const Color(0xFFE5E7EB),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    doc.specialty,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                const SizedBox(width: 3),
                Text(
                  doc.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            if (selected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyDoctors() {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: const Text(
        'No doctors available for this specialty',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Summary',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          _summaryRow(Icons.person, _selectedDoctor!.name),
          _summaryRow(Icons.medical_services_outlined, _selectedDoctor!.specialty),
          _summaryRow(Icons.calendar_today,
              DateFormat('EEE, MMM d, yyyy').format(_selectedDate!)),
          _summaryRow(Icons.access_time, _selectedTimeSlot!),
        ],
      ),
    );
  }

  Widget _summaryRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

