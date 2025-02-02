import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/secrets/secrets.dart';
import 'package:help_match/features/chat/presentation/bloc/rooms_bloc/rooms_bloc.dart';
import 'package:help_match/features/chat/presentation/widgets/room_item.dart';
import 'package:help_match/shared/widgets/loading_indicator.dart';

class RoomListPage extends StatelessWidget {
  const RoomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
      ),
      body: BlocBuilder<RoomsBloc, RoomsState>(
        builder: (context, state) {
          if (state is RoomsLoading) {
            return const LoadingIndicator();
          } else if (state is RoomsLoaded || state is RoomsUpdateSuccess) {
            final rooms = state is RoomsLoaded
                ? state.rooms
                : (state as RoomsUpdateSuccess).rooms;
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final room = rooms[index];
                      return RoomListItem(
                        roomId: room.roomId!,
                        roomProfile: Secrets.DummyImage,
                        roomName: room.roomName!,
                        latestText: room.latestText!,
                        seen: room.isSeen,
                      );
                    },
                    childCount: rooms.length,
                  ),
                ),
              ],
            );
          } else if (state is RoomsLoadingFailed) {
            return Center(
              child: Text('Failed to load rooms: ${state.error}'),
            );
          } else {
            return const Center(
              child: Text('No rooms available'),
            );
          }
        },
      ),
    );
  }
}
