import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/current_user/model/user_cache_model.dart';
import 'package:help_match/core/current_user/repository/user_repo.dart';
import 'package:help_match/features/volunteer/dto/org_card_dto.dart';
import 'package:help_match/features/volunteer/dto/search_dto.dart';
import 'package:help_match/features/volunteer/dto/vol_profile_dto.dart';
import 'package:help_match/features/volunteer/repository/volunteer_repository.dart';

part 'volunteer_event.dart';
part 'volunteer_state.dart';

class VolunteerBloc extends Bloc<VolunteerEvent, VolunteerState> {
  final UserRepo userRepo;
  final VolunteerRepository volRepo;
  VolunteerBloc(this.userRepo, {required this.volRepo})
      : super(VolunteerInitial()) {
    on<InitialFetch>((event, emit) async {
      try {
        emit(OrgsLoading());
        final List<OrgCardDto> orgs =
            await volRepo.getOrgs(SearchDto(org_name: "", org_type: ""));
        emit(OrgsFetchedSuccessfully(organizations: orgs));
      } catch (e) {
        emit(OrgsFetchedFailed(error: e.toString()));
      }
    });
    on<SearchPressed>(_searchOrgs);
    on<ProfileInfoFetched>(_readUser);
    on<UpdateProfilePressed>(_updateProfile);
  }

  void _readUser(ProfileInfoFetched event, Emitter<VolunteerState> emit) async {
    try {
      final user = await userRepo.getUserById(event.userId);
      emit(ProfileInfoFetchSuccess(user: user!));
    } catch (e) {
      emit(ProfileInfoFetchFailure(error: e.toString()));
    }
  }

  void _searchOrgs(event, emit) async {
    try {
      emit(OrgsLoading());
      final List<OrgCardDto> orgs = await volRepo.getOrgs(event.dto);
      emit(OrgsFetchedSuccessfully(organizations: orgs));
    } catch (e) {
      emit(OrgsFetchedFailed(error: e.toString()));
    }
  }

  FutureOr<void> _updateProfile(
      UpdateProfilePressed event, Emitter<VolunteerState> emit) async {
    try {
      await volRepo.updateUserData(event.dto);
      emit(ProfileUpdateSuccess());
    } catch (e) {
      emit(ProfileUpdateFailure(error: e.toString()));
    }
  }
}
