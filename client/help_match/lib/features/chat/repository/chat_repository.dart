import 'package:help_match/core/ws_manager/event.dart';
import 'package:help_match/core/ws_manager/ws_manager.dart';
import 'package:help_match/features/chat/dataprovider/remote/chat_remote.dart';
import 'package:help_match/features/chat/dto/message_dto.dart';
import 'package:help_match/features/chat/dto/room_dto.dart';
import 'package:help_match/features/chat/model/message_model.dart';

class ChatRepository {
  final ChatRemoteDataProvider chatRemoteDataProvider;
  final WsManager wsManager;

  ChatRepository(this.chatRemoteDataProvider, this.wsManager);

  Stream<MessageModel> get messageStream =>
      wsManager.messageStream.where((data) => data.type == TypeNewMessage).map(
            (data) => MessageModel.fromJson(
              data.payload as Map<String, dynamic>,
            ),
          );

  void sendMessage(WsEvent data) {
    wsManager.sendMessage(data);
  }

  Future<List<RoomDto>> getRooms() async {
    try {
      final response = await chatRemoteDataProvider.fetchRooms();

      final dynamic data = response['data'];

      if (data is List) {
        final List<RoomDto> roomsList =
            data.map((json) => RoomDto.fromJson(json)).toList();
        return roomsList;
      } else {
        throw Exception(
            'Invalid response format: Expected a list of rooms in the "data" field');
      }
    } catch (e) {
      throw Exception('Failed to parse rooms: $e');
    }
  }

  Future<List<MessageDto>> getMessages(String roomId) async {
    try {
      final response = await chatRemoteDataProvider.fetchMessages(roomId);

      final dynamic data = response['data'];
      if (data == null) {
        return [];
      }
      if (data is List) {
        final List<MessageDto> roomsList =
            data.map((json) => MessageDto.fromJson(json)).toList();
        return roomsList;
      } else {
        throw Exception(
          'Invalid response format: Expected a list of rooms in the "data" field',
        );
      }
    } catch (e) {
      throw Exception('Failed to parse rooms: $e');
    }
  }
}
