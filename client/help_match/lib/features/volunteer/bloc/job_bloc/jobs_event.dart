part of 'jobs_bloc.dart';

@immutable
sealed class JobsEvent {}

class FetchedJobs extends JobsEvent {
  final String org_id;

  FetchedJobs({required this.org_id});
}
