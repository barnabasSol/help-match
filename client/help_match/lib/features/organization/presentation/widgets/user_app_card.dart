import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/organization/cubit/org_applicant_state.dart';
import 'package:help_match/features/organization/cubit/org_cubit.dart';
import 'package:help_match/features/organization/dto/update_status_dto.dart';

class ApplicantCard extends StatelessWidget {
  final String name;
  final String jobId;
  final String userId;
  const ApplicantCard(
      {super.key,
      required this.userId,
      required this.name,
      required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 25,
              ),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    // const SizedBox(height: 2),
                    BlocConsumer<OrgCubit, ApplicantState>(
                      builder: (context, state) {
                        if (state is UpdateStatusSuccessful) {
                          return SizedBox(
                            width: 150,
                            height: 24,
                            child: ElevatedButton(
                              onPressed: null,
                              child: Text(
                                state.status,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        } else {
                          return Row(
                            children: [
                              SizedBox(
                                width: 91,
                                height: 21,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<OrgCubit>().applicantAccepted(
                                        UpdateStatusDto(
                                            jobId: jobId,
                                            userId: userId,
                                            status: "accepted"));
                                  },
                                  child: Text(
                                    "Accept",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              SizedBox(
                                width: 88,
                                height:
                                    21, // Fixed button height for consistency
                                child: ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<OrgCubit>()
                                          .applicantRejected(UpdateStatusDto(
                                              jobId: jobId,
                                              userId: userId,
                                              status: "rejected"));
                                    },
                                    child: Text(
                                      "Reject",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                    )),
                              )
                            ],
                          );
                        }
                      },
                      listener: (BuildContext context, ApplicantState state) {
                        if (state is UpdateStatusFailed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error)));
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
