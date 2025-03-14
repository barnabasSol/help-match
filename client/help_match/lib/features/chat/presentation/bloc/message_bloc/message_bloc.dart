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
  final ChatRepository chatRepository;
  final UserRepo userRepo;

  ChatBloc(this.chatRepository, this.userRepo) : super(const ChatInitial([])) {
    on<ChatMessagesRequested>((event, emit) async {
      emit(ChatMessagesLoading(state.messages));
      try {
        final messages = await chatRepository.getMessages(event.roomId);
        final sorted = [...messages]
          ..sort((a, b) => b.sentTime.compareTo(a.sentTime));

        emit(ChatMessagesLoaded(sorted));
      } catch (e) {
        emit(ChatError(state.messages, e.toString()));
      }
    });

    on<NewMessageListening>(_listenToNewMessages);

    on<NewMessageSent>((event, emit) {
      try {
        chatRepository.sendMessage(
          WsEvent(
            type: TypeSendMessage,
            payload: event.message,
          ),
        );
      } catch (e) {
        emit(ChatError(state.messages,
            "WebSocketInactive probably not active ${e.toString()}"));
      }
    });
  }

  FutureOr<void> _listenToNewMessages(event, emit) async {
    await emit.forEach<MessageDto>(
      chatRepository.messageStream.asyncMap<MessageDto>((data) async {
        try {
          final user = await userRepo.getUserById(data.fromId);
          if (user != null) {
            if (user.role == "organization") {
              return MessageDto(
                senderProfileIcon: user.orgInfo!.profileIcon,
                senderId: data.fromId,
                senderName: user.orgInfo!.name,
                senderUsername: user.username,
                isAdmin: user.role == "organization",
                roomId: data.toRoomId,
                message: data.message,
                sentTime: data.sentTime,
                isSeen: false,
              );
            }
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
      onData: (MessageDto messageDto) {
        final updatedMessages = [...state.messages, messageDto];
        emit(MessageSendSuccess(updatedMessages, messageDto));
        return state;
      },
      onError: (e, stackTrace) {
        emit(MessageSendFailed(
            "Failed to listen for new messages: $e", state.messages));
        return state;
      },
    );
  }

  @override
  Future<void> close() {
    newMessageSub?.cancel();
    return super.close();
  }
}
