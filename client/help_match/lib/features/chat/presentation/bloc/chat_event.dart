part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class ChatRoomListRequested extends ChatEvent {}

final class ChatMessagesRequested extends ChatEvent {}

final class ChatMessageSendRequested extends ChatEvent {
  final String message;
  ChatMessageSendRequested(this.message);
}

class SendMessageEvent extends ChatEvent {
  final MessageDto message;
  SendMessageEvent(this.message);
}

class NewMessageReceived extends ChatEvent {
  final MessageDto message;
  NewMessageReceived(this.message);
}
