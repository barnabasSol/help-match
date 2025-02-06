import 'package:flutter/material.dart';
import 'package:help_match/core/theme/cubit/theme_cubit.dart';

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
               Icon(Icons.volunteer_activism,
                  size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 32),

              // Title
               Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Which type of account would you like?',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // Account Type Cards
               AccountTypeCard(
                title: 'Volunteer',
                subtitle: 'I am a professional looking to volunteer',
                icon: Icons.person,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(height: 24),

               AccountTypeCard(
                title: 'Organization',
                subtitle:
                    'My non-profit Organization is looking for volunteers',
                icon: Icons.business,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(height: 40),

              // Existing Account Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(color: Theme.of(context).colorScheme.tertiary,),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to login
                    },
                    child:  Text(
                      'Log In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
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
            Navigator.pushNamed(context, '/signupv1');
               
        }
        else if(title == 'Organization'){
            Navigator.pop(context);
            Navigator.pushNamed(context, '/signupo1');
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
