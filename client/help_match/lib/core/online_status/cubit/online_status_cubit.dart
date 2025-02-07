import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/online_status/model/online_status_model.dart';
import 'package:help_match/core/online_status/repository/online_status_repository.dart';

part 'online_status_state.dart';

class OnlineStatusCubit extends Cubit<OnlineStatusState> {
  OnlineStatusRepository onlineStatusRepo;
  StreamSubscription? statusSub;
  OnlineStatusCubit(this.onlineStatusRepo) : super(OnlineStatusInitial());

  void listenOnlineStatusChange() {
    _listenForMessages();
  }

  void _listenForMessages() {
    statusSub = onlineStatusRepo.messageStream.listen(
      (user) {
        emit(OnlineStatusChange(user));
      },
      onError: (error) {
        emit(OnlineStatusError(
            "Failed to listen for online status changes: $error"));
      },
    );
  }

  @override
  Future<void> close() {
    statusSub?.cancel();
    return super.close();
  }
}
