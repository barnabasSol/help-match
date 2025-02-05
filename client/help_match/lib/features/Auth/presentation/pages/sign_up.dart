import 'package:flutter/material.dart';
import 'package:help_match/features/Auth/presentation/pages/signup_1.dart';
import 'package:help_match/features/Auth/presentation/pages/signup_org.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              const Icon(Icons.volunteer_activism,
                  size: 80, color: Colors.blue),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Which type of account would you like?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // Account Type Cards
              const AccountTypeCard(
                title: 'Volunteer',
                subtitle: 'I am a professional looking to volunteer',
                icon: Icons.person,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),

              const AccountTypeCard(
                title: 'Organization',
                subtitle:
                    'My non-profit Organization is looking for volunteers',
                icon: Icons.business,
                color: Colors.green,
              ),
              const SizedBox(height: 40),

              // Existing Account Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to login
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const AccountTypeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(

        // ignore: deprecated_member_use
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        // Handle account type selection

        if (title == 'Volunteer') {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (con)=>const Signupv1()));
               
        }
        else if(title == 'Organization'){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (con)=>const Signupo1()));
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}