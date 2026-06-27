import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/license_cubit.dart';
import '../core/theme.dart';
import '../widgets/common_widgets.dart';

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundGlows(),
          SafeArea(
            child: Column(
              children: [
                // Custom Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryCyan.withAlpha(25),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.primaryCyan.withAlpha(40)),
                        ),
                        child: const Icon(Icons.badge_outlined, color: AppTheme.primaryCyan, size: 24),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Litsenziyalarim',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => context.read<LicenseCubit>().fetchLicenses(),
                    color: AppTheme.primaryCyan,
                    backgroundColor: AppTheme.cardDark,
                    child: BlocBuilder<LicenseCubit, LicenseState>(
                      builder: (context, state) {
                        if (state is LicenseLoading) {
                          return const Center(child: CircularProgressIndicator(color: AppTheme.primaryCyan));
                        }
                        if (state is LicenseError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(state.message, style: const TextStyle(color: AppTheme.danger, fontWeight: FontWeight.bold)),
                            ),
                          );
                        }
                        if (state is LicenseLoaded) {
                          final licenses = state.licenses;
                          if (licenses.isEmpty) {
                            return const Center(
                              child: Text('Litsenziyalar topilmadi.', style: TextStyle(color: Colors.white60)),
                            );
                          }

                          // Separate current license and renewal history
                          final currentList = licenses.where((lic) => lic['status'] != 'RENEWED').toList();
                          final historyList = licenses.where((lic) => lic['status'] == 'RENEWED').toList();

                          final hasCurrent = currentList.isNotEmpty;
                          final activeLicense = hasCurrent ? currentList.first : null;

                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                if (hasCurrent && activeLicense != null) ...[
                                  // Active License Card
                                  _buildActiveLicenseCard(activeLicense),
                                ] else ...[
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 40),
                                    child: Center(
                                      child: Text(
                                        'Faol litsenziya mavjud emas',
                                        style: TextStyle(color: Colors.white60, fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 28),

                                // History Timeline Section
                                if (historyList.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Yangilanishlar tarixi',
                                        style: TextStyle(
                                          color: Colors.white.withAlpha(160),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildHistoryTimeline(historyList),
                                ],
                                const SizedBox(height: 40),
                              ],
                            ),
                          );
                        }
                        return const Center(child: Text('Yuklanmoqda...'));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveLicenseCard(dynamic activeLicense) {
    final status = activeLicense['status'] ?? 'NOMA\'LUM';
    final int daysLeft = activeLicense['daysRemaining'] ?? 0;
    
    // Progress calculation assuming 365 days duration
    final double progress = (daysLeft / 365).clamp(0.0, 1.0);
    final isDanger = daysLeft < 15;
    final isWarning = daysLeft >= 15 && daysLeft < 30;
    final Color progressColor = isDanger ? AppTheme.danger : (isWarning ? AppTheme.warning : AppTheme.success);

    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'JORIY LITSENZIYA',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 11,
                      color: AppTheme.primaryCyan,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'FAOL HUJJAT TAFSILOTLARI',
                    style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 9, letterSpacing: 0.5),
                  ),
                ],
              ),
              if (status == 'ACTIVE') StatusBadge.active()
              else if (status == 'EXPIRING') StatusBadge.expiring()
              else if (status == 'EXPIRED') StatusBadge.expired()
              else StatusBadge(label: status, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 24),
          
          _infoRow('Litsenziya raqami', activeLicense['licenseNumber'] ?? ''),
          _infoRow('Haydovchi', activeLicense['driverName'] ?? ''),
          _infoRow('Berilgan sana', activeLicense['issueDate'] ?? ''),
          _infoRow('Tugash sanasi', activeLicense['expiryDate'] ?? ''),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.white10),
          ),

          // Days Remaining Progress Meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amal qilish muddati',
                style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(140), fontWeight: FontWeight.w600),
              ),
              Text(
                '$daysLeft kun qoldi',
                style: TextStyle(fontSize: 13, color: progressColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withAlpha(15),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withAlpha(110), fontSize: 13, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildHistoryTimeline(List<dynamic> history) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final isLast = index == history.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline vertical tracer
              Column(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryCyan, width: 2),
                      boxShadow: [
                        BoxShadow(color: AppTheme.primaryCyan.withAlpha(60), blurRadius: 6),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Colors.white.withAlpha(20),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Timeline content box
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark.withAlpha(150),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withAlpha(12)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.history_rounded, color: Colors.blue, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['licenseNumber'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item['issueDate']} → ${item['expiryDate']}',
                              style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(120)),
                            ),
                          ],
                        ),
                      ),
                      const StatusBadge(label: 'YANGILANDI', color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
