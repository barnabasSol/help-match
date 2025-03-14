import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:help_match/core/secrets/secrets.dart';
import 'package:help_match/core/ws_manager/event.dart';
import 'package:web_socket_channel/io.dart';

class WsManager {
  late final IOWebSocketChannel _channel;
  final StreamController<WsEvent> _messageStream = StreamController.broadcast();
  final FlutterSecureStorage secureStorage;

  WsManager(this.secureStorage);

  Stream<WsEvent> get messageStream => _messageStream.stream;

  void sendMessage(WsEvent data) {
    if (_channel.closeCode == null) {
      _channel.sink.add(jsonEncode(data.toJSON()));
    } else {
      throw const WebSocketException('failed sending message');
    }
  }

  Future<void> connect(String otp, {int retries = 3, int delay = 1000}) async {
    final accessToken = await secureStorage.read(key: 'access_token');
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    var domain = Secrets.APP_DOMAIN.replaceFirst('https', 'wss');
    final wsUrl = '$domain/v1/ws?otp=$otp';

    for (int i = 0; i < retries; i++) {
      try {
        _channel = IOWebSocketChannel.connect(
          Uri.parse(wsUrl),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        _channel.stream.listen(
          (data) {
            final decodedData = jsonDecode(data);
            final event = WsEvent.fromJSON(decodedData);
            _messageStream.add(event);
          },
          onError: (err) {
            _messageStream.addError(err);
          },
          onDone: () {
            _messageStream.close();
          },
        );

        break;
      } catch (e) {
        if (i == retries - 1) {
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: delay));
      }
    }
  }

  void dispose() {
    if (_channel.closeCode != null) {
      _channel.sink.close();
    }
    if (!_messageStream.isClosed) {
      _messageStream.close();
    }
  }
}
