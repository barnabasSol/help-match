import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_match/shared/widgets/gradient_button.dart';

class Editjob extends StatefulWidget {
  const Editjob({super.key});

  @override
  State<Editjob> createState() => _OrganizationSignUpScreenState();
}

class _OrganizationSignUpScreenState extends State<Editjob> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _job_title_Controller = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
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
                Icon(Icons.business, size: 80,color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 24),

                // Title
                 Text(
                  'Organization Name',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Edit Job title and description for non-profit',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 32),

                // Job Title
                TextFormField(
                  controller: _job_title_Controller,
                  decoration: InputDecoration(
                    labelText: 'Edit Job Title',
                    prefixIcon: const Icon(Icons.work),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onSecondary,
                     ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter organization name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Job Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  maxLength: 300,
                  decoration: InputDecoration(
                    labelText: 'Edit Job Description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onSecondary,
                  helperText: 'Brief description (max 300 characters)',
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(300),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter organization description';
                    }
                    if (value.length < 50) {
                      return 'Description should be at least 50 characters';
                    }
                    return null;
                  },
                ),
               
                const SizedBox(height: 40),

                // Continue Button
                SizedBox(
                 width: double.infinity,
                 child: GradientButton(
                 text: 'Confirm Changes',
                 onPressed: (){},
                 fontSize: 16,)
                ),     
               
                ],
            ),
          ),
        ),
      ),
    );
  }

  
  @override
  void dispose() {
    _job_title_Controller.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
