import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecord {
  final String title;
  final String date;
  final String type;
  final String doctor;
  final IconData icon;
  final Color color;

  _MedicalRecord({
    required this.title,
    required this.date,
    required this.type,
    required this.doctor,
    required this.icon,
    required this.color,
  });
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final bool _isLoading = false;

  final List<_MedicalRecord> _records = [
    _MedicalRecord(
      title: 'Blood Test Report',
      date: '2026-10-15',
      type: 'Lab Report',
      doctor: 'Dr. Priya Sharma',
      icon: Icons.science_outlined,
      color: AppColors.secondary,
    ),
    _MedicalRecord(
      title: 'Chest X-Ray',
      date: '2026-09-22',
      type: 'Radiology',
      doctor: 'Dr. Rahul Mehta',
      icon: Icons.medical_information_outlined,
      color: AppColors.primary,
    ),
    _MedicalRecord(
      title: 'ECG Report',
      date: '2026-09-05',
      type: 'Cardiology',
      doctor: 'Dr. Rahul Mehta',
      icon: Icons.monitor_heart_outlined,
      color: AppColors.error,
    ),
    _MedicalRecord(
      title: 'Prescription - Antibiotics',
      date: '2026-08-18',
      type: 'Prescription',
      doctor: 'Dr. Anita Patel',
      icon: Icons.medication_outlined,
      color: AppColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.medicalRecords,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration:
              const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File upload coming soon'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.upload_file, color: Colors.white),
        label:
            const Text('Upload', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _records.isEmpty
              ? _buildEmpty()
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Summary cards
                    Row(
                      children: [
                        _summaryCard(
                          '${_records.length}',
                          'Total Records',
                          Icons.folder_outlined,
                          AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        _summaryCard(
                          '${_records.where((r) => r.type == "Lab Report").length}',
                          'Lab Reports',
                          Icons.science_outlined,
                          AppColors.secondary,
                        ),
                        const SizedBox(width: 12),
                        _summaryCard(
                          '${_records.where((r) => r.type == "Prescription").length}',
                          'Prescriptions',
                          Icons.medication_outlined,
                          AppColors.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'All Records',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ..._records.map((r) => _recordCard(r)),
                  ],
                ),
    );
  }

  Widget _summaryCard(
      String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _recordCard(_MedicalRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: record.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(record.icon, color: record.color, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    record.doctor,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: record.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          record.type,
                          style: TextStyle(
                            fontSize: 10,
                            color: record.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.calendar_today,
                          size: 10, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(
                        record.date,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textLight),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert,
                  color: AppColors.textLight, size: 20),
              onPressed: () => _showRecordOptions(record),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecordOptions(_MedicalRecord record) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              record.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _bottomSheetAction(
              icon: Icons.download_outlined,
              label: 'Download',
              onTap: () {
                Navigator.pop(ctx);
                _showSnack('Downloading ${record.title}...');
              },
            ),
            _bottomSheetAction(
              icon: Icons.share_outlined,
              label: 'Share',
              onTap: () {
                Navigator.pop(ctx);
                _showSnack('Sharing ${record.title}...');
              },
            ),
            _bottomSheetAction(
              icon: Icons.delete_outlined,
              label: 'Delete',
              color: AppColors.error,
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheetAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading:
          Icon(icon, color: color ?? AppColors.textPrimary, size: 22),
      title: Text(
        label,
        style: TextStyle(
            color: color ?? AppColors.textPrimary,
            fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_open_outlined,
              size: 72, color: AppColors.textLight),
          const SizedBox(height: 16),
          const Text(
            AppStrings.noRecords,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload your medical documents to keep them safe',
            style: TextStyle(fontSize: 13, color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

