import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';

class DrawerHeader_ extends StatelessWidget {
  const DrawerHeader_({super.key});

  @override
  Widget build(BuildContext context) {
    String user = context.read<UserAuthCubit>().currentUser.username;
    return UserAccountsDrawerHeader(
      accountEmail: const Text(""),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      accountName:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(user.toUpperCase()),
      ),
      currentAccountPicture: Icon(
        Icons.face,
        size: 48.0,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      otherAccountsPictures: [ 
        IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () => signOut(context),
          tooltip: "Logout",
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }

  void signOut(BuildContext context) async {
    await context.read<UserAuthCubit>().kickOut();
  }
}
