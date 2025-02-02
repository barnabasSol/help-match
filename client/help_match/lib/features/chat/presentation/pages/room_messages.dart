import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/core/secrets/secrets.dart';
import 'package:help_match/features/chat/dto/room_dto.dart';
import 'package:help_match/features/chat/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:help_match/features/chat/presentation/bloc/rooms_bloc/rooms_bloc.dart';
import 'package:help_match/features/chat/presentation/widgets/input_field.dart';
import 'package:help_match/shared/widgets/loading_indicator.dart';
import 'package:help_match/shared/widgets/snack_bar.dart';

class RoomMessagesPage extends StatefulWidget {
  final String roomId;
  final String groupName;
  final String profileIcon;

  const RoomMessagesPage({
    super.key,
    required this.groupName,
    required this.profileIcon,
    required this.roomId,
  });

  @override
  State<RoomMessagesPage> createState() => _RoomMessagesPageState();
}

class _RoomMessagesPageState extends State<RoomMessagesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(ChatMessagesRequested(widget.roomId));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserAuthCubit>().currentUser;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
            pinned: true,
            snap: true,
            backgroundColor: theme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.only(bottom: 0, left: 0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  widget.groupName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              centerTitle: false,
              background: Stack(
                children: [
                  // Background Image
                  Image.network(
                    widget.profileIcon.isEmpty
                        ? Secrets.DummyImage
                        : widget.profileIcon,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is NewMessageReceived) {
                context.read<RoomsBloc>().add(
                      RoomsUpdated(
                        RoomDto(
                          roomProfile: null,
                          roomId: state.message.toRoomId,
                          isAdmin: null,
                          roomName: null,
                          latestText: state.message.message,
                          sentTime: state.message.sentTime,
                          isSeen: false,
                        ),
                      ),
                    );
                if (currentUser?.sub != state.message.fromId) {
                  showCustomSnackBar(
                    context: context,
                    message: state.message.message,
                    color: Colors.green,
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is ChatMessagesLoading) {
                return const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                    child: LoadingIndicator(),
                  ),
                );
              } else if (state is ChatMessagesLoaded) {
                final messages = state.messages;
                if (messages.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('There are no messages'),
                    ),
                  );
                } else {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final message = messages[index];
                        return ListTile(
                          title: Text(message.senderName),
                          subtitle: Text(message.message),
                        );
                      },
                      childCount: messages.length,
                    ),
                  );
                }
              } else if (state is ChatMessagesLoadingFailed) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(state.error),
                  ),
                );
              } else if (state is NewMessageReceived) {
                context.read<ChatBloc>().add(UpdateMessages(state.message));
              } else if (state is MessageUpdate) {
                final messages = state.messages;
                if (messages.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('There are no messages'),
                    ),
                  );
                } else {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final message = messages[index];
                        return ListTile(
                          title: Text(message.senderName),
                          subtitle: Text(message.message),
                        );
                      },
                      childCount: messages.length,
                    ),
                  );
                }
              }
              {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text('Something unexpected'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ChatInput(
          roomId: widget.roomId,
        ),
      ),
    );
  }
}
