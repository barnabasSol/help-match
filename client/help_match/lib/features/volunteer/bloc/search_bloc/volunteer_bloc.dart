import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/volunteer/dto/org_card_dto.dart';
import 'package:help_match/features/volunteer/dto/search_dto.dart';
import 'package:help_match/features/volunteer/repository/volunteer_repository.dart';

part 'volunteer_event.dart';
part 'volunteer_state.dart';

class VolunteerBloc extends Bloc<VolunteerEvent, VolunteerState> {
  final VolunteerRepository volRepo;
  VolunteerBloc({required this.volRepo})
      : super(VolunteerInitial()) {
    on<InitialFetch>(_fetchRecommendations);
    on<SearchPressed>(_searchOrgs);
  }

  Future<void> _fetchRecommendations(event, emit) async {
    try {
      emit(OrgsLoading());
      final List<OrgCardDto> orgs =
          await volRepo.getOrgs(SearchDto(org_name: "", org_type: ""));
      emit(OrgsFetchedSuccessfully(organizations: orgs));
    } catch (e) {
      emit(OrgsFetchedFailed(error: e.toString()));
    }
  }

  Future<void> _searchOrgs(event, emit) async {
    try {
      emit(OrgsLoading());
      final List<OrgCardDto> orgs = await volRepo.getOrgs(event.dto);
      emit(OrgsFetchedSuccessfully(organizations: orgs));
    } catch (e) {
      emit(OrgsFetchedFailed(error: e.toString()));
    }
  }
}
