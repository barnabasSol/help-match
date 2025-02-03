import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/current_user/repository/user_repo.dart';
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
  final UserRepo userRepo;

  ChatBloc(this.chatRepository, this.userRepo) : super(ChatInitial()) {
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
        chatRepository.messageStream.asyncMap((data) async {
          try {
            final user = await userRepo.getUserById(data.fromId);
            if (user != null) {
              return MessageDto(
                senderProfileIcon: user.profilePicUrl,
                senderId: data.fromId,
                senderName: user.name,
                senderUsername: user.username,
                isAdmin: user.role == "organization",
                roomId: data.toRoomId,
                message: data.message,
                sentTime: data.sentTime,
                isSeen: false,
              );
            } else {
              throw Exception('User not found');
            }
          } catch (e) {
            throw Exception("Failed to process message: ${e.toString()}");
          }
        }),
        onData: (messageDto) {
          _messages.add(messageDto);
          emit(NewMessageReceiveSuccess(messageDto));
          emit(ChatMessagesLoaded(_messages));
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
