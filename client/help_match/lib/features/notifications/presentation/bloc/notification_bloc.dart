import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/notifications/dto/org_notif_dto.dart';
import 'package:help_match/features/notifications/dto/volunteer_notif_dto.dart';
import 'package:help_match/features/notifications/repository/notif_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notifRepo;
  NotificationBloc(this.notifRepo) : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) async {});
    on<NotificationListRequested>((event, emit) async {
      emit(NotificationFetchLoading());
      try {
        if (event.role == "organization") {
          final notifs = await notifRepo.getOrgNotifications();
          emit(OrgNotificationFetchLoaded(notifs));
          return;
        } else if (event.role == "user") {
          final notifs = await notifRepo.getVolunteerNotifications();
          emit(VolunteerNotificationFetchLoaded(notifs));
          return;
        }
        emit(NotificationFetchError("invalid role"));
      } catch (e) {
        emit(NotificationFetchError(e.toString()));
      }
    });
  }
}

// class ChatBloc extends Bloc<ChatEvent, ChatState> {
//   final ChatRepository chatRepository;

//   ChatBloc(this.chatRepository) : super(ChatInitial()) {
//     on<ChatRoomListRequested>((event, emit) async {
//       emit(ChatRoomsLoading());
//       try {
//         final rooms = await chatRepository.getRooms();
//         emit(ChatRoomsLoaded(rooms));
//       } catch (e) {
//         emit(ChatRoomsLoadingFailed(e.toString()));
//       }
//     });
//   }
// }
