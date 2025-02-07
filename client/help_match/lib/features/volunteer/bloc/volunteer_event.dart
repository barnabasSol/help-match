part of 'volunteer_bloc.dart';

// @immutable
sealed class VolunteerEvent {}

class SearchPressed extends VolunteerEvent {
  final SearchDto dto;

  SearchPressed({required this.dto});
}

class InitialFetch extends VolunteerEvent {}

class FiltersPressed extends VolunteerEvent {}
