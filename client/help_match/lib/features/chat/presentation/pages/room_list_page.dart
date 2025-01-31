import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/chat/presentation/bloc/chat_bloc.dart';
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
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatRoomsLoading) {
            return const LoadingIndicator();
          } else if (state is ChatRoomsLoaded) {
            final rooms = state.rooms;
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final room = rooms[index];
                      return RoomListItem(
                        roomProfile:
                            'https://pm1.narvii.com/7493/423673bdcc8ec508c9dc45009858f8469be890c5r1-915-623v2_uhq.jpg',
                        roomName: room.roomName,
                        latestText: room.latestText,
                        seen: room.isSeen,
                      );
                    },
                    childCount: rooms.length,
                  ),
                ),
              ],
            );
          } else if (state is ChatRoomsLoadingFailed) {
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
