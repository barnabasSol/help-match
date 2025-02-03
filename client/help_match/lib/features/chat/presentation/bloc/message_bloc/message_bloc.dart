import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/secrets/secrets.dart';
import 'package:help_match/core/ws_manager/event.dart';
import 'package:help_match/features/chat/dto/message_dto.dart';
import 'package:help_match/features/chat/model/message_model.dart';
import 'package:help_match/features/chat/repository/chat_repository.dart';

part 'message_event.dart';
part 'message_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  StreamSubscription? newMessageSub;
  List<MessageDto> _messages = [];
  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository) : super(ChatInitial()) {
    on<ChatMessagesRequested>((event, emit) async {
      emit(ChatMessagesLoading());
      try {
        final messages = await chatRepository.getMessages(event.roomId);
        _messages = messages;
        emit(ChatMessagesLoaded(_messages));
      } catch (e) {
        emit(ChatMessagesLoadingFailed(e.toString()));
      }
    });

    on<NewMessageListening>((event, emit) async {
      await emit.forEach(
        chatRepository.messageStream,
        onData: (data) {
          emit(NewMessageReceived(data));
          return state;
        },
        onError: (error, stackTrace) {
          emit(NewMessageReceiveFailed(
              "Failed to listen for new messages: $error"));
          return state;
        },
      );
    });

    on<NewMessageSent>((event, emit) async {
      try {
        chatRepository.sendMessage(
            WsEvent(type: TypeSendMessage, payload: event.message));
        // emit(NewMessageReceived(event.message));
      } catch (e) {
        emit(NewMessageReceiveFailed(e.toString()));
      }
    });

    on<UpdateMessages>((event, emit) async {
      try {
        _messages = [
          ..._messages,
          MessageDto(
            senderProfileIcon: Secrets.DummyImage,
            senderId: event.message.fromId,
            senderName: 'senderName',
            senderUsername: '',
            isAdmin: true,
            roomId: event.message.toRoomId,
            message: event.message.message,
            sentTime: event.message.sentTime,
            isSeen: false,
          )
        ];
        emit(MessageUpdate(_messages));
      } catch (e) {
        emit(NewMessageReceiveFailed(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    newMessageSub?.cancel();
    return super.close();
  }
}
