import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/current_user/model/user_cache_model.dart';
import 'package:help_match/core/current_user/repository/user_repo.dart';
import 'package:help_match/features/volunteer/dto/vol_profile_dto.dart';
import 'package:help_match/features/volunteer/repository/volunteer_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepo userRepo;
  final VolunteerRepository volRepo;
  ProfileBloc({required this.userRepo, required this.volRepo})
      : super(ProfileInitial()) {
    on<ProfileInfoFetched>(_readUser);
    on<UpdateProfilePressed>(_updateProfile);
  }

  void _readUser(ProfileInfoFetched event, Emitter<ProfileState> emit) async {
    try {
      final user = await userRepo.getUserById(event.userId);
      emit(ProfileInfoFetchSuccess(user: user!));
    } catch (e) {
      emit(ProfileInfoFetchFailure(error: e.toString()));
    }
  }

   

  FutureOr<void> _updateProfile(
      UpdateProfilePressed event, Emitter<ProfileState> emit) async {
    try {
      await volRepo.updateUserData(event.dto);
      emit(ProfileUpdateSuccess());
    } catch (e) {
      emit(ProfileUpdateFailure(error: e.toString()));
    }
  }
}
