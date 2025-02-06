import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_match/shared/widgets/gradient_button.dart';

class Signupo2 extends StatefulWidget {
  const Signupo2({super.key});

  @override
  State<Signupo2> createState() => _SigninState();
}

class _SigninState extends State<Signupo2> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Icon(Icons.business, size: 80, color: Theme.of(context).colorScheme.primary,),
                const SizedBox(height: 24),

                // Title
                 Text(
                  'Your Organization',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                   color: Theme.of(context).colorScheme.onPrimary,
                   ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Create user account that will manage the Organization',
                  style: TextStyle(
                    fontSize: 16,  
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),

                _buildNameField(),
                const SizedBox(height: 20),

                // Form Field
                _buildUsernameField(),
                const SizedBox(height: 20),

                _buildEmailField(),  
                const SizedBox(height: 20),
               

                // Password Input
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onSecondary,
                 
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Sign In Button
               SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    // key: _formKey,
                    text: 'Continue',
                    onPressed: _change_to_Home,
                    fontSize: 16,
                  ),
                ),


               
               
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       padding: const EdgeInsets.symmetric(vertical: 16),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       // backgroundColor: Theme.of(context).colorScheme.primary,
                //       // backgroundColor: Colors.blue,
                //          backgroundColor: Colors.green,
                   

                //       foregroundColor: Colors.white,
                //     ),
                //     onPressed: () {
                //       _change_to_Home();
                //     },
                //     child: const Text(
                //       'Sign Up',
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),






                const SizedBox(height: 24),
               ],
            ),
          ),
        ),
      ),
    );
  }

void _change_to_Home() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/homeo');
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
        fillColor: Theme.of(context).colorScheme.onSecondary
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your full name';
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
        fillColor: Theme.of(context).colorScheme.onSecondary              
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

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
