part of 'message_bloc.dart';

@immutable
sealed class ChatEvent {}

final class ChatMessagesRequested extends ChatEvent {
  final String roomId;
  ChatMessagesRequested(this.roomId);
}

final class ChatMessageSendRequested extends ChatEvent {
  final String message;
  ChatMessageSendRequested(this.message);
}

class NewMessageSent extends ChatEvent {
  final MessageModel message;
  NewMessageSent(this.message);
}

class UpdateMessages extends ChatEvent {
  final MessageModel message;
  UpdateMessages(this.message);
}

class NewMessageListening extends ChatEvent {}
