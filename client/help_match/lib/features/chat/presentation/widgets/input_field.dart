import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/features/chat/model/message_model.dart';
import 'package:help_match/features/chat/presentation/bloc/message_bloc/message_bloc.dart';

class ChatInput extends StatelessWidget {
  final String roomId;
  const ChatInput({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final inputController = TextEditingController();
    final currentUser = context.read<UserAuthCubit>().currentUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: inputController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
                style: const TextStyle(color: Colors.black87),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () {
                context.read<ChatBloc>().add(NewMessageSent(MessageModel(
                      message: inputController.text,
                      fromId: currentUser.sub,
                      toRoomId: roomId,
                      sentTime: DateTime.now(),
                    )));
              },
            ),
          ),
        ],
      ),
    );
  }
}
