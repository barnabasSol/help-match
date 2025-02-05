import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/organization/bloc/org_bloc.dart';
import 'package:help_match/features/organization/presentation/widgets/user_app_card.dart';

class OrgNotification extends StatefulWidget {
  const OrgNotification({super.key});

  @override
  State<OrgNotification> createState() => _OrgNotificationState();
}

class _OrgNotificationState extends State<OrgNotification> {

  @override
  void initState() {
    super.initState();
    context.read<OrgBloc>().add(ApplicantsFetched("20"));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(builder: (context, state) {
      if (state is FetchFailed) {
        return Text(state.error);
      } else if (state is FetchSuccessful) {
        return SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.tertiary,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 17.0, horizontal: 10),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Theme.of(context).primaryColor),
                      child: Center(
                        child: Text(
                          "Your Applicants",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Center(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          ApplicantCard(name: state.applicants[0].name),
                          //Add some separator
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
