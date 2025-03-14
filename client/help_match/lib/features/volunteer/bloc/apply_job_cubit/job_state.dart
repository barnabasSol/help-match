part of 'job_cubit.dart';

@immutable
sealed class JobState {}

final class JobInitial extends JobState {}

final class ApplicationInProgress extends JobState {}

final class JobApplicationFailed extends JobState {
  final String error;

  JobApplicationFailed({required this.error});
}

final class JobsAppliedSuccessfully extends JobState {
  final List<String> job_ids;
  JobsAppliedSuccessfully({required this.job_ids});
}
