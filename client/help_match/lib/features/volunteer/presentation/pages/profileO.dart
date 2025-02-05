import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profile_Page_O extends StatefulWidget {
  const Profile_Page_O({super.key});

  @override
  State<Profile_Page_O> createState() => _Profile_Page_OState();
}

class _Profile_Page_OState extends State<Profile_Page_O> {
  int _selectedIndex = 4; // Profile is selected
  
  final _formKey_for_profile = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey_for_profile,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildProfileHeader(),
                const SizedBox(height: 24),

                // Divider
                const Divider(thickness: 2, height: 2),
                const SizedBox(height: 32),

                // Profile Picture Section
                _buildProfilePictureSection(),
                const SizedBox(height: 32),

                // Org. Name Field

                _buildOrgNameField(),
                const SizedBox(height: 20),

                _buildOrgtypeField(),
                const SizedBox(height: 32),

                // Categories
                _buildOrgdescriptionField(),
                const SizedBox(height: 40),

                // Confirm Button
                _buildConfirmButton(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Manage Your Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.person, size: 32),
        ),
      ],
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
        ),
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        Stack(
          alignment: Alignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              // backgroundImage:
              // AssetImage('assets/placeholder.png'),
            ),
            Positioned(
              // bottom: 0,
              // right: 0,
              child: GestureDetector(
                onTap: () => _changeProfilePicture(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt,
                      color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Change Profile Picture',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildOrgNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Change Organization Name',
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
    );
  }

  Widget _buildOrgtypeField() {
    return DropdownButtonFormField<String>(
      value: _selectedOrganizationType,
      decoration: InputDecoration(
        labelText: 'Change Organization Type',
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
    );
  }

  Widget _buildOrgdescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      maxLength: 300,
      decoration: InputDecoration(
        labelText: 'Change Organization Description',
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
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        onPressed: _saveProfile,
        child: const Text(
          'Confirm Changes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Location',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
      
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      
      ],
      // onTap: (index) => setState(() => _selectedIndex = index),
      onTap: (index) =>
          setState(() => _selectedIndex = _change_to_pages(index)),
    );
  }

// ignore: non_constant_identifier_names
  _change_to_pages(int index) {
    if (index == 2) {
      return {Navigator.pop(context), Navigator.pushNamed(context, '/homeo')};
    } else if (index == 3) {
      return {Navigator.pop(context), Navigator.pushNamed(context, '/homec')};
    } else if (index == 0) {
      return {Navigator.pop(context), Navigator.pushNamed(context, '/navo')};
    } else if (index == 1) {
      return {Navigator.pop(context), Navigator.pushNamed(context, '/homen')};
    }
  }

  void _changeProfilePicture() async {
    // Implement image picker logic

    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   // Handle the picked image
    // }
  }

  void _saveProfile() {
    // if (_formKey_for_profile.currentState!.validate()) {
    // // Save profile changes
    // print('Name: ${_nameController.text}');
    // print('Username: ${_usernameController.text}');
    // print('Selected Categories: $_selectedCategories');
    // }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
