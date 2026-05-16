// lib/screens/auth/signup_screen.dart
import 'package:college_management_saas/auth/screens/widgets/textfield.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Student specific controllers
  final _collegeIdController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _branchController = TextEditingController();

  String _selectedRole = 'Student'; // Default role
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
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
                const Text(
                  'Create an Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Join your college workspace today',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // Role Selector
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: ['Student', 'Faculty', 'Admin'].map((role) {
                      final isSelected = _selectedRole == role;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedRole = role),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.surface : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: isSelected
                                  ? [BoxShadow(color: AppColors.outlineVariant, blurRadius: 4)]
                                  : [],
                            ),
                            child: Text(
                              role,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                CustomTextField(
                  label: 'Full Name',
                  hint: 'John Doe',
                  prefixIcon: Icons.person_outline,
                  controller: _fullNameController,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Email Address',
                  hint: 'john@college.edu',
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'College ID',
                  hint: 'Enter your College/Org ID',
                  prefixIcon: Icons.account_balance_outlined,
                  controller: _collegeIdController,
                ),
                const SizedBox(height: 20),

                // Dynamic Student Fields
                AnimatedCrossFade(
                  firstChild: Container(), // Empty if not student
                  secondChild: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'Roll Number',
                              hint: 'e.g. 19XJ1A0501',
                              prefixIcon: Icons.badge_outlined,
                              controller: _rollNoController,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              label: 'Branch',
                              hint: 'e.g. CSE',
                              prefixIcon: Icons.class_outlined,
                              controller: _branchController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  crossFadeState: _selectedRole == 'Student'
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),

                CustomTextField(
                  label: 'Password',
                  hint: 'Create a strong password',
                  prefixIcon: Icons.lock_outline,
                  controller: _passwordController,
                  isPassword: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.outline,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: () {
                    // Handle Account Creation logic based on _selectedRole
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}