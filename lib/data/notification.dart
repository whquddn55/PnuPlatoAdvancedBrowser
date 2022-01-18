class Notification {
  final int id;
  final String title;
  final String body;
  final String url;

  Notification({required this.id, required this.title, required this.body, required this.url});

  Future<void> notify() async {
    // final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    //
    // const android = AndroidNotificationDetails('thuthi_plato_noti', '플라토 브라우저 알림', channelDescription:  '플라토 브라우저에서 새 알림을 보여줌',
    //     importance: Importance.max, priority: Priority.high);
    // const detail = NotificationDetails(android: android);
    //
    // await flutterLocalNotificationsPlugin.show(id, title, body, detail, payload: id.toString());
  }
}