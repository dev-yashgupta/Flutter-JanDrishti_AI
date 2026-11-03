import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/doctor_model.dart';
import '../appointments/book_appointment_screen.dart';

class DoctorDetailScreen extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5), width: 3),
                      ),
                      child: const Icon(Icons.person,
                          size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      doctor.specialty,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _statCard(
                        icon: Icons.star,
                        value: doctor.rating.toStringAsFixed(1),
                        label: 'Rating',
                        color: const Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        icon: Icons.reviews_outlined,
                        value: '${doctor.reviewCount}',
                        label: 'Reviews',
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        icon: Icons.work_outline,
                        value: '${doctor.experience}yr',
                        label: 'Experience',
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (doctor.qualification != null) ...[
                    _infoSection('Qualification', doctor.qualification!,
                        Icons.school_outlined),
                    const SizedBox(height: 12),
                  ],
                  if (doctor.hospital != null) ...[
                    _infoSection(
                        'Hospital / Clinic', doctor.hospital!, Icons.local_hospital_outlined),
                    const SizedBox(height: 12),
                  ],
                  if (doctor.bio != null) ...[
                    _infoSection('About', doctor.bio!, Icons.info_outline),
                    const SizedBox(height: 12),
                  ],

                  if (doctor.availableDays.isNotEmpty) ...[
                    const Text(
                      'Available Days',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: doctor.availableDays
                          .map((d) => Chip(
                                label: Text(d,
                                    style: const TextStyle(
                                        fontSize: 12, color: AppColors.primary)),
                                backgroundColor:
                                    AppColors.primary.withValues(alpha: 0.1),
                                side: BorderSide(
                                    color: AppColors.primary.withValues(alpha: 0.3)),
                                padding: EdgeInsets.zero,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (doctor.availableSlots.isNotEmpty) ...[
                    const Text(
                      'Available Slots',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: doctor.availableSlots
                          .map((s) => Chip(
                                label: Text(s,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary)),
                                backgroundColor: AppColors.background,
                                side: const BorderSide(
                                    color: Color(0xFFE5E7EB)),
                                padding: EdgeInsets.zero,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: AppColors.primaryShadow,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookAppointmentScreen(
                                  preSelectedDoctor: doctor),
                            ),
                          );
                        },
                        icon: const Icon(Icons.calendar_today,
                            color: Colors.white, size: 18),
                        label: const Text(
                          'Book Appointment',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoSection(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

