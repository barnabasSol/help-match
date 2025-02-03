import 'package:help_match/core/ws_manager/event.dart';
import 'package:help_match/core/ws_manager/ws_manager.dart';
import 'package:help_match/features/online_status/model/online_status_model.dart';

class OnlineStatusRepository {
  final WsManager wsManager;

  OnlineStatusRepository(this.wsManager);

  Stream<OnlineStatusModel> get messageStream => wsManager.messageStream
      .where((WsEvent data) => data.type == TypeOnlineStatus)
      .map(
        (data) => OnlineStatusModel.fromJson(
          data.payload as Map<String, dynamic>,
        ),
      );
}
