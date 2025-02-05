import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Addjob extends StatefulWidget {
  const Addjob({super.key});

  @override
  State<Addjob> createState() => _OrganizationSignUpScreenState();
}

class _OrganizationSignUpScreenState extends State<Addjob> {
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
                  'Add Job title and description for non-profit',
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
                      'Confirm',
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

  // Widget _buildStepper() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: List.generate(3, (index) => _buildStep(index + 1)),
  //   );
  // }

  // Widget _buildStep(int stepNumber) {
  //   final isActive = stepNumber == _currentStep;
  //   final isCompleted = stepNumber < _currentStep;
  //   return Expanded(
  //     child: Column(
  //       children: [
  //         Container(
  //           width: 32,
  //           height: 32,
  //           decoration: BoxDecoration(
  //             color: isActive ? Colors.green :
  //                    isCompleted ? Colors.green.withOpacity(0.2) : Colors.grey[300],
  //             shape: BoxShape.circle,
  //           ),
  //           child: Center(
  //             child: isCompleted
  //                 ? const Icon(Icons.check, size: 18, color: Colors.green)
  //                 : Text(
  //                     '$stepNumber',
  //                     style: TextStyle(
  //                       color: isActive ? Colors.white : Colors.grey[600],
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //           ),
  //         ),
  //         if (stepNumber < 3)
  //           Expanded(
  //             child: Container(
  //               margin: const EdgeInsets.symmetric(horizontal: 4),
  //               height: 2,
  //               color: isCompleted ? Colors.green : Colors.grey[300],
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  // void _handleContinue() {
  //   if (_formKey.currentState!.validate()) {
  //     // Handle form submission
  //     print('Organization Name: ${_job_title_Controller.text}');
  //     print('Organization Type: $_selectedOrganizationType');
  //     print('Description: ${_descriptionController.text}');
  //     // Navigate to next step

  //     Navigator.pop(context);
  //     Navigator.pushNamed(context, '/signino2');

  //   }
  // }

  void _change_to_o2() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/signino2');
  }

  @override
  void dispose() {
    _job_title_Controller.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
