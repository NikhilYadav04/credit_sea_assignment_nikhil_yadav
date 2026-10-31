import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../app/constants/api_endpoints.dart';
import '../../app/routes/app_routes.dart';
import '../network/api_client.dart';
import '../storage/token_storage.dart';

class PushService {
  PushService(this._api, this._tokens);

  static const _channel = AndroidNotificationChannel(
    'loan_updates',
    'Loan updates',
    description: 'Status changes for your loan applications',
    importance: Importance.high,
  );

  final ApiClient _api;
  final TokenStorage _tokens;
  final _local = FlutterLocalNotificationsPlugin();

  bool _ready = false;
  String? _deviceToken;

  Future<void> init() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Push disabled, Firebase is not configured: $e');
      return;
    }
    _ready = true;

    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) => _openApplication(response.payload),
    );
    await _local
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    FirebaseMessaging.onMessage.listen(_showInForeground);
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _openApplication(m.data['applicationId']));
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      _deviceToken = token;
      _sendToken(token);
    });

    final launchedBy = await FirebaseMessaging.instance.getInitialMessage();
    if (launchedBy != null) _openApplication(launchedBy.data['applicationId']);
  }

  Future<void> registerDevice() async {
    if (!_ready) return;
    try {
      await FirebaseMessaging.instance.requestPermission();
      _deviceToken = await FirebaseMessaging.instance.getToken();
      if (_deviceToken != null) await _sendToken(_deviceToken!);
    } catch (e) {
      debugPrint('Could not register for push: $e');
    }
  }

  Future<void> unregisterDevice() async {
    final token = _deviceToken;
    if (!_ready || token == null) return;
    try {
      await _api.delete(ApiEndpoints.devices, body: {'token': token});
    } catch (_) {
    }
  }

  Future<void> _sendToken(String token) async {
    if (_tokens.read() == null) return;
    await _api.post(
      ApiEndpoints.devices,
      body: {'token': token, 'platform': Platform.isIOS ? 'ios' : 'android'},
    );
  }

  Future<void> _showInForeground(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _local.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: message.data['applicationId'],
    );
  }

  void _openApplication(String? applicationId) {
    if (applicationId == null || _tokens.read() == null) return;
    Get.toNamed(Routes.applicationStatus, arguments: applicationId);
  }
}
