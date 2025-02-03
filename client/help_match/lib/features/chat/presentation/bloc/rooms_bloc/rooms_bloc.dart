import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/chat/dto/room_dto.dart';
import 'package:help_match/features/chat/repository/chat_repository.dart';

part 'rooms_event.dart';
part 'rooms_state.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  final ChatRepository chatRepository;
  List<RoomDto> _rooms = [];

  RoomsBloc(this.chatRepository) : super(RoomsInitial()) {
    // on<RoomsEvent>((event, emit) {});

    on<RoomsUpdated>((event, emit) {
      _rooms = _rooms.map((room) {
        if (room.roomId == event.room.roomId) {
          return room.copyWith(
            latestText: event.room.latestText,
            sentTime: event.room.sentTime,
            isSeen: event.room.isSeen,
          );
        }
        return room;
      }).toList();
      emit(RoomsLoaded(_rooms));
    });

    on<RoomListRequested>((event, emit) async {
      emit(RoomsLoading());
      try {
        final rooms = await chatRepository.getRooms();
        _rooms = rooms;
        emit(RoomsLoaded(_rooms));
      } catch (e) {
        emit(RoomsLoadingFailed(e.toString()));
      }
    });
  }
}
