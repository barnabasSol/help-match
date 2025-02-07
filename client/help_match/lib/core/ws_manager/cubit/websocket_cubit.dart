import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/secrets/secrets.dart';
import 'package:help_match/core/ws_manager/ws_manager.dart';

part 'websocket_state.dart';

class WebsocketCubit extends Cubit<WebsocketState> {
  WsManager wsManager;
  Dio dio;
  WebsocketCubit(this.wsManager, this.dio) : super(WebsocketInitial());

  Future<void> connectCubit() async {
    emit((WebsocketLoading()));
    try {
      final res = await dio.get('${Secrets.APP_DOMAIN}/v1/otp');
      final data = jsonDecode(res.data);

      final otp = data['otp'].toString();
      await wsManager.connect(otp);
      emit(WebsocketConnected());
    } catch (e) {
      emit(WebsocketConnectingFailed());
    }
  }
}
