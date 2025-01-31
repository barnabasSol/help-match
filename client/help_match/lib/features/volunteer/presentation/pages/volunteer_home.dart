import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/features/volunteer/presentation/widgets/vonteer_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserAuthCubit>().currentUser;
    return CustomScrollView(
      slivers: [
        VolunteerAppbar(profileIcon: "", username: currentUser!.username),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(
                      'https://pm1.narvii.com/7493/423673bdcc8ec508c9dc45009858f8469be890c5r1-915-623v2_uhq.jpg'),
                  title: Text('Home Item ${index + 1}'),
                ),
              );
            },
            childCount: 20, // Number of items in the list
          ),
        ),
      ],
    );
  }
}
