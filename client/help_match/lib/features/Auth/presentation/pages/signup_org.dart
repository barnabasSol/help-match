import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/Auth/presentation/bloc/auth_cubit.dart';
import 'package:help_match/features/Auth/presentation/pages/signup_org_2.dart';
import 'package:help_match/shared/widgets/location_picker.dart';
import 'package:latlong2/latlong.dart';

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
  String info = "We need your location for an easier experience to volunteers";
  final List<String> _organizationTypes = const [
    'Non Profit',
    'For Profit',
    'Government',
    'Community',
    'Education',
    'Healthcare',
    'Cultural'
  ];
  late String _selectedOrganizationType;
  LatLng? _loc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedOrganizationType = _organizationTypes[0];
  }

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
                  'Your Organization',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Create an account for non-profit',
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
                    fillColor: Colors.grey[100],
                  ),
                  items: _organizationTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    value != null
                        ? setState(() {
                            _selectedOrganizationType = value;
                          })
                        : null;
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

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      // Location Capture Card
                      InkWell(
                        onTap: () async {
                          _loc = await showModalBottomSheet<LatLng>(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: LocationPicker(
                                  onLocationPicked: (location) {
                                    Navigator.of(context).pop(location);
                                  },
                                ),
                              );
                            },
                          );
                          if (_loc != null) {
                            setState(() {
                              info =
                                  "Latitude: ${_loc!.latitude} Longitude: ${_loc!.longitude}";
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green[100]!),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.green.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.my_location,
                                  size: 40, color: Colors.green),
                              const SizedBox(height: 12),
                              const Text(
                                'Click to Obtain Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                info,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _change_to_o2,
                    child: const Text(
                      'Continue',
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

  void _change_to_o2() {
    print(_loc!.latitude);
    print(_loc!.latitude);
    print(_loc!.latitude);
    print(_loc!.longitude);
    print(_loc!.longitude);
    print(_loc!.longitude);
    print(_loc!.longitude);
    if (_formKey.currentState!.validate()) {
      context.read<SignUpOrgCubit>().updateOrgName(_nameController.text);
      context.read<SignUpOrgCubit>().updateDesc(_descriptionController.text);
      context.read<SignUpOrgCubit>().updateType(_selectedOrganizationType);
      _loc != null
          ? context.read<SignUpOrgCubit>().updateLocation(_loc!)
          : null;

      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Signupo2()));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
