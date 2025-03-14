class BlocModel {
  BlocModel(this.date, this.listData);

  final String date;
  final List<dynamic> listData;

  List<NotificationItemDisplay> get transformed {
    return [
      NotificationItemDisplay(NotificationItemDisplayType.DATE, date),
      ...listData.map(
        (e) => NotificationItemDisplay(
          NotificationItemDisplayType.ITEM,
          e,
        ),
      ),
    ];
  }
}

enum NotificationItemDisplayType {
  DATE,
  ITEM,
}

class NotificationItemDisplay {
  final NotificationItemDisplayType type;
  final dynamic data;

  NotificationItemDisplay(this.type, this.data);
}
