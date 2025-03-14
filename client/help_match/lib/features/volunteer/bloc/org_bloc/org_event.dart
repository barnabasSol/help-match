part of 'org_bloc.dart';

@immutable
sealed class OrgEvent {}

class FetchedOrg extends OrgEvent {
  final String org_id;

  FetchedOrg({required this.org_id});
}
