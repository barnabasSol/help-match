import 'package:help_match/features/chat/dataprovider/remote/chat_remote.dart';
import 'package:help_match/features/chat/dto/room_dto.dart';

class ChatRepository {
  final ChatRemoteDataProvider chatRemoteDataProvider;

  ChatRepository(this.chatRemoteDataProvider);

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
}
