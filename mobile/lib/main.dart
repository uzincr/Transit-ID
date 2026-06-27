import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth_bloc.dart';
import 'blocs/profile_cubit.dart';
import 'blocs/license_cubit.dart';
import 'blocs/payment_cubit.dart';
import 'blocs/notification_cubit.dart';
import 'core/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.cardDarkAlt,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const TransitIdApp());
}

class TransitIdApp extends StatelessWidget {
  const TransitIdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()..add(AuthCheckRequested())),
        BlocProvider<ProfileCubit>(create: (_) => ProfileCubit()),
        BlocProvider<LicenseCubit>(create: (_) => LicenseCubit()),
        BlocProvider<PaymentCubit>(create: (_) => PaymentCubit()),
        BlocProvider<NotificationCubit>(create: (_) => NotificationCubit()),
      ],
      child: MaterialApp(
        title: 'TransitID',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // Trigger initial data fetch
              context.read<ProfileCubit>().fetchProfile();
              context.read<LicenseCubit>().fetchLicenses();
              context.read<PaymentCubit>().fetchPayments();
              context.read<NotificationCubit>().fetchNotifications();
              
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainShell()),
                (route) => false,
              );
            } else if (state is AuthUnauthenticated) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          },
          child: const SplashScreen(),
        ),
      ),
    );
  }
}
