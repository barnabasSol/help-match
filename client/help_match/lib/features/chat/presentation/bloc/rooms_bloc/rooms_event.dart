part of 'rooms_bloc.dart';

@immutable
sealed class RoomsEvent {}

final class RoomListRequested extends RoomsEvent {}

class RoomsUpdated extends RoomsEvent {
  final RoomDto room;
  RoomsUpdated(this.room);
}
