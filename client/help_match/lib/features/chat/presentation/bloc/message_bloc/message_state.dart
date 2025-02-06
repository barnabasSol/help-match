part of 'message_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatMessagesLoading extends ChatState {}

final class ChatMessagesLoaded extends ChatState {
  final List<MessageDto> messages;
  ChatMessagesLoaded(this.messages);
}

final class ChatMessagesLoadingFailed extends ChatState {
  final String error;
  ChatMessagesLoadingFailed(this.error);
}

class NewMessageReceiveFailed extends ChatState {
  final String error;
  NewMessageReceiveFailed(this.error);
}

class NewMessageReceiveSuccess extends ChatState {
  final MessageDto message;
  NewMessageReceiveSuccess(this.message);
}
