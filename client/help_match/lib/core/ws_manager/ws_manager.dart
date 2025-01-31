import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:help_match/core/ws_manager/event.dart';
import 'package:web_socket_channel/io.dart';

class WsManager {
  late final IOWebSocketChannel _channel;
  final FlutterSecureStorage secureStorage;
  final StreamController<WsEvent> _messageStream = StreamController.broadcast();

  WsManager(this.secureStorage);

  Stream<WsEvent> get messageStream => _messageStream.stream;

  Future<void> connect(String url, String otp) async {
    final accessToken = await secureStorage.read(key: 'access_token');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse('${url.replaceFirst('http', 'ws')}?otp=$otp'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      _channel.stream.listen(
        (data) {
          final decodedData = jsonDecode(data);
          final event = WsEvent.fromJSON(decodedData);
          _messageStream.add(event);
        },
        onError: (err) => _messageStream.addError(err),
        onDone: () => _messageStream.close(),
      );
    } catch (e) {
      print("WebSocket error: ${e.toString()}");
      rethrow;
    }
  }

  void dispose() {
    _channel.sink.close();
    _messageStream.close();
  }
}
