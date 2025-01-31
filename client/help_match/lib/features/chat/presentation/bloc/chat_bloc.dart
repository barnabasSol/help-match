import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/chat/dto/message_dto.dart';
import 'package:help_match/features/chat/dto/room_dto.dart';
import 'package:help_match/features/chat/repository/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository) : super(ChatInitial()) {
    on<ChatRoomListRequested>((event, emit) async {
      emit(ChatRoomsLoading());
      try {
        final rooms = await chatRepository.getRooms();
        emit(ChatRoomsLoaded(rooms));
      } catch (e) {
        emit(ChatRoomsLoadingFailed(e.toString()));
      }
    });
  }
}
