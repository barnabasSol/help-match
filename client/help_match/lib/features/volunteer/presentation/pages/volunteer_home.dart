import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/core/secrets/secrets.dart';
import 'package:help_match/features/online_status/cubit/online_status_cubit.dart';
import 'package:help_match/features/volunteer/presentation/widgets/vonteer_appbar.dart';
import 'package:help_match/shared/widgets/snack_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserAuthCubit>().currentUser;
    return BlocListener<OnlineStatusCubit, OnlineStatusState>(
      listener: (context, state) {
        if (state is OnlineStatusChange) {
          showCustomSnackBar(
            context: context,
            message:
                '${state.osm.userName} online status is ${state.osm.status}',
            color: Colors.green,
          );
        }
      },
      child: CustomScrollView(
        slivers: [
          VolunteerAppbar(profileIcon: "", username: currentUser!.username),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(Secrets.DummyImage),
                    title: Text('Home Item ${index + 1}'),
                  ),
                );
              },
              childCount: 20, // Number of items in the list
            ),
          ),
        ],
      ),
    );
  }
}
