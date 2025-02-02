part of 'rooms_bloc.dart';

@immutable
sealed class RoomsState {}

final class RoomsInitial extends RoomsState {}

final class RoomsLoading extends RoomsState {}

final class RoomsLoaded extends RoomsState {
  final List<RoomDto> rooms;
  RoomsLoaded(this.rooms);
}

final class RoomsLoadingFailed extends RoomsState {
  final String error;
  RoomsLoadingFailed(this.error);
}

class RoomsUpdateSuccess extends RoomsState {
  final List<RoomDto> rooms;
  RoomsUpdateSuccess(this.rooms);
}
