import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_match/shared/widgets/gradient_button.dart';
class Signupo1 extends StatefulWidget {
  const Signupo1({super.key});

  @override
  State<Signupo1> createState() => _OrganizationSignUpScreenState();
}

class _OrganizationSignUpScreenState extends State<Signupo1> {
  final _formKey = GlobalKey<FormState>();
  // final int _currentStep = 1; // Assuming this is step 2 of 3
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedOrganizationType;

  final List<String> _organizationTypes = const [
    'Non Profit',
    'For Profit',
    'Government',
    'Community',
    'Education',
    'Healthcare',
    'Cultural'
  ];

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
                Icon(Icons.business, size: 80, color: Theme.of(context).colorScheme.primary),
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
                  'Create an account for non-profit',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),

                // Custom Stepper
                // _buildStepper(),
                // const SizedBox(height: 32),

                // Organization Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Organization Name',
                    prefixIcon: const Icon(Icons.business_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                     fillColor: Theme.of(context).colorScheme.onSecondary,),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter organization name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Organization Type Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedOrganizationType,
                  decoration: InputDecoration(
                    labelText: 'Organization Type',
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                     fillColor: Theme.of(context).colorScheme.onSecondary,),
                  items: _organizationTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedOrganizationType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select organization type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Organization Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  maxLength: 300,
                  decoration: InputDecoration(
                    labelText: 'Organization Description',
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

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      // Location Capture Card
                      InkWell(
                        onTap: () {
                          // Add location capture logic here
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSecondary,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Theme.of(context).colorScheme.primary),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                               Icon(Icons.my_location,
                                  size: 40, color: Theme.of(context).colorScheme.primary,),
                              const SizedBox(height: 12),
                               Text(
                                'Click to Obtain Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'We need your location to connect with local organizations',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                     color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Continue Button
                   SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    // key: _formKey,
                    text: 'Continue',
                    onPressed: _change_to_o2,
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
  
  void _change_to_o2() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/signino2');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
