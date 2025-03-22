import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/volunteer/bloc/apply_job_cubit/job_cubit.dart';
import 'package:help_match/features/volunteer/dto/job_view_dto.dart';

class JobCard extends StatefulWidget {
  final JobViewDto jobViewDto;
  const JobCard({super.key, required this.jobViewDto});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> { 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Description"),
            content: Text(widget.jobViewDto.description),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
        );
      },
      child: Container(
        height: 170,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.onTertiaryContainer),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      height: 40,
                      width: 48,
                      child: Image.network(
                        "https://imgs.search.brave.com/XUJeiz6wORWCNK-xAu78igkfR7GRKMfE0AvshQ8yOrQ/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9ibG9n/LmdyZWF0bm9ucHJv/Zml0cy5vcmcvd3At/Y29udGVudC91cGxv/YWRzLzIwMjIvMTEv/Z2l2ZS13aXRoLWhl/YXJ0LnBuZw",
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "Mekedonia Charity",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                )
              ],
            ),
            Text(widget.jobViewDto.title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
            const Row(
              children: [
                Icon(Icons.work_history_outlined),
                SizedBox(
                  width: 8,
                ),
                Text("Part Time"),
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.watch_later_outlined),
                SizedBox(
                  width: 8,
                ),
                Text("10 min ago")
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocConsumer<JobCubit, JobState>(builder: ((context, state) {
                  bool isApplied = false;
                  if (state is JobsAppliedSuccessfully) {
                    isApplied = state.job_ids.contains(widget.jobViewDto.id);
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    onPressed: isApplied||widget.jobViewDto.applicant_status=="pending"
                        ? null
                        : () {
                            context
                                .read<JobCubit>()
                                .applyJob(widget.jobViewDto.id);
                          },
                    child: Text(
                      isApplied||widget.jobViewDto.applicant_status=="pending" ? "Applied" : "Apply Now",
                      style:    isApplied||widget.jobViewDto.applicant_status=="pending" 
                          ? Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary ,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)
                          : Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                    ),
                  );
                }), listener: ((context, state) {
                  if (state is JobApplicationFailed) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.error)));
                  }
                }))
              ],
            )
          ],
        ),
      ),
    );
  }
}
