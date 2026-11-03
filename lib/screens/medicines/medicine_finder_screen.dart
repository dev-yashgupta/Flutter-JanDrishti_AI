import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MedicineModel {
  final String brandName;
  final String genericName;
  final String category;
  final double brandPrice;
  final double genericPrice;
  final String manufacturer;
  final String indication;
  final String dosage;
  final String precautions;

  MedicineModel({
    required this.brandName,
    required this.genericName,
    required this.category,
    required this.brandPrice,
    required this.genericPrice,
    required this.manufacturer,
    required this.indication,
    required this.dosage,
    required this.precautions,
  });

  int get savingsPercentage =>
      (((brandPrice - genericPrice) / brandPrice) * 100).round();
}

class MedicineFinderScreen extends StatefulWidget {
  const MedicineFinderScreen({super.key});

  @override
  State<MedicineFinderScreen> createState() => _MedicineFinderScreenState();
}

class _MedicineFinderScreenState extends State<MedicineFinderScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Cardiology',
    'Diabetes',
    'Antibiotics',
    'Pain Relief',
    'Gastric / Acidity',
    'Respiratory',
  ];

  final List<MedicineModel> _allMedicines = [
    MedicineModel(
      brandName: 'Lipitor (10mg)',
      genericName: 'Atorvastatin Calcium',
      category: 'Cardiology',
      brandPrice: 380.0,
      genericPrice: 55.0,
      manufacturer: 'Pfizer vs Generic Pharma',
      indication: 'Lowers LDL cholesterol and triglycerides in blood.',
      dosage: '10mg once daily at bedtime.',
      precautions: 'Avoid grapefruit juice. Monitor liver function enzymes.',
    ),
    MedicineModel(
      brandName: 'Glucophage (500mg)',
      genericName: 'Metformin Hydrochloride',
      category: 'Diabetes',
      brandPrice: 195.0,
      genericPrice: 30.0,
      manufacturer: 'Merck vs Jan Aushadhi',
      indication: 'First-line medication for Type 2 Diabetes Mellitus control.',
      dosage: '500mg twice daily with meals.',
      precautions: 'Take with food to minimize gastrointestinal discomfort.',
    ),
    MedicineModel(
      brandName: 'Augmentin (625mg)',
      genericName: 'Amoxicillin + Clavulanic Acid',
      category: 'Antibiotics',
      brandPrice: 240.0,
      genericPrice: 65.0,
      manufacturer: 'GSK vs Generic Lab',
      indication: 'Broad spectrum antibiotic for bacterial infections.',
      dosage: '625mg every 12 hours for 5 to 7 days.',
      precautions: 'Complete entire course. Inform physician if allergic to penicillin.',
    ),
    MedicineModel(
      brandName: 'Panadol / Calpol (650mg)',
      genericName: 'Paracetamol / Acetaminophen',
      category: 'Pain Relief',
      brandPrice: 60.0,
      genericPrice: 15.0,
      manufacturer: 'GSK vs CIPLA Generic',
      indication: 'Antipyretic and analgesic for fever and mild to moderate pain.',
      dosage: '650mg as needed, max 3000mg/day.',
      precautions: 'Do not exceed recommended dose. Do not combine with alcohol.',
    ),
    MedicineModel(
      brandName: 'Nexium (40mg)',
      genericName: 'Esomeprazole Magnesium',
      category: 'Gastric / Acidity',
      brandPrice: 220.0,
      genericPrice: 42.0,
      manufacturer: 'AstraZeneca vs Torrent Generic',
      indication: 'Proton-pump inhibitor for GERD, acid reflux, and peptic ulcers.',
      dosage: '40mg once daily 30 minutes before breakfast.',
      precautions: 'Long-term usage should be monitored for B12/Magnesium levels.',
    ),
    MedicineModel(
      brandName: 'Norvasc (5mg)',
      genericName: 'Amlodipine Besylate',
      category: 'Cardiology',
      brandPrice: 160.0,
      genericPrice: 28.0,
      manufacturer: 'Pfizer vs Sun Generic',
      indication: 'Calcium channel blocker for hypertension and angina.',
      dosage: '5mg once daily in the morning.',
      precautions: 'May cause mild ankle swelling. Monitor blood pressure periodically.',
    ),
    MedicineModel(
      brandName: 'Zithromax (500mg)',
      genericName: 'Azithromycin',
      category: 'Antibiotics',
      brandPrice: 210.0,
      genericPrice: 50.0,
      manufacturer: 'Pfizer vs Lupin Generic',
      indication: 'Macrolide antibiotic for upper and lower respiratory infections.',
      dosage: '500mg once daily for 3 days.',
      precautions: 'Take 1 hour before or 2 hours after meals with full glass of water.',
    ),
    MedicineModel(
      brandName: 'Singulair (10mg)',
      genericName: 'Montelukast Sodium',
      category: 'Respiratory',
      brandPrice: 290.0,
      genericPrice: 60.0,
      manufacturer: 'Organon vs Alkem Generic',
      indication: 'Leukotriene receptor antagonist for asthma and allergic rhinitis.',
      dosage: '10mg once daily in evening.',
      precautions: 'Not for acute asthma attacks. Report changes in mood or sleep.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MedicineModel> get _filteredMedicines {
    final query = _searchController.text.trim().toLowerCase();
    return _allMedicines.where((m) {
      final matchQuery = query.isEmpty ||
          m.brandName.toLowerCase().contains(query) ||
          m.genericName.toLowerCase().contains(query) ||
          m.indication.toLowerCase().contains(query);
      final matchCat =
          _selectedCategory == 'All' || m.category == _selectedCategory;
      return matchQuery && matchCat;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Generic Medicine Substitutes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search brand name (e.g. Lipitor, Augmentin)...',
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = cat == _selectedCategory;
                      return ChoiceChip(
                        label: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.background,
                        onSelected: (val) {
                          if (val) setState(() => _selectedCategory = cat);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Savings callout banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.success.withValues(alpha: 0.1),
            child: const Row(
              children: [
                Icon(Icons.savings_outlined, color: AppColors.success, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Save up to 85% on pharmaceutical costs with verified generic bio-equivalents!',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Medicine list
          Expanded(
            child: _filteredMedicines.isEmpty
                ? const Center(
                    child: Text(
                      'No matching medicines found.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredMedicines.length,
                    itemBuilder: (context, index) {
                      final item = _filteredMedicines[index];
                      return _buildMedicineCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(MedicineModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Save ${item.savingsPercentage}%',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.brandName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.medication, size: 16, color: AppColors.secondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Generic Salt: ${item.genericName}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Brand Price',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${item.brandPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward, color: AppColors.textLight, size: 20),
                  Column(
                    children: [
                      const Text(
                        'Generic Price',
                        style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${item.genericPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Indication: ${item.indication}',
              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Dosage: ${item.dosage}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

