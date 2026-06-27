import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/payment_cubit.dart';
import '../blocs/license_cubit.dart';
import '../blocs/profile_cubit.dart';
import '../blocs/notification_cubit.dart';
import '../core/theme.dart';
import '../widgets/common_widgets.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  void _showPaymentModal(BuildContext context) {
    String selectedMethod = 'CLICK';
    double fee = 150000.00;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return GlassCard(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Litsenziyani uzaytirish",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Litsenziya muddati 1 yilga uzaytiriladi. To'lov summasi: 150,000 UZS.",
                    style: TextStyle(color: Colors.white.withAlpha(120), fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "To'lov provayderini tanlang:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedMethod = 'CLICK'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: selectedMethod == 'CLICK'
                                  ? LinearGradient(
                                      colors: [AppTheme.primaryCyan.withAlpha(40), AppTheme.primaryCyan.withAlpha(10)],
                                    )
                                  : null,
                              color: selectedMethod == 'CLICK' ? null : Colors.white.withAlpha(8),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selectedMethod == 'CLICK' ? AppTheme.primaryCyan : Colors.white.withAlpha(15),
                                width: selectedMethod == 'CLICK' ? 1.8 : 1.0,
                              ),
                              boxShadow: selectedMethod == 'CLICK'
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.primaryCyan.withAlpha(20),
                                        blurRadius: 10,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                "CLICK",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: selectedMethod == 'CLICK' ? AppTheme.primaryCyan : Colors.white60,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedMethod = 'PAYME'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: selectedMethod == 'PAYME'
                                  ? LinearGradient(
                                      colors: [AppTheme.secondaryPurple.withAlpha(40), AppTheme.secondaryPurple.withAlpha(10)],
                                    )
                                  : null,
                              color: selectedMethod == 'PAYME' ? null : Colors.white.withAlpha(8),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selectedMethod == 'PAYME' ? AppTheme.secondaryPurple : Colors.white.withAlpha(15),
                                width: selectedMethod == 'PAYME' ? 1.8 : 1.0,
                              ),
                              boxShadow: selectedMethod == 'PAYME'
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.secondaryPurple.withAlpha(20),
                                        blurRadius: 10,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                "PAYME",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: selectedMethod == 'PAYME' ? AppTheme.secondaryPurple : Colors.white60,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  GradientButton(
                    label: "To'lovni amalga oshirish",
                    icon: Icons.payment_rounded,
                    customGradient: selectedMethod == 'CLICK'
                        ? AppTheme.primaryGradient
                        : const LinearGradient(
                            colors: [AppTheme.secondaryPurple, Color(0xFF8A2BE2)],
                          ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<PaymentCubit>().initiatePaymentAndComplete(fee, selectedMethod);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          // Trigger reload of everything
          context.read<LicenseCubit>().fetchLicenses();
          context.read<ProfileCubit>().fetchProfile();
          context.read<NotificationCubit>().fetchNotifications();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: AppTheme.darkBg),
                  SizedBox(width: 12),
                  Text("To'lov muvaffaqiyatli! Litsenziya yangilandi.", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkBg)),
                ],
              ),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        } else if (state is PaymentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            const BackgroundGlows(),
            SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryCyan.withAlpha(25),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.primaryCyan.withAlpha(40)),
                          ),
                          child: const Icon(Icons.account_balance_wallet_outlined, color: AppTheme.primaryCyan, size: 24),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          "To'lovlar",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),

                  // Wallet Balance card
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'TA’RIF TO’LOVI',
                          style: TextStyle(
                            color: Colors.white.withAlpha(120),
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const GradientText(
                          text: '150,000 UZS',
                          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => _showPaymentModal(context),
                              child: _actionBtn(Icons.add_card_rounded, "Uzaytirish", AppTheme.success),
                            ),
                            _actionBtn(Icons.receipt_long_rounded, 'Kvitansiya', AppTheme.primaryCyan),
                            _actionBtn(Icons.info_outline_rounded, 'Tafsilotlar', AppTheme.warning),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Text(
                          "So'nggi tranzaksiyalar",
                          style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => context.read<PaymentCubit>().fetchPayments(),
                      color: AppTheme.primaryCyan,
                      backgroundColor: AppTheme.cardDark,
                      child: BlocBuilder<PaymentCubit, PaymentState>(
                        builder: (context, state) {
                          if (state is PaymentLoading) {
                            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryCyan));
                          }
                          if (state is PaymentLoaded) {
                            final payments = state.payments;
                            if (payments.isEmpty) {
                              return const Center(
                                child: Text('Tranzaksiyalar mavjud emas.', style: TextStyle(color: Colors.white60)),
                              );
                            }
                            return ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              itemCount: payments.length,
                              itemBuilder: (context, index) {
                                final tx = payments[index];
                                final amount = tx['amount'] ?? 0.0;
                                final method = tx['method'] ?? 'CLICK';
                                final status = tx['status'] ?? 'PENDING';
                                final description = tx['description'] ?? 'Litsenziya to\'lovi';
                                final createdAt = tx['createdAt'] ?? '';

                                String dateStr = '';
                                if (createdAt.isNotEmpty) {
                                  try {
                                    final dt = DateTime.parse(createdAt);
                                    dateStr = "${dt.day}-${dt.month}-${dt.year}";
                                  } catch (e) {
                                    dateStr = createdAt.toString().split('T').first;
                                  }
                                }

                                return _txItem(
                                  "$description ($method)",
                                  dateStr,
                                  "- $amount UZS",
                                  true,
                                  status,
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
      ),
    );
  }

  static Widget _actionBtn(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            shape: BoxShape.circle,
            border: Border.all(color: color.withAlpha(40)),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(140), fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  static Widget _txItem(String title, String date, String amount, bool isDebit, String status) {
    Color statusColor = AppTheme.warning;
    if (status == 'SUCCESS') {
      statusColor = AppTheme.success;
    } else if (status == 'FAILED') {
      statusColor = AppTheme.danger;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withAlpha(140),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isDebit ? AppTheme.danger : AppTheme.success).withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDebit ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: isDebit ? AppTheme.danger : AppTheme.success,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(date, style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(120))),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: statusColor.withAlpha(60)),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: isDebit ? AppTheme.danger : AppTheme.success,
            ),
          ),
        ],
      ),
    );
  }
}
