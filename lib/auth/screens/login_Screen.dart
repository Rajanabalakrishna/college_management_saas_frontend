
// lib/screens/auth/login_screen.dart
import 'package:college_management_saas/auth/auth_provider.dart';
import 'package:college_management_saas/auth/screens/signUpScreen.dart';
import 'package:college_management_saas/auth/screens/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home_screen.dart';
import '../../theme/app_colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String? initialCollegeDomain;

  const LoginScreen({
    Key? key,
    this.initialCollegeDomain,
  }) : super(key: key);
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _collegeDomainController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _collegeDomainController.text = widget.initialCollegeDomain ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _collegeDomainController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final collegeDomain = _collegeDomainController.text.trim();

    if (email.isEmpty || password.isEmpty || collegeDomain.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email, password and college domain are required'),
        ),
      );
      return;
    }

    await ref.read(authProvider.notifier).login(
      email,
      password,
      collegeDomain,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authProvider);

    final isLoading = authAsync.when(
      data: (authState) {
        return authState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
      },
      loading: () => true,
      error: (_, __) => false,
    );

    ref.listen<AsyncValue<AuthState>>(authProvider, (previous, next) {
      next.when(
        data: (authState) {
          authState.maybeWhen(
            authenticated: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login successful')),



              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const CampusExploreScreen(),
                ),
              );



            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            orElse: () {},
          );
        },
        loading: () {},
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.school_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),

                const Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'Sign in to access your dashboard',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                CustomTextField(
                  label: 'Email Address',
                  hint: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  controller: _passwordController,
                  isPassword: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.outline,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'College Domain',
                  hint: 'example.edu',
                  prefixIcon: Icons.account_balance_outlined,
                  controller: _collegeDomainController,
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onPrimary,
                    ),
                  )
                      : const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
