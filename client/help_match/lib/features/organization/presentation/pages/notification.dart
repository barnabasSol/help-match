import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/organization/bloc/org_bloc.dart';
import 'package:help_match/features/organization/dto/applicant_dto.dart';
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
    context.read<OrgBloc>().add(ApplicantsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrgBloc, OrgState>(builder: (context, state) {
      if (state is FetchFailed) {
        return Text(state.error);
      } else if (state is FetchSuccessful) {
        List<ApplicantDto> applicants = state.applicants;
        return SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.onSecondary,
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
                      child: applicants.length!=0?
                       ListView.separated(
                        itemCount: applicants.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          if (applicants[index].status == "pending") {
                            return ApplicantCard(name: applicants[index].name);
                          }
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                      ): Center(child: Text("No one has applied so far",style: Theme.of(context).textTheme.bodyLarge,)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
