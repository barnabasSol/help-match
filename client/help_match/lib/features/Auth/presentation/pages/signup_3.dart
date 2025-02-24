import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/features/Auth/dto/signup_dto.dart';
import 'package:help_match/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:help_match/features/Auth/presentation/bloc/auth_cubit.dart';
import 'package:help_match/shared/widgets/gradient_button.dart';

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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (BuildContext context, state) {
          if (state is AuthSignupFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is AuthSignupLoading)
            // ignore: curly_braces_in_flow_control_structures
            const Center(
              child: CircularProgressIndicator(),
            );
          else if (state is AuthSignupSuccess) {
            context.read<UserAuthCubit>().isUserAuthenticated();
            Navigator.pop(context);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Icon(Icons.volunteer_activism,
                    size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 24),

                // Title
                Text(
                  'Your Volunteer',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Please let us know your interests',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.tertiary,
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
                  child: GradientButton(
                    // key: _formKey,
                    text: 'Sign Up',
                    // _change_to_Home,
                    onPressed: () {
                      _selectedInterests.isEmpty
                          ? null
                          : _change_to_Home(context);
                    },
                  ),
                ),
              ],
            ),
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
               color: isSelected ?  Theme.of(context).colorScheme.onSecondary :  Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
           backgroundColor:  Theme.of(context).colorScheme.onSecondary,
          selectedColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
             color: isSelected ?  Theme.of(context).colorScheme.primary :  Theme.of(context).colorScheme.tertiary,
         
              width: 1,
            ),
          ),
        );
      }),
    );
  }

  void _change_to_Home(BuildContext context) {
    final list = _selectedInterests.map((index) => _categories[index]).toList();
    context.read<SignUpUserCubit>().updateInterests(list);
    UserSignUpDto dto = context.read<SignUpUserCubit>().state;
    //    print(abc);
    context.read<AuthBloc>().add(UserAuthSignupPressed(dto: dto));
  }
}
