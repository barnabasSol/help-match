import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_match/shared/widgets/gradient_button.dart';

class Signupv1 extends StatefulWidget {
  const Signupv1({super.key});

  @override
  State<Signupv1> createState() => _VolunteerSignUpScreenState();
}

class _VolunteerSignUpScreenState extends State<Signupv1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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

                const SizedBox(height: 32),

                // Form Fields
                _buildNameField(),
                const SizedBox(height: 20),
                _buildUsernameField(),
                const SizedBox(height: 20),
                _buildEmailField(),
                const SizedBox(height: 40),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    // key: _formKey,
                    text: 'Continue',
                    onPressed: _change_to_v2,
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

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSecondary,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your full name';
        }
        return null;
      },
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
      ],
      decoration: InputDecoration(
        labelText: 'Username',
        prefixIcon: const Icon(Icons.alternate_email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSecondary,
        hintText: '@username',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        }
        if (value.contains(' ')) {
          return 'Username cannot contain spaces';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSecondary,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  void _change_to_v2() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/signinv2');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
