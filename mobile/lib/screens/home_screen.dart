import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../blocs/profile_cubit.dart';
import '../blocs/license_cubit.dart';
import '../core/theme.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundGlows(),
          SafeArea(
            child: Column(
              children: [
                // Top Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _iconBtn(Icons.menu_rounded),
                      Column(
                        children: [
                          const GradientText(
                            text: 'TransitID',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'HAYDOVCHI PORTALI',
                            style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 2.5,
                              color: Colors.white.withAlpha(120),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      _iconBtn(Icons.notifications_none_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProfileCubit>().fetchProfile();
                      context.read<LicenseCubit>().fetchLicenses();
                    },
                    color: AppTheme.primaryCyan,
                    backgroundColor: AppTheme.cardDark,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, profileState) {
                          if (profileState is ProfileLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 80),
                                child: CircularProgressIndicator(color: AppTheme.primaryCyan),
                              ),
                            );
                          }
                          if (profileState is ProfileError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  children: [
                                    const Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 48),
                                    const SizedBox(height: 12),
                                    Text(profileState.message, style: const TextStyle(color: Colors.white70)),
                                  ],
                                ),
                              ),
                            );
                          }
                          if (profileState is ProfileLoaded) {
                            final profile = profileState.data;
                            final driverName = profile['fullName'] ?? 'HAYDOVCHI';
                            final carBrand = profile['carBrand'] ?? 'Avtomobil kiritilmagan';
                            final carNumber = profile['carNumber'] ?? '';
                            final licenseClass = profile['licenseClass'] ?? 'B';

                            return BlocBuilder<LicenseCubit, LicenseState>(
                              builder: (context, licenseState) {
                                dynamic activeLicense;
                                if (licenseState is LicenseLoaded) {
                                  final licenses = licenseState.licenses;
                                  if (licenses.isNotEmpty) {
                                    activeLicense = licenses.firstWhere(
                                      (lic) =>
                                          lic['status'] == 'ACTIVE' ||
                                          lic['status'] == 'EXPIRING' ||
                                          lic['status'] == 'EXPIRED',
                                      orElse: () => licenses.first,
                                    );
                                  }
                                }

                                final hasLicense = activeLicense != null;
                                final licenseNum = hasLicense ? activeLicense['licenseNumber'] : 'Litsenziyasiz';
                                final expiryDate = hasLicense ? activeLicense['expiryDate'] : 'Noma\'lum';
                                final status = hasLicense ? activeLicense['status'] : 'NO_LICENSE';

                                return Column(
                                  children: [
                                    // Profile Header / Avatar Section
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: AppTheme.primaryGradient,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.primaryCyan.withAlpha(50),
                                            blurRadius: 20,
                                            spreadRadius: 1,
                                          )
                                        ],
                                      ),
                                      child: const CircleAvatar(
                                        radius: 42,
                                        backgroundColor: AppTheme.cardDark,
                                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      driverName,
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('ID: ', style: TextStyle(color: Colors.white.withAlpha(140), fontSize: 12)),
                                          Text(
                                            licenseNum,
                                            style: const TextStyle(
                                              color: AppTheme.primaryCyan,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // DRIVER LICENSE SMART CARD
                                    _buildSmartCard(
                                      driverName: driverName,
                                      licenseNum: licenseNum,
                                      licenseClass: licenseClass,
                                      expiryDate: expiryDate,
                                      carInfo: carNumber.isNotEmpty ? '$carBrand · $carNumber' : carBrand,
                                      status: status,
                                      hasLicense: hasLicense,
                                    ),

                                    const SizedBox(height: 24),

                                    // QR Code Section / Verification
                                    if (hasLicense) ...[
                                      const Text(
                                        'TEKSHIRISH UCHUN QR KOD',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(12),
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(color: Colors.white.withAlpha(15)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.primaryCyan.withAlpha(15),
                                              blurRadius: 20,
                                            )
                                          ]
                                        ),
                                        child: QrImageView(
                                          data: 'https://api-transitid.uzinc.uz/api/verify/license/$licenseNum',
                                          version: QrVersions.auto,
                                          size: 130,
                                          eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.white),
                                          dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                    ],

                                    // Status info banner
                                    _buildStatusBanner(status),

                                    const SizedBox(height: 28),
                                    // Quick Links Sarlavha
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Tezkor xizmatlar',
                                          style: TextStyle(
                                            color: Colors.white.withAlpha(180),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Quick Links Horizontal List
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        children: [
                                          _quickLinkTile(Icons.account_balance_wallet_rounded, 'TUSHUMLAR', AppTheme.primaryCyan),
                                          const SizedBox(width: 12),
                                          _quickLinkTile(Icons.history_edu_rounded, 'TARIX', AppTheme.secondaryPurple),
                                          const SizedBox(width: 12),
                                          _quickLinkTile(Icons.headset_mic_rounded, 'YORDAM', AppTheme.success),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 36),
                                  ],
                                );
                              },
                            );
                          }
                          return const Center(child: Text('Yuklanmoqda...'));
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withAlpha(150),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha(12)),
      ),
      child: Icon(icon, size: 22, color: Colors.white.withAlpha(220)),
    );
  }

  Widget _buildSmartCard({
    required String driverName,
    required String licenseNum,
    required String licenseClass,
    required String expiryDate,
    required String carInfo,
    required String status,
    required bool hasLicense,
  }) {
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
                    'GUVOHNOMA',
                    style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 13, color: Colors.white),
                  ),
                  Text(
                    'TRANSITID SMART CARD',
                    style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 9, letterSpacing: 1.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // Smart-card Microchip Drawing representation
              Container(
                width: 38,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFFFB300).withAlpha(50), blurRadius: 8),
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(6, (i) => Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withAlpha(60), width: 0.5),
                        color: Colors.transparent,
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // Photo Frame
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.primaryCyan.withAlpha(100)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://i.pravatar.cc/150?img=11',
                    width: 68,
                    height: 68,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (status == 'ACTIVE') StatusBadge.active()
                        else if (status == 'EXPIRING') StatusBadge.expiring()
                        else if (status == 'EXPIRED') StatusBadge.expired()
                        else const StatusBadge(label: 'FAOL EMAS', color: Colors.grey),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryCyan.withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Class $licenseClass',
                            style: const TextStyle(
                              color: AppTheme.primaryCyan,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('MUDDATI', style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 9, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
                    Text(expiryDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('AVTOMOBIL', style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 9, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
                    Text(carInfo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(String status) {
    final isActive = status == 'ACTIVE';
    final isExpiring = status == 'EXPIRING';
    final color = isActive ? AppTheme.success : (isExpiring ? AppTheme.warning : AppTheme.danger);
    final icon = isActive ? Icons.check_circle_outline_rounded : (isExpiring ? Icons.error_outline_rounded : Icons.cancel_outlined);
    final text = isActive ? 'LITSENZIYA TIZIMI FAOL' : (isExpiring ? 'LITSENZIYA MUDDATI TUGAYAPTI' : 'LITSENZIYA MUDDATI O\'TGAN');

    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      baseColor: color.withAlpha(10),
      borderOpacity: 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_forward_ios_rounded, size: 10, color: color),
          ),
        ],
      ),
    );
  }

  Widget _quickLinkTile(IconData icon, String label, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withAlpha(180),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
          )
        ]
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: accentColor),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
