import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/api_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/appointment_model.dart';
import '../../core/models/user_model.dart';
import '../../widgets/home/health_card_widget.dart';
import '../../widgets/home/quick_action_widget.dart';
import '../../widgets/appointment/appointment_card_widget.dart';
import '../appointments/appointments_screen.dart';
import '../appointments/book_appointment_screen.dart';
import '../doctors/doctors_screen.dart';
import '../ai_assistant/ai_assistant_screen.dart';
import '../medical_records/medical_records_screen.dart';
import '../diagnostics/ai_diagnostics_screen.dart';
import '../medicines/medicine_finder_screen.dart';
import '../prescriptions/prescriptions_screen.dart';
import '../vitals/vitals_tracker_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _apiService = ApiService();
  final _authService = AuthService();

  UserModel? _user;
  List<AppointmentModel> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      _user = _authService.getCurrentUserModel();

      // Try to get profile from API
      final profile = await _apiService.getProfile();
      if (profile != null && mounted) {
        _user = profile.copyWith(
          id: firebaseUser?.uid ?? profile.id,
          email: firebaseUser?.email ?? profile.email,
        );
      }

      final appointments = await _apiService.getAppointments();
      if (mounted) {
        setState(() {
          _appointments = appointments;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.goodMorning;
    if (hour < 17) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }

  List<AppointmentModel> get _upcomingAppointments =>
      _appointments.where((a) => a.isUpcoming).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            // Header
            SliverAppBar(
              expandedHeight: 160,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_getGreeting()}, 👋',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _user?.name ?? 'User',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.health_and_safety,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  '${_upcomingAppointments.length} upcoming appointment${_upcomingAppointments.length != 1 ? "s" : ""}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              title: const Text(
                AppStrings.appName,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppColors.primary,
            ),

            if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Health Stats
                      const Text(
                        AppStrings.healthSummary,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          HealthCardWidget(
                            title: 'Upcoming',
                            value: _upcomingAppointments.length.toString(),
                            subtitle: 'Appointments',
                            icon: Icons.calendar_today,
                            color: AppColors.primary,
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (_) => const AppointmentsScreen())),
                          ),
                          HealthCardWidget(
                            title: 'Total',
                            value: _appointments.length.toString(),
                            subtitle: 'Visits so far',
                            icon: Icons.medical_services_outlined,
                            color: AppColors.secondary,
                          ),
                          HealthCardWidget(
                            title: 'Completed',
                            value: _appointments
                                .where((a) => a.status == 'completed')
                                .length
                                .toString(),
                            subtitle: 'Appointments',
                            icon: Icons.check_circle_outline,
                            color: AppColors.success,
                          ),
                          HealthCardWidget(
                            title: 'Pending',
                            value: _appointments
                                .where((a) => a.status == 'pending')
                                .length
                                .toString(),
                            subtitle: 'Awaiting confirmation',
                            icon: Icons.pending_outlined,
                            color: AppColors.warning,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Quick Actions
                      const Text(
                        AppStrings.quickActions,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          QuickActionWidget(
                            label: 'Book\nAppointment',
                            icon: Icons.add_circle_outline,
                            color: AppColors.primary,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const BookAppointmentScreen())),
                          ),
                          QuickActionWidget(
                            label: 'Find\nDoctor',
                            icon: Icons.search,
                            color: AppColors.secondary,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const DoctorsScreen())),
                          ),
                          QuickActionWidget(
                            label: 'AI\nChat',
                            icon: Icons.smart_toy_outlined,
                            color: const Color(0xFF7C3AED),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AiAssistantScreen())),
                          ),
                          QuickActionWidget(
                            label: 'My\nRecords',
                            icon: Icons.folder_open_outlined,
                            color: AppColors.success,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MedicalRecordsScreen())),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Citizen Health & AI Hub
                      const Text(
                        'Citizen Health & AI Hub',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildHubCard(
                              title: 'AI Disease\nDiagnostics',
                              subtitle: 'Pneumonia, Heart & Cancer',
                              icon: Icons.biotech,
                              color: const Color(0xFF7C3AED),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AiDiagnosticsScreen(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildHubCard(
                              title: 'Generic\nSubstitutes',
                              subtitle: 'Save up to 85% on RX',
                              icon: Icons.savings_outlined,
                              color: AppColors.primary,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MedicineFinderScreen(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildHubCard(
                              title: 'Digital\nPrescriptions',
                              subtitle: 'Dosages & Instructions',
                              icon: Icons.receipt_long,
                              color: AppColors.secondary,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PrescriptionsScreen(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildHubCard(
                              title: 'Vitals &\nEmergency',
                              subtitle: 'Log BP, Sugar & SOS',
                              icon: Icons.favorite,
                              color: AppColors.error,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const VitalsTrackerScreen(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Upcoming Appointments
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            AppStrings.upcomingAppointments,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AppointmentsScreen())),
                            child: const Text(
                              AppStrings.viewAll,
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_upcomingAppointments.isEmpty)
                        _buildEmptyState(
                          icon: Icons.calendar_today_outlined,
                          message: 'No upcoming appointments',
                          sub: 'Book an appointment to get started',
                          onAction: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const BookAppointmentScreen())),
                          actionLabel: 'Book Now',
                        )
                      else
                        ..._upcomingAppointments
                            .take(3)
                            .map((a) => AppointmentCard(appointment: a)),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String sub,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(icon, size: 48, color: AppColors.textLight),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: const TextStyle(fontSize: 13, color: AppColors.textLight),
            ),
            if (onAction != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(actionLabel ?? 'Action',
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHubCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

