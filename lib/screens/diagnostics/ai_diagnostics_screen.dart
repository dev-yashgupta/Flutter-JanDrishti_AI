import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../appointments/book_appointment_screen.dart';

class AiDiagnosticsScreen extends StatefulWidget {
  const AiDiagnosticsScreen({super.key});

  @override
  State<AiDiagnosticsScreen> createState() => _AiDiagnosticsScreenState();
}

class _AiDiagnosticsScreenState extends State<AiDiagnosticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'AI Disease Diagnostics',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Pneumonia', icon: Icon(Icons.air, size: 20)),
            Tab(text: 'Heart Health', icon: Icon(Icons.favorite, size: 20)),
            Tab(text: 'Cancer Risk', icon: Icon(Icons.biotech, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _PneumoniaScanTab(),
          _HeartHealthTab(),
          _CancerRiskTab(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. PNEUMONIA SCAN TAB
// ─────────────────────────────────────────────────────────────────────────────
class _PneumoniaScanTab extends StatefulWidget {
  const _PneumoniaScanTab();

  @override
  State<_PneumoniaScanTab> createState() => _PneumoniaScanTabState();
}

class _PneumoniaScanTabState extends State<_PneumoniaScanTab> {
  bool _fever = false;
  bool _cough = false;
  bool _shortnessOfBreath = false;
  bool _chestPain = false;
  bool _fatigue = false;
  int _daysSymptomatic = 3;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _result;

  void _analyzePneumonia() async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    int score = 0;
    if (_fever) score += 25;
    if (_cough) score += 25;
    if (_shortnessOfBreath) score += 30;
    if (_chestPain) score += 15;
    if (_fatigue) score += 5;
    if (_daysSymptomatic > 5) score += 15;

    score = score.clamp(5, 96);
    final isHigh = score >= 60;
    final isModerate = score >= 35 && score < 60;

    setState(() {
      _isAnalyzing = false;
      _result = {
        'riskScore': score,
        'riskLevel': isHigh ? 'High Risk' : (isModerate ? 'Moderate Risk' : 'Low Risk'),
        'color': isHigh ? AppColors.error : (isModerate ? AppColors.warning : AppColors.success),
        'summary': isHigh
            ? 'Symptoms indicate potential lower respiratory infection or pneumonia. Urgent clinical evaluation and chest imaging are recommended.'
            : (isModerate
                ? 'Mild to moderate respiratory symptoms detected. Monitor oxygen levels and consult a physician if fever or cough persists.'
                : 'Low likelihood of acute pneumonia based on presented indicators. Stay hydrated and rest.'),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBanner(
            title: 'Pneumonia & Respiratory Analysis',
            description:
                'AI-assisted screening based on clinical respiratory markers and diagnostic indicators.',
            icon: Icons.air,
          ),
          const SizedBox(height: 20),
          const Text(
            'Select Current Symptoms:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          _buildSwitch('High Fever (>100.4°F / 38°C)', _fever, (v) => setState(() => _fever = v)),
          _buildSwitch('Persistent Cough (with or without phlegm)', _cough, (v) => setState(() => _cough = v)),
          _buildSwitch('Shortness of Breath / Rapid Breathing', _shortnessOfBreath, (v) => setState(() => _shortnessOfBreath = v)),
          _buildSwitch('Sharp Chest Pain while Breathing or Coughing', _chestPain, (v) => setState(() => _chestPain = v)),
          _buildSwitch('Extreme Fatigue & Muscle Aches', _fatigue, (v) => setState(() => _fatigue = v)),
          const SizedBox(height: 16),
          Text(
            'Duration of symptoms: $_daysSymptomatic days',
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          Slider(
            value: _daysSymptomatic.toDouble(),
            min: 1,
            max: 14,
            divisions: 13,
            activeColor: AppColors.primary,
            label: '$_daysSymptomatic days',
            onChanged: (v) => setState(() => _daysSymptomatic = v.toInt()),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _analyzePneumonia,
              icon: _isAnalyzing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.analytics_outlined, color: Colors.white),
              label: Text(
                _isAnalyzing ? 'Running AI Model...' : 'Analyze Respiratory Health',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: 24),
            _buildResultCard(_result!, context),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. HEART HEALTH TAB
// ─────────────────────────────────────────────────────────────────────────────
class _HeartHealthTab extends StatefulWidget {
  const _HeartHealthTab();

  @override
  State<_HeartHealthTab> createState() => _HeartHealthTabState();
}

class _HeartHealthTabState extends State<_HeartHealthTab> {
  final _bpSystolicController = TextEditingController(text: '120');
  final _bpDiastolicController = TextEditingController(text: '80');
  final _cholesterolController = TextEditingController(text: '190');
  final _ageController = TextEditingController(text: '35');
  bool _smoker = false;
  bool _diabetic = false;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _result;

  @override
  void dispose() {
    _bpSystolicController.dispose();
    _bpDiastolicController.dispose();
    _cholesterolController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _analyzeHeart() async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    final sys = int.tryParse(_bpSystolicController.text) ?? 120;
    final chol = int.tryParse(_cholesterolController.text) ?? 190;
    final age = int.tryParse(_ageController.text) ?? 35;

    int risk = 10;
    if (age > 45) risk += 15;
    if (age > 60) risk += 20;
    if (sys > 130) risk += 15;
    if (sys > 140) risk += 25;
    if (chol > 200) risk += 20;
    if (chol > 240) risk += 30;
    if (_smoker) risk += 25;
    if (_diabetic) risk += 20;

    risk = risk.clamp(5, 95);
    final isHigh = risk >= 55;
    final isModerate = risk >= 30 && risk < 55;

    setState(() {
      _isAnalyzing = false;
      _result = {
        'riskScore': risk,
        'riskLevel': isHigh ? 'Elevated Cardiovascular Risk' : (isModerate ? 'Moderate Risk' : 'Optimal Heart Health'),
        'color': isHigh ? AppColors.error : (isModerate ? AppColors.warning : AppColors.success),
        'summary': isHigh
            ? 'Key biomarkers indicate elevated cardiovascular risk. We strongly recommend scheduling a consultation with a cardiologist for ECG/Lipid evaluation.'
            : (isModerate
                ? 'Moderate cardiovascular indicators. Adopt a heart-healthy diet, regular aerobic exercise, and recheck lipid profile annually.'
                : 'Excellent cardiovascular parameters. Continue maintaining your current active lifestyle and balanced diet.'),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBanner(
            title: 'Cardiovascular Risk Assessment',
            description: 'Evaluate heart risk using Framingham-aligned AI predictive factors.',
            icon: Icons.favorite,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildNumberField('Age (years)', _ageController),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField('Systolic BP (mmHg)', _bpSystolicController),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildNumberField('Diastolic BP (mmHg)', _bpDiastolicController),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField('Total Cholesterol (mg/dL)', _cholesterolController),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSwitch('Tobacco / Cigarette Smoker', _smoker, (v) => setState(() => _smoker = v)),
          _buildSwitch('Diagnosed Diabetes (Type 1 or 2)', _diabetic, (v) => setState(() => _diabetic = v)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _analyzeHeart,
              icon: _isAnalyzing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.favorite_border, color: Colors.white),
              label: Text(
                _isAnalyzing ? 'Evaluating Heart Health...' : 'Calculate Cardiovascular Risk',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: 24),
            _buildResultCard(_result!, context),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. CANCER RISK TAB
// ─────────────────────────────────────────────────────────────────────────────
class _CancerRiskTab extends StatefulWidget {
  const _CancerRiskTab();

  @override
  State<_CancerRiskTab> createState() => _CancerRiskTabState();
}

class _CancerRiskTabState extends State<_CancerRiskTab> {
  bool _familyHistory = false;
  bool _palpableLump = false;
  bool _skinDimpling = false;
  bool _unexplainedWeightLoss = false;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _result;

  void _analyzeCancerRisk() async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    int risk = 8;
    if (_familyHistory) risk += 30;
    if (_palpableLump) risk += 35;
    if (_skinDimpling) risk += 25;
    if (_unexplainedWeightLoss) risk += 20;

    risk = risk.clamp(5, 95);
    final isHigh = risk >= 50;
    final isModerate = risk >= 25 && risk < 50;

    setState(() {
      _isAnalyzing = false;
      _result = {
        'riskScore': risk,
        'riskLevel': isHigh ? 'Attention Required' : (isModerate ? 'Moderate Vigilance' : 'Standard Baseline'),
        'color': isHigh ? AppColors.error : (isModerate ? AppColors.warning : AppColors.success),
        'summary': isHigh
            ? 'Significant indicators identified. We recommend prompt clinical breast examination or mammogram screening by an oncologist.'
            : (isModerate
                ? 'Some risk factors present. Schedule a routine preventive health checkup and perform regular self-examinations.'
                : 'Baseline low probability. Continue routine annual physical checkups and age-appropriate screenings.'),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBanner(
            title: 'Breast Cancer Risk Screening',
            description: 'Early identification model assessing genetic risk and somatic clinical symptoms.',
            icon: Icons.biotech,
          ),
          const SizedBox(height: 20),
          _buildSwitch('Family History of Breast/Ovarian Cancer (First Degree)', _familyHistory, (v) => setState(() => _familyHistory = v)),
          _buildSwitch('Palpable or Firm Lump Detected', _palpableLump, (v) => setState(() => _palpableLump = v)),
          _buildSwitch('Skin Changes, Dimpling, or Texture Irregularity', _skinDimpling, (v) => setState(() => _skinDimpling = v)),
          _buildSwitch('Unexplained Significant Weight Loss (>10 lbs)', _unexplainedWeightLoss, (v) => setState(() => _unexplainedWeightLoss = v)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _analyzeCancerRisk,
              icon: _isAnalyzing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.shield_outlined, color: Colors.white),
              label: Text(
                _isAnalyzing ? 'Evaluating Markers...' : 'Run Risk Evaluation',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: 24),
            _buildResultCard(_result!, context),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE HELPER WIDGETS
// ─────────────────────────────────────────────────────────────────────────────
Widget _buildInfoBanner({required String title, required String description, required IconData icon}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: AppColors.primaryGradient,
      borderRadius: BorderRadius.circular(16),
      boxShadow: AppColors.cardShadow,
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      value: value,
      activeThumbColor: AppColors.primary,
      onChanged: onChanged,
    ),
  );
}

Widget _buildNumberField(String label, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        ),
      ),
    ],
  );
}

Widget _buildResultCard(Map<String, dynamic> result, BuildContext context) {
  final color = result['color'] as Color;
  final score = result['riskScore'] as int;

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      boxShadow: AppColors.cardShadow,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AI Assessment Result', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  result['riskLevel'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$score% Probability',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: score / 100.0,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          result['summary'],
          style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookAppointmentScreen()),
              );
            },
            icon: const Icon(Icons.calendar_today, size: 16, color: Colors.white),
            label: const Text('Consult Doctor Regarding This', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ),
      ],
    ),
  );
}

