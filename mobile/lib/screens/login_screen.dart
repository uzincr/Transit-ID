import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../core/theme.dart';
import '../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController(text: '+998');
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());
  bool _isOtpStep = false;
  String _phone = '';

  @override
  void dispose() {
    _phoneController.dispose();
    for (var c in _otpControllers) { c.dispose(); }
    for (var f in _otpFocusNodes) { f.dispose(); }
    super.dispose();
  }

  void _onOtpChanged(int i, String v) {
    if (v.isNotEmpty && i < 5) {
      _otpFocusNodes[i + 1].requestFocus();
    }
    if (v.isEmpty && i > 0) {
      _otpFocusNodes[i - 1].requestFocus();
    }
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 6) {
      context.read<AuthBloc>().add(AuthOtpVerifyRequested(phone: _phone, otp: otp));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthOtpSent) {
          setState(() {
            _isOtpStep = true;
            _phone = state.phone;
          });
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(state.message, style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppTheme.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ));
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            const BackgroundGlows(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Animated Glow Logo
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryCyan.withAlpha(80),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.directions_car_rounded, size: 44, color: AppTheme.darkBg),
                      ),
                      const SizedBox(height: 28),
                      // Title
                      const GradientText(
                        text: 'TransitID',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isOtpStep ? 'Tasdiqlash kodini kiriting' : 'Taksi haydovchilari integratsiya platformasi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withAlpha(140),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Form Card
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.08),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: _isOtpStep ? _buildOtpStep() : _buildPhoneStep(),
                      ),
                      const SizedBox(height: 80),
                      Text(
                        'Davom etish orqali siz foydalanish\nshartlariga rozilik bildirasiz',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withAlpha(60),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      key: const ValueKey('phone'),
      children: [
        GlassCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            inputFormatters: [
              LengthLimitingTextInputFormatter(13),
              FilteringTextInputFormatter.allow(RegExp(r'[\d+]')),
            ],
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryCyan.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.phone_android_rounded, color: AppTheme.primaryCyan, size: 20),
              ),
              hintText: '+998 XX XXX XX XX',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 28),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (ctx, state) {
            return GradientButton(
              label: 'Davom etish',
              icon: Icons.arrow_forward_rounded,
              isLoading: state is AuthLoading,
              onPressed: () {
                final p = _phoneController.text.trim();
                if (p.length >= 12) {
                  ctx.read<AuthBloc>().add(AuthOtpSendRequested(p));
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      key: const ValueKey('otp'),
      children: [
        // Number badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.primaryCyan.withAlpha(20),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryCyan.withAlpha(50)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.phone_rounded, size: 16, color: AppTheme.primaryCyan),
              const SizedBox(width: 8),
              Text(
                _phone,
                style: const TextStyle(color: AppTheme.primaryCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _isOtpStep = false),
                child: Icon(Icons.edit_rounded, size: 15, color: Colors.white.withAlpha(120)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        // OTP Inputs
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (i) {
            return Container(
              width: 42,
              height: 50,
              margin: EdgeInsets.only(right: i < 5 ? 6 : 0),
              child: TextField(
                controller: _otpControllers[i],
                focusNode: _otpFocusNodes[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: AppTheme.cardDark.withAlpha(180),
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryCyan, width: 1.8),
                  ),
                ),
                onChanged: (v) => _onOtpChanged(i, v),
              ),
            );
          }),
        ),
        const SizedBox(height: 32),
        // Confirm Button
        BlocBuilder<AuthBloc, AuthState>(
          builder: (ctx, state) {
            return GradientButton(
              label: 'Tasdiqlash',
              icon: Icons.check_circle_outline_rounded,
              isLoading: state is AuthLoading,
              onPressed: () {
                final otp = _otpControllers.map((c) => c.text).join();
                if (otp.length == 6) {
                  ctx.read<AuthBloc>().add(AuthOtpVerifyRequested(phone: _phone, otp: otp));
                }
              },
            );
          },
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => context.read<AuthBloc>().add(AuthOtpSendRequested(_phone)),
          child: Text(
            'Kodni qayta yuborish',
            style: TextStyle(color: Colors.white.withAlpha(120), fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
