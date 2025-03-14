part of 'message_bloc.dart';

@immutable
sealed class ChatState {
  final List<MessageDto> messages;
  const ChatState(this.messages);
}

final class ChatInitial extends ChatState {
  const ChatInitial(super.messages);
}

final class ChatMessagesLoading extends ChatState {
  const ChatMessagesLoading(super.messages);
}

final class ChatMessagesLoaded extends ChatState {
  const ChatMessagesLoaded(super.messages);
}

class ChatError extends ChatState {
  final String error;
  const ChatError(super.messages, this.error);
}

class MessageSendFailed extends ChatState {
  final String error;
  const MessageSendFailed(this.error, super.messages);
}

class MessageSendSuccess extends ChatState {
  final MessageDto msg;
  const MessageSendSuccess(super.messages, this.msg);
}
