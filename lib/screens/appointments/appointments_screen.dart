import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/api_service.dart';
import '../../core/models/appointment_model.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/appointment/appointment_card_widget.dart';
import 'book_appointment_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  final _apiService = ApiService();
  List<AppointmentModel> _appointments = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);
    try {
      final data = await _apiService.getAppointments();
      if (mounted) setState(() { _appointments = data; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _cancelAppointment(AppointmentModel appointment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(AppStrings.cancelAppointment),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppStrings.cancelConfirm),
            const SizedBox(height: 12),
            Text(
              '${appointment.doctorName}\n${appointment.date} at ${appointment.time}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child:
                const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final success = await _apiService.cancelAppointment(appointment.id);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.appointmentCancelled),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _loadAppointments();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to cancel appointment'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  List<AppointmentModel> _getFiltered(String filter) {
    switch (filter) {
      case 'upcoming':
        return _appointments.where((a) => a.isUpcoming).toList();
      case 'past':
        return _appointments.where((a) => a.isPast).toList();
      default:
        return _appointments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppStrings.appointments,
        showBack: Navigator.of(context).canPop(),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: AppStrings.upcoming),
            Tab(text: AppStrings.past),
            Tab(text: AppStrings.all),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const BookAppointmentScreen()));
          _loadAppointments();
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Book', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Loading appointments...')
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList('upcoming'),
                _buildList('past'),
                _buildList('all'),
              ],
            ),
    );
  }

  Widget _buildList(String filter) {
    final items = _getFiltered(filter);
    if (items.isEmpty) {
      return _buildEmpty(filter);
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (ctx, i) => AppointmentCard(
          appointment: items[i],
          onCancel: items[i].status != 'cancelled' &&
                  items[i].status != 'completed'
              ? () => _cancelAppointment(items[i])
              : null,
        ),
      ),
    );
  }

  Widget _buildEmpty(String filter) {
    IconData icon;
    String message;
    String sub;
    switch (filter) {
      case 'upcoming':
        icon = Icons.calendar_today_outlined;
        message = 'No upcoming appointments';
        sub = 'Book an appointment to get started';
        break;
      case 'past':
        icon = Icons.history;
        message = 'No past appointments';
        sub = 'Your appointment history will appear here';
        break;
      default:
        icon = Icons.medical_services_outlined;
        message = AppStrings.noAppointments;
        sub = AppStrings.bookFirst;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sub,
            style: const TextStyle(fontSize: 13, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}

