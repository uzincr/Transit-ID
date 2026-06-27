// ═══════════════════════════════════════════════════════════
// TransitID — Auth BLoC (State Management)
// ═══════════════════════════════════════════════════════════

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants.dart';
import '../core/api_client.dart';

// ── Events ──
abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthOtpSendRequested extends AuthEvent {
  final String phone;
  AuthOtpSendRequested(this.phone);
}

class AuthOtpVerifyRequested extends AuthEvent {
  final String phone;
  final String otp;
  AuthOtpVerifyRequested({required this.phone, required this.otp});
}

class AuthLogoutRequested extends AuthEvent {}

// ── States ──
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthOtpSent extends AuthState {
  final String phone;
  AuthOtpSent(this.phone);
}

class AuthAuthenticated extends AuthState {
  final String phone;
  final String role;
  final String userId;
  AuthAuthenticated({required this.phone, required this.role, required this.userId});
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// ── BLoC ──
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckAuth);
    on<AuthOtpSendRequested>(_onSendOtp);
    on<AuthOtpVerifyRequested>(_onVerifyOtp);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onCheckAuth(AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await _storage.read(key: AppConstants.accessTokenKey);
      final phone = await _storage.read(key: AppConstants.userPhoneKey);
      final role = await _storage.read(key: AppConstants.userRoleKey);
      final userId = await _storage.read(key: AppConstants.userIdKey);

      if (token != null && phone != null) {
        emit(AuthAuthenticated(
          phone: phone,
          role: role ?? 'DRIVER',
          userId: userId ?? '',
        ));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSendOtp(AuthOtpSendRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final client = ApiClient();
      final response = await client.dio.post('/auth/otp/send', data: {
        'phone': event.phone,
      });
      if (response.statusCode == 200) {
        // Output debug OTP to console for easy local testing
        final otpDebug = response.data['otp_debug'];
        print("TransitID DEBUG OTP sent: $otpDebug");
        emit(AuthOtpSent(event.phone));
      } else {
        emit(AuthError('SMS yuborishda xatolik yuz berdi'));
      }
    } catch (e) {
      emit(AuthError('SMS yuborishda xatolik yuz berdi: ${e.toString()}'));
    }
  }

  Future<void> _onVerifyOtp(AuthOtpVerifyRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final client = ApiClient();
      final response = await client.dio.post('/auth/otp/verify', data: {
        'phone': event.phone,
        'otp': event.otp,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final userId = data['userId'];
        final role = data['role'];
        final phone = data['phone'];

        await client.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
        await _storage.write(key: AppConstants.userPhoneKey, value: phone);
        await _storage.write(key: AppConstants.userRoleKey, value: role);
        await _storage.write(key: AppConstants.userIdKey, value: userId);

        emit(AuthAuthenticated(
          phone: phone,
          role: role,
          userId: userId,
        ));
      } else {
        emit(AuthError('Noto\'g\'ri kod kiritildi'));
      }
    } catch (e) {
      emit(AuthError('Tasdiqlashda xatolik: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    final client = ApiClient();
    await client.clearTokens();
    emit(AuthUnauthenticated());
  }
}
