part of 'org_bloc.dart';

@immutable
sealed class OrgState {}

final class OrgInitial extends OrgState {}

final class OrgLoading extends OrgState {}

final class OrgFetchFailed extends OrgState {
  final String error;

  OrgFetchFailed({required this.error});
}

final class OrgFetchedSuccessfully extends OrgState {
  final OrgDto org;

  OrgFetchedSuccessfully({required this.org});
}
