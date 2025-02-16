import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/core/image_picker.dart';
import 'package:help_match/features/volunteer/bloc/volunteer_bloc.dart';
import 'package:help_match/features/volunteer/dto/org_card_dto.dart';
import 'package:help_match/features/volunteer/dto/vol_profile_dto.dart';
import 'package:help_match/features/volunteer/presentation/screens/volunteer_screen.dart';
import 'package:help_match/shared/widgets/gradient_button.dart';

class VolunteerProfile extends StatefulWidget {
  const VolunteerProfile({super.key});

  @override
  State<VolunteerProfile> createState() => _VolunteerProfileState();
}

class _VolunteerProfileState extends State<VolunteerProfile> {
  final _formKey_for_profile = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final List<String> _selectedCategories = [];
  final List<String> _previousSelectedCategories = [];
  Uint8List? _profile_image;
  bool _isInitialized = false;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    final id = context.read<UserAuthCubit>().currentUser.sub;
    context.read<VolunteerBloc>().add(ProfileInfoFetched(id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VolunteerBloc, VolunteerState>(
      builder: (context, state) {
        if (state is ProfileInfoFetchSuccess) {
          if (!_isInitialized) {
            var user = state.user;
            _nameController.text = user.name;
            _usernameController.text = user.username;
            _selectedCategories.addAll(user.interests!
                .map((cat) => OrgCardDto.invertConvert(cat))
                .toList());
            _previousSelectedCategories.addAll(user.interests!
                .map((cat) => OrgCardDto.invertConvert(cat))
                .toList());
            _isInitialized = true;
          }
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
          );
        } else if (state is ProfileInfoFetchFailure) {
          return const Center(child: Text("Cannot fetch user data"));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      listener: (BuildContext context, VolunteerState state) {
        if (state is ProfileUpdateSuccess) {
          Fluttertoast.showToast(
  msg: "User data updated!",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  backgroundColor:Theme.of(context).colorScheme.onPrimary,
  textColor:Theme.of(context).colorScheme.onSecondary,
);
          Navigator.push(context,
              MaterialPageRoute(builder: (con) => const VolunteerScreen()));
        } else if (state is ProfileUpdateFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Manage Your Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.person, size: 32),
        ),
      ],
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.center,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              // backgroundImage:
            ),
            Positioned(
              // bottom: 0,
              // right: 0,
              child: GestureDetector(
                onTap: _changeProfilePicture,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt,
                      color: Theme.of(context).colorScheme.onSecondary,
                      size: 24),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Change Profile Picture',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimary,
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
        fillColor: Theme.of(context).colorScheme.onSecondary,
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
        fillColor: Theme.of(context).colorScheme.onSecondary,
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
            bool isSelected = _selectedCategories.contains(category);

            return FilterChip(
              label: Text(category),
              selected: isSelected,
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
              selectedColor: Theme.of(context).colorScheme.primary,

              checkmarkColor: Theme.of(context).colorScheme.onSecondary,

              labelStyle: TextStyle(
                color: _selectedCategories.contains(category)
                    ? Theme.of(context).colorScheme.onSecondary
                    : Theme.of(context).colorScheme.onPrimary,
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
        child: GradientButton(
          // key: _formKey,
          text: 'Confirm Changes',
          // _change_to_Home,
          onPressed: _saveProfile,
          // _selectedInterests.isEmpty? null : _change_to_Home,
        ));
  }

  // ignore: non_constant_identifier_names

  void _changeProfilePicture() async {
    // Implement image picker logic
   _profile_image = await pickImageAsBytes();
  }


  void _saveProfile() {
    if (_formKey_for_profile.currentState!.validate()) {
      List<String> addedInterests = _selectedCategories
          .where((category) => !_previousSelectedCategories.contains(category))
          .toList();

      // Calculate removed categories (previously selected but now unselected)
      List<String> removedInterests = _previousSelectedCategories
          .where((category) => !_selectedCategories.contains(category))
          .toList();

      context.read<VolunteerBloc>().add(UpdateProfilePressed(
          dto: VolProfileDto(
            img: _profile_image,
              name: _nameController.text,
              username: _usernameController.text,
              addedInterests: addedInterests,
              removedInterests: removedInterests)));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
