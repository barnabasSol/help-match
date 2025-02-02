import 'package:flutter/material.dart';

class Signupv3 extends StatefulWidget {
  const Signupv3({super.key});

  @override
  State<Signupv3> createState() => _VolunteerInterestScreenState();
}

class _VolunteerInterestScreenState extends State<Signupv3> {
  final Set<int> _selectedInterests = {};
  final List<String> _categories = const [
    
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              const Icon(Icons.volunteer_activism,
                  size: 80, color: Colors.blue),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Your Volunteer',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Create account to Volunteer',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),

              // Interest Chips
              _buildCategoryChips(),
              const SizedBox(height: 40),

              // Signup Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
                    // backgroundColor: Theme.of(context).colorScheme.primary,

                    foregroundColor: Colors.white,
                  ),
                  onPressed:
                      _selectedInterests.isEmpty ? null : _change_to_Home,
                  child: const Text(
                    'Sign Up',
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
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: List.generate(_categories.length, (index) {
        final isSelected = _selectedInterests.contains(index);
        return ChoiceChip(
          label: Text(_categories[index]),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedInterests.add(index);
              } else {
                _selectedInterests.remove(index);
              }
            });
          },
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: Colors.grey[200],
          selectedColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? Colors.blue : Colors.grey[300]!,
              width: 1,
            ),
          ),
        );
      }),
    );
  }

  void _change_to_Home() {
    final abc =_selectedInterests.map((index) => _categories[index].toString());
    print(abc);
    Navigator.pop(context);
    Navigator.pushNamed(context, '/homev');
  }
}
