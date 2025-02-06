import 'package:flutter/material.dart';
import 'package:help_match/shared/widgets/gradient_button.dart';

class Signupv2 extends StatefulWidget {
  const Signupv2({super.key});

  @override
  State<Signupv2> createState() => _VolunteerPasswordScreenState();
}

class _VolunteerPasswordScreenState extends State<Signupv2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                 Icon(Icons.volunteer_activism,
                    size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 24),

                // Title
                 Text(
                  'Your Volunteer',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Create account to Volunteer',
                  style: TextStyle(
                    fontSize: 16,
                     color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),

                // Password Fields
                _buildPasswordField(),
                const SizedBox(height: 20),
                _buildConfirmPasswordField(),
                const SizedBox(height: 40),

                // Continue Button            
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    // key: _formKey,
                    text: 'Continue',
                    onPressed: _change_to_v3,
                    fontSize: 16,
                  ),
                ), 

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
           color: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
     fillColor: Theme.of(context).colorScheme.onSecondary,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter a password';
        if (value.length < 8) return 'Password must be at least 8 characters';
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        prefixIcon: const Icon(Icons.lock_reset),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color:Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
     fillColor: Theme.of(context).colorScheme.onSecondary,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) return 'Passwords do not match';
        return null;
      },
    );
  }

  void _change_to_v3() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/signinv3');
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
