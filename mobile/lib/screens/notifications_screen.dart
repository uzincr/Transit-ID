import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/notification_cubit.dart';
import '../core/theme.dart';
import '../widgets/common_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundGlows(),
          SafeArea(
            child: Column(
              children: [
                // Header
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
                        child: const Icon(Icons.notifications_outlined, color: AppTheme.primaryCyan, size: 24),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Bildirishnomalar',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => context.read<NotificationCubit>().fetchNotifications(),
                    color: AppTheme.primaryCyan,
                    backgroundColor: AppTheme.cardDark,
                    child: BlocBuilder<NotificationCubit, NotificationState>(
                      builder: (context, state) {
                        if (state is NotificationLoading) {
                          return const Center(child: CircularProgressIndicator(color: AppTheme.primaryCyan));
                        }
                        if (state is NotificationLoaded) {
                          final notifications = state.notifications;
                          if (notifications.isEmpty) {
                            return const Center(
                              child: Text(
                                'Sizda bildirishnomalar yo\'q.',
                                style: TextStyle(color: Colors.white60, fontSize: 14),
                              ),
                            );
                          }

                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notif = notifications[index];
                              final id = notif['id'].toString();
                              final title = notif['title'] ?? 'Eslatma';
                              final message = notif['message'] ?? '';
                              final read = notif['read'] ?? false;
                              final createdAt = notif['createdAt'] ?? '';

                              String timeStr = '';
                              if (createdAt.isNotEmpty) {
                                try {
                                  final dt = DateTime.parse(createdAt);
                                  timeStr = "${dt.day}-${dt.month} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
                                } catch (e) {
                                  timeStr = createdAt.toString().split('T').first;
                                }
                              }

                              // Determine icon & color based on title or message
                              IconData icon = Icons.info_outline_rounded;
                              Color color = AppTheme.primaryCyan;

                              final lTitle = title.toLowerCase();
                              if (lTitle.contains('yangilandi') || lTitle.contains('tasdiqlandi')) {
                                icon = Icons.check_circle_outline_rounded;
                                color = AppTheme.success;
                              } else if (lTitle.contains('tugamoqda') || lTitle.contains('eslatma')) {
                                icon = Icons.warning_amber_rounded;
                                color = AppTheme.warning;
                              } else if (lTitle.contains('tugadi')) {
                                icon = Icons.cancel_outlined;
                                color = AppTheme.danger;
                              }

                              return GestureDetector(
                                onTap: () {
                                  if (!read) {
                                    context.read<NotificationCubit>().markAsRead(id);
                                  }
                                },
                                child: _notifItem(
                                  icon,
                                  color,
                                  title,
                                  message,
                                  timeStr,
                                  !read,
                                ),
                              );
                            },
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

  static Widget _notifItem(IconData icon, Color color, String title, String desc, String time, bool isNew) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNew ? color.withAlpha(12) : AppTheme.cardDark.withAlpha(140),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNew ? color.withAlpha(50) : Colors.white.withAlpha(10),
          width: isNew ? 1.4 : 1.0,
        ),
        boxShadow: isNew
            ? [
                BoxShadow(
                  color: color.withAlpha(10),
                  blurRadius: 10,
                )
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isNew ? Colors.white : Colors.white.withAlpha(180),
                        ),
                      ),
                    ),
                    if (isNew)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          boxShadow: [
                            BoxShadow(color: color, blurRadius: 4),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withAlpha(120),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withAlpha(80),
                    fontWeight: FontWeight.w600,
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
