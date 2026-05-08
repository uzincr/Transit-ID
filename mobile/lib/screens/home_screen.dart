import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildIconButton(Icons.menu),
                      Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF00F0FF), Color(0xFFD400FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: const Text(
                              'TransitID',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            'TAXI DRIVER',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 2.0,
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      _buildIconButton(Icons.notifications_outlined),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Profile Area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00F0FF), Color(0xFFD400FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD400FF).withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(0xFF1E2130),
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Name & ID
                        const Text(
                          'SAMUEL R. ADAMS',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ID: ',
                              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
                            ),
                            const Text(
                              'TID-8842109',
                              style: TextStyle(color: Color(0xFF00F0FF), fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // License Card
                        _buildGlassCard(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('DRIVER LICENSE', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.0, fontSize: 14)),
                                    Text('Class B', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network('https://i.pravatar.cc/150?img=11', width: 60, height: 60),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.greenAccent.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                                            ),
                                            child: const Text('ACTIVE', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                                          ),
                                          const SizedBox(height: 8),
                                          Text('EXPIRES', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
                                          const Text('12 MAY 2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                          const SizedBox(height: 8),
                                          Text('ISSUING AUTHORITY', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
                                          const Text('CITY TRANSPORT DEPT.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // QR Section
                        Text('SCAN TO VERIFY', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF00F0FF), Color(0xFFD400FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: QrImageView(
                            data: 'transitid://verify/TID-8842109',
                            version: QrVersions.auto,
                            size: 150.0,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('LICENSE QR CODE', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, letterSpacing: 1.0)),
                        
                        const SizedBox(height: 30),
                        
                        // Status & Links
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2130).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('Status: ', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
                                  const Text('VERIFIED', style: TextStyle(color: Color(0xFF00F0FF), fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.0)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00F0FF).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, size: 16, color: Color(0xFF00F0FF)),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Quick Links', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              _buildQuickLink(Icons.account_balance_wallet_outlined, 'DAILY\nEARNINGS'),
                              const SizedBox(width: 12),
                              _buildQuickLink(Icons.history_outlined, 'TRIP\nLOGS'),
                              const SizedBox(width: 12),
                              _buildQuickLink(Icons.support_agent_outlined, 'SUPPORT'),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                      ],
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

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2130).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Icon(icon, size: 20, color: Colors.white.withOpacity(0.8)),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2130).withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildQuickLink(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2130).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white.withOpacity(0.6)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}
