import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/api_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/user_model.dart';
import '../../screens/auth/login_screen.dart';
import '../prescriptions/prescriptions_screen.dart';
import '../vitals/vitals_tracker_screen.dart';
import '../medical_records/medical_records_screen.dart';
import '../medicines/medicine_finder_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _apiService = ApiService();
  final _authService = AuthService();
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      _user = _authService.getCurrentUserModel();

      final profile = await _apiService.getProfile();
      if (profile != null && mounted) {
        _user = profile.copyWith(
          id: firebaseUser?.uid ?? profile.id,
          email: firebaseUser?.email ?? profile.email,
        );
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child:
                const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  width: 3),
                            ),
                            child: const Icon(Icons.person,
                                size: 44, color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _user?.name ?? 'User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _user?.email ?? '',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            title: const Text('Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Info
                  _sectionHeader('Personal Information'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _infoRow(Icons.person_outline, 'Full Name',
                        _user?.name ?? 'N/A'),
                    _divider(),
                    _infoRow(Icons.email_outlined, 'Email',
                        _user?.email ?? 'N/A'),
                    _divider(),
                    _infoRow(Icons.phone_outlined, 'Phone',
                        _user?.phone ?? 'Not provided'),
                    _divider(),
                    _infoRow(Icons.cake_outlined, 'Date of Birth',
                        _user?.dateOfBirth ?? 'Not provided'),
                  ]),

                  const SizedBox(height: 20),

                  // Health Info
                  _sectionHeader('Health Information'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _infoRow(Icons.bloodtype_outlined, 'Blood Group',
                        _user?.bloodGroup ?? 'Not provided'),
                    _divider(),
                    _infoRow(Icons.location_on_outlined, 'Address',
                        _user?.address ?? 'Not provided'),
                  ]),

                  const SizedBox(height: 20),

                  // Health Services & Records
                  _sectionHeader('Health Services & Prescriptions'),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      children: [
                        _actionTile(
                          icon: Icons.receipt_long_outlined,
                          title: 'Digital Prescriptions',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PrescriptionsScreen()),
                          ),
                        ),
                        const Divider(height: 1, indent: 56),
                        _actionTile(
                          icon: Icons.favorite_border,
                          title: 'Vitals & Emergency Logs',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const VitalsTrackerScreen()),
                          ),
                        ),
                        const Divider(height: 1, indent: 56),
                        _actionTile(
                          icon: Icons.savings_outlined,
                          title: 'Generic Medicine Substitutes',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MedicineFinderScreen()),
                          ),
                        ),
                        const Divider(height: 1, indent: 56),
                        _actionTile(
                          icon: Icons.folder_shared_outlined,
                          title: 'Diagnostic Reports & Scans',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MedicalRecordsScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Account actions
                  _sectionHeader('Account'),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      children: [
                        _actionTile(
                          icon: Icons.edit_outlined,
                          title: AppStrings.editProfile,
                          onTap: () => _showEditDialog(),
                        ),
                        const Divider(height: 1, indent: 56),
                        _actionTile(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          onTap: () => _showSnack('Notifications settings coming soon'),
                        ),
                        const Divider(height: 1, indent: 56),
                        _actionTile(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () => _showSnack('Support chat coming soon'),
                        ),
                        const Divider(height: 1, indent: 56),
                        _actionTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () => _showSnack('Opening privacy policy...'),
                        ),
                        const Divider(height: 1, indent: 56),
                        _actionTile(
                          icon: Icons.logout,
                          title: AppStrings.logout,
                          iconColor: AppColors.error,
                          titleColor: AppColors.error,
                          onTap: _logout,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: Text(
                      '${AppStrings.appName} v1.0.0',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textLight),
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

  void _showEditDialog() {
    final nameController =
        TextEditingController(text: _user?.name ?? '');
    final phoneController =
        TextEditingController(text: _user?.phone ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await _apiService.updateProfile({
                'name': nameController.text,
                'phone': phoneController.text,
              });
              if (mounted) {
                if (success) {
                  setState(() {
                    _user = _user?.copyWith(
                      name: nameController.text,
                      phone: phoneController.text,
                    );
                  });
                  _showSnack(AppStrings.profileUpdated);
                } else {
                  _showSnack('Update failed', isError: true);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child:
                const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
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

  Widget _divider() =>
      const Divider(height: 1, indent: 48, color: Color(0xFFF5F5F5));

  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: titleColor ?? AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right,
          size: 20, color: AppColors.textLight),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}

