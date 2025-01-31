part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatRoomsLoading extends ChatState {}

final class ChatRoomsLoaded extends ChatState {
  final List<RoomDto> rooms;
  ChatRoomsLoaded(this.rooms);
}

final class ChatRoomsLoadingFailed extends ChatState {
  final String error;
  ChatRoomsLoadingFailed(this.error);
}

final class ChatRoomsError extends ChatState {
  final String message;
  ChatRoomsError(this.message);
}

final class ChatMessagesLoading extends ChatState {}

final class ChatMessagesLoaded extends ChatState {
  final List<MessageDto> messages;
  ChatMessagesLoaded(this.messages);
}

final class ChatMessagesLoadingFailed extends ChatState {}
