import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/core/online_status/cubit/online_status_cubit.dart';
import 'package:help_match/core/ws_manager/cubit/websocket_cubit.dart';
import 'package:help_match/features/chat/dto/message_dto.dart';
import 'package:help_match/features/chat/dto/room_dto.dart';
import 'package:help_match/features/chat/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:help_match/features/chat/presentation/bloc/rooms_bloc/rooms_bloc.dart';
import 'package:help_match/features/chat/presentation/widgets/chat_appbar.dart';
import 'package:help_match/features/chat/presentation/widgets/chat_info_card.dart';
import 'package:help_match/features/chat/presentation/widgets/input_field.dart';
import 'package:help_match/features/chat/presentation/widgets/message_card.dart';
import 'package:help_match/shared/widgets/loading_indicator.dart';
import 'package:help_match/shared/widgets/snack_bar.dart';
import 'package:intl/intl.dart';

class RoomMessagesPage extends StatefulWidget {
  final String roomId;
  final String groupName;
  final String profileIcon;
  const RoomMessagesPage(
      {super.key,
      required this.roomId,
      required this.groupName,
      required this.profileIcon});

  @override
  State<RoomMessagesPage> createState() => _RoomMessagesState();
}

class _RoomMessagesState extends State<RoomMessagesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(ChatMessagesRequested(widget.roomId));
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserAuthCubit>().currentUser;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(),
      appBar: ChatAppBar(
        profileIcon: widget.profileIcon,
        groupName: widget.groupName,
        scaffoldKey: _scaffoldKey,
        onSearchPressed: () {},
      ),
      body: Column(
        children: [
          Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is ChatError) {
                if (state.error.startsWith('WebSocketInactive')) {}
                showCustomSnackBar(
                    context: context, message: state.error, color: Colors.red);
              } else if (state is MessageSendSuccess) {
                context.read<RoomsBloc>().add(
                      RoomsUpdated(
                        RoomDto(
                          roomProfile: widget.profileIcon,
                          roomId: widget.roomId,
                          isAdmin: state.msg.isAdmin,
                          roomName: null,
                          latestText: state.msg.message,
                          sentTime: state.msg.sentTime,
                        ),
                      ),
                    );
              }
            },
            builder: (context, state) {
              if (state is ChatMessagesLoading) {
                return const LoadingIndicator();
              }
              if (state.messages.isEmpty) {
                return const Center(
                  child: ChatInfoCard('📭 No Messages Yet'),
                );
              }
              return GroupedListView<MessageDto, DateTime>(
                reverse: true,
                order: GroupedListOrder.DESC,
                elements: state.messages,
                groupBy: (msg) => DateTime(
                  msg.sentTime.year,
                  msg.sentTime.month,
                  msg.sentTime.day,
                ),
                groupHeaderBuilder: (msg) => SizedBox(
                  height: 40,
                  child: Center(
                    child: Card(
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat.yMMMd().format(msg.sentTime),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                itemBuilder: (context, msg) => MessageCard(
                  msg: msg,
                  isSentByme: currentUser.sub == msg.senderId,
                ),
              );
            },
          )),
          const SizedBox(height: 10),
          ChatInput(roomId: widget.roomId),
        ],
      ),
    );
  }
}
