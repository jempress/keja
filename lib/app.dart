import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/shared/bottom_nav_scaffold.dart';
import 'theme/app_theme.dart';

class KejaApp extends StatelessWidget {
  const KejaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Keja',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.isLoading) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return auth.isLoggedIn ? const HomeShell() : const LoginScreen();
          },
        ),
      ),
    );
  }
}
