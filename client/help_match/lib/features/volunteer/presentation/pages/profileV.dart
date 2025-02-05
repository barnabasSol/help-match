import 'package:flutter/material.dart';

class Profile_Page_V extends StatefulWidget {
  const Profile_Page_V({super.key});

  @override
  State<Profile_Page_V> createState() => _Profile_Page_VState();
}

class _Profile_Page_VState extends State<Profile_Page_V> {
  int _selectedIndex = 4; // Profile is selected
  
  final _formKey_for_profile = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final Set<String> _selectedCategories = {};

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

                // Name Fields
                _buildNameField(),
                const SizedBox(height: 20),
                _buildUsernameField(),
                const SizedBox(height: 32),

                // Categories
                _buildCategorySection(),
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
      Align(alignment: Alignment.center,),
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
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 24),
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

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Change Volunteer Name',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your name';
        return null;
      },
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Change Username',
        prefixIcon: const Icon(Icons.alternate_email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter a username';
        return null;
      },
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Change Interest',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            return FilterChip(
              label: Text(category),
              selected: _selectedCategories.contains(category),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
              // ignore: deprecated_member_use
              selectedColor: Colors.blue.withOpacity(0.2),
              checkmarkColor: Colors.blue,
              labelStyle: TextStyle(
                color: _selectedCategories.contains(category)
                    ? Colors.blue
                    : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            );
          }).toList(),
        ),
      ],
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
        onTap: (index) => setState(() => _selectedIndex = _change_to_pages(index)),
    );
  }

// ignore: non_constant_identifier_names
 _change_to_pages(int index) {
    
    if (index == 2) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homev')};}

    else if (index == 3) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homec')};}


    else if (index == 0) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/navv')};}


    else if (index == 1) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homen')};}
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