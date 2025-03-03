// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'volunteer_bloc.dart';

@immutable
sealed class VolunteerEvent {}

class SearchPressed extends VolunteerEvent {
  final SearchDto dto;

  SearchPressed({required this.dto});
}

class InitialFetch extends VolunteerEvent {}
class FetchMore extends VolunteerEvent {
  final SearchDto dto;

  FetchMore({required this.dto});
}


