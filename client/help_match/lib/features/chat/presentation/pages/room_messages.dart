import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/features/chat/dto/room_dto.dart';
import 'package:help_match/features/chat/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:help_match/features/chat/presentation/bloc/rooms_bloc/rooms_bloc.dart';
import 'package:help_match/features/chat/presentation/widgets/input_field.dart';
import 'package:help_match/features/online_status/cubit/online_status_cubit.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserAuthCubit>().currentUser;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(),
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ChatInput(roomId: widget.roomId),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 200.0,
            floating: true,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.groupName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              background: Image.network(
                widget.profileIcon,
                fit: BoxFit.cover,
              ),
              centerTitle: true,
            ),
          ),
          BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is NewMessageReceiveSuccess) {
                if (state.message.senderId != currentUser!.sub) {
                  showCustomSnackBar(
                    context: context,
                    message: state.message.message,
                    color: Colors.green,
                  );
                }
                print("LISTENINGNNGNGNGNG");
                print("LISTENINGNNGNGNGNG");
                print("LISTENINGNNGNGNGNG");
                print("LISTENINGNNGNGNGNG");
                context.read<RoomsBloc>().add(
                      RoomsUpdated(
                        RoomDto(
                          roomProfile: null,
                          roomId: state.message.roomId,
                          isAdmin: state.message.isAdmin,
                          roomName: null,
                          latestText: state.message.message,
                          sentTime: state.message.sentTime,
                          isSeen: false,
                        ),
                      ),
                    );
              }
            },
            builder: (context, state) {
              if (state is ChatMessagesLoading) {
                return const SliverToBoxAdapter(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ChatMessagesLoadingFailed) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text('Failed loading messages'),
                  ),
                );
              } else if (state is ChatMessagesLoaded) {
                if (state.messages.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('No messages'),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final message = state.messages[index];
                      return ListTile(
                        trailing: Text(
                          DateFormat('HH:mm').format(message.sentTime),
                        ),
                        title: Text(message.senderName),
                        subtitle: Text(message.message),
                        leading:
                            BlocBuilder<OnlineStatusCubit, OnlineStatusState>(
                          builder: (context, state) {
                            if (state is OnlineStatusChange) {
                              if (state.osm.userId == message.senderId) {
                                return Badge(
                                  smallSize: 14,
                                  backgroundColor: state.osm.status
                                      ? Colors.green
                                      : Colors.transparent,
                                  child: CircleAvatar(
                                    child: Text(message.senderProfileIcon == ""
                                        ? message.senderName[0]
                                        : message.senderProfileIcon),
                                  ),
                                );
                              }
                              return Badge(
                                smallSize: 14,
                                backgroundColor: Colors.transparent,
                                child: CircleAvatar(
                                  child: Text(message.senderProfileIcon == ""
                                      ? message.senderName[0]
                                      : message.senderProfileIcon),
                                ),
                              );
                            }
                            return Badge(
                              smallSize: 14,
                              backgroundColor: Colors.transparent,
                              child: CircleAvatar(
                                child: Text(message.senderProfileIcon == ""
                                    ? message.senderName[0]
                                    : message.senderProfileIcon),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    childCount: state.messages.length,
                  ),
                );
              } else if (state is NewMessageReceiveFailed) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Dealing with technical problem, try again later',
                    ),
                  ),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Text('wtf'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
