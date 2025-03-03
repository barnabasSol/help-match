part of 'jobs_bloc.dart';

@immutable
sealed class JobsState {}

final class JobsInitial extends JobsState {}

final class JobsLoading extends JobsState {}

final class JobsFetchFailed extends JobsState {
  final String error;

  JobsFetchFailed({required this.error});
}

final class JobsFetchedSuccessfully extends JobsState {
  final List<JobDto> jobs;

  JobsFetchedSuccessfully({required this.jobs}) ;
}
