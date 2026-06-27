import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/profile_cubit.dart';
import '../core/theme.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundGlows(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  String name = 'HAYDOVCHI';
                  String phone = '+998XXXXXXXXX';
                  String carInfo = 'Hozircha yo\'q';
                  String licenseClass = 'B';
                  String registeredDate = 'Noaniq';

                  if (state is ProfileLoaded) {
                    final data = state.data;
                    name = data['fullName'] ?? 'Haydovchi';
                    phone = data['phone'] ?? '+998XXXXXXXXX';
                    final carBrand = data['carBrand'] ?? '';
                    final carNumber = data['carNumber'] ?? '';
                    carInfo = (carBrand.isNotEmpty || carNumber.isNotEmpty)
                        ? '$carBrand · $carNumber'
                        : 'Kiritilmagan';
                    licenseClass = data['licenseClass'] ?? 'B';

                    final createdAt = data['createdAt'];
                    if (createdAt != null) {
                      try {
                        final dt = DateTime.parse(createdAt);
                        registeredDate = "${dt.day}-${dt.month}-${dt.year}";
                      } catch (e) {
                        registeredDate = createdAt.toString().split('T').first;
                      }
                    }
                  }

                  return Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryCyan.withAlpha(25),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.primaryCyan.withAlpha(40)),
                            ),
                            child: const Icon(Icons.person_outline, color: AppTheme.primaryCyan, size: 24),
                          ),
                          const SizedBox(width: 14),
                          const Text(
                            'Profil',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Avatar & Name Card
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryCyan.withAlpha(40),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 52,
                          backgroundColor: AppTheme.cardDark,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        phone,
                        style: const TextStyle(color: AppTheme.primaryCyan, fontSize: 14, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 32),

                      if (state is ProfileLoading) ...[
                        const Center(child: CircularProgressIndicator(color: AppTheme.primaryCyan)),
                      ] else ...[
                        // Info card
                        GlassCard(
                          margin: EdgeInsets.zero,
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            children: [
                              _profileRow(Icons.badge_outlined, "Litsenziya toifasi", "Class $licenseClass", AppTheme.primaryCyan),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Divider(color: Colors.white10),
                              ),
                              _profileRow(Icons.directions_car_rounded, "Avtomobil", carInfo, AppTheme.secondaryPurple),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Divider(color: Colors.white10),
                              ),
                              _profileRow(Icons.business_center_rounded, "Hamkor kompaniya", "TransitID Partner", AppTheme.success),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Divider(color: Colors.white10),
                              ),
                              _profileRow(Icons.calendar_today_rounded, "A’zolik sanasi", registeredDate, AppTheme.warning),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 28),

                      // Settings List Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Tizim sozlamalari",
                            style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Settings tiles
                      _settingsTile(Icons.lock_outline_rounded, "Xavfsizlik", () {}, AppTheme.primaryCyan),
                      _settingsTile(Icons.language_rounded, "Til sozlamalari", () {}, AppTheme.secondaryPurple),
                      _settingsTile(Icons.notifications_outlined, "Bildirishnomalar", () {}, AppTheme.warning),
                      _settingsTile(Icons.help_outline_rounded, "Yordam markazi", () {}, AppTheme.success),

                      const SizedBox(height: 32),

                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                          icon: const Icon(Icons.logout_rounded, color: AppTheme.danger, size: 18),
                          label: const Text(
                            'Tizimdan chiqish',
                            style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.danger.withAlpha(80), width: 1.2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            backgroundColor: AppTheme.danger.withAlpha(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 36),
                      Text(
                        'TransitID Portal v1.2.0',
                        style: TextStyle(color: Colors.white.withAlpha(60), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileRow(IconData icon, String label, String value, Color accentColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: accentColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(120), fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingsTile(IconData icon, String label, VoidCallback onTap, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withAlpha(8)),
        ),
        tileColor: AppTheme.cardDark.withAlpha(140),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: accentColor, size: 18),
        ),
        title: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: Colors.white.withAlpha(60)),
      ),
    );
  }
}
