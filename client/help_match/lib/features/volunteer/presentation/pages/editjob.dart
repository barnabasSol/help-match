import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                const Icon(Icons.business, size: 80, color: Colors.green),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Organization Name',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Edit Job title and description for non-profit',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),

                // Custom Stepper
                // _buildStepper(),
                const SizedBox(height: 32),

                // Job Title
                TextFormField(
                  controller: _job_title_Controller,
                  decoration: InputDecoration(
                    labelText: 'Job Title',
                    prefixIcon: const Icon(Icons.work),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
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
                    labelText: 'Job Description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: (){},
                    child: const Text(
                      ' Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
