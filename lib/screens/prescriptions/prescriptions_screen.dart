import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../medicines/medicine_finder_screen.dart';

class PrescriptionItem {
  final String medicine;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;

  PrescriptionItem({
    required this.medicine,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });
}

class DigitalPrescription {
  final String id;
  final String doctorName;
  final String specialty;
  final String date;
  final String diagnosis;
  final List<PrescriptionItem> items;
  final String notes;

  DigitalPrescription({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.diagnosis,
    required this.items,
    required this.notes,
  });
}

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  static final List<DigitalPrescription> _prescriptions = [
    DigitalPrescription(
      id: 'RX-2026-891',
      doctorName: 'Dr. Priya Sharma',
      specialty: 'General Medicine',
      date: '2026-10-28',
      diagnosis: 'Acute Upper Respiratory Tract Infection & Mild Bronchitis',
      items: [
        PrescriptionItem(
          medicine: 'Amoxicillin + Clavulanic Acid (Augmentin)',
          dosage: '625 mg',
          frequency: '1 tablet twice daily (BID)',
          duration: '5 Days',
          instructions: 'Take immediately after food.',
        ),
        PrescriptionItem(
          medicine: 'Paracetamol (Calpol)',
          dosage: '650 mg',
          frequency: 'As needed for fever > 100°F (SOS)',
          duration: '3 Days',
          instructions: 'Maintain minimum 6-hour gap between doses.',
        ),
        PrescriptionItem(
          medicine: 'Cetirizine Hydrochloride',
          dosage: '10 mg',
          frequency: '1 tablet once daily at bedtime (ODHS)',
          duration: '5 Days',
          instructions: 'May cause drowsiness. Avoid driving.',
        ),
      ],
      notes: 'Steam inhalation twice daily. Drink warm fluids. Return for follow-up if symptoms persist beyond 5 days.',
    ),
    DigitalPrescription(
      id: 'RX-2026-642',
      doctorName: 'Dr. Rahul Mehta',
      specialty: 'Cardiology',
      date: '2026-09-14',
      diagnosis: 'Primary Essential Hypertension (Stage 1)',
      items: [
        PrescriptionItem(
          medicine: 'Amlodipine Besylate (Norvasc)',
          dosage: '5 mg',
          frequency: '1 tablet once daily in morning (OD)',
          duration: '30 Days',
          instructions: 'Take consistently at the same time each morning.',
        ),
        PrescriptionItem(
          medicine: 'Atorvastatin (Lipitor)',
          dosage: '10 mg',
          frequency: '1 tablet once daily at night (HS)',
          duration: '30 Days',
          instructions: 'Take after dinner.',
        ),
      ],
      notes: 'Maintain low-sodium diet (< 2g/day). Log BP readings daily in the SehatVanni Vitals tracker.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Digital Prescriptions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _prescriptions.length,
        itemBuilder: (context, index) {
          final rx = _prescriptions[index];
          return _buildPrescriptionCard(rx, context);
        },
      ),
    );
  }

  Widget _buildPrescriptionCard(DigitalPrescription rx, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.cardShadow,
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.receipt_long, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rx.doctorName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                      ),
                      Text(
                        '${rx.specialty} • ${rx.date}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    rx.id,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Diagnosis: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                    Expanded(
                      child: Text(
                        rx.diagnosis,
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                const Text(
                  'Prescribed Medications:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                ...rx.items.map((item) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.medicine,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                                ),
                              ),
                              Text(
                                item.dosage,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.frequency} for ${item.duration}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          if (item.instructions.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Note: ${item.instructions}',
                              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                            ),
                          ],
                        ],
                      ),
                    )),
                if (rx.notes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Physician Instructions: ${rx.notes}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MedicineFinderScreen()),
                          );
                        },
                        icon: const Icon(Icons.savings_outlined, size: 16),
                        label: const Text('Find Generic Substitutes', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Prescription ${rx.id} downloaded as PDF.'),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download, size: 16, color: Colors.white),
                      label: const Text('PDF', style: TextStyle(color: Colors.white, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

