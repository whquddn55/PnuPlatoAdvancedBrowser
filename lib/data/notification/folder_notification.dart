import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;

class FolderNotification extends noti.Notification {
  FolderNotification({required String title, required String body, required String url, required DateTime time})
      : super(title: title, body: body, url: url, time: time, color: folderColor);

  // @override
  // bool operator ==(final Object other) => other.runtimeType == FolderNotification && hashCode == other.hashCode;

}
