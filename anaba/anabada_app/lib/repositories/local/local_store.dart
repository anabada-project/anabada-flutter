import '../../models/app_notification.dart';
import '../../models/item_comment.dart';
import '../../models/notice.dart';
import '../../models/trade_item.dart';
import '../../models/trade_request.dart';

class LocalStore {
  LocalStore();

  factory LocalStore.seeded() {
    return LocalStore();
  }

  final List<TradeItem> items = [];
  final List<ItemComment> comments = [];
  final List<AppNotification> notifications = [];
  final List<Notice> notices = [];
  final List<TradeRequest> requests = [];
  final Map<String, List<String>> recentItemIds = {};
  int _idCounter = 0;

  TradeItem itemById(String itemId) {
    return items.firstWhere(
      (item) => item.id == itemId,
      orElse: () => throw StateError('Item not found.'),
    );
  }

  int itemIndex(String itemId) {
    final int index = items.indexWhere((item) => item.id == itemId);
    if (index == -1) throw StateError('Item not found.');
    return index;
  }

  String newId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';
  }
}
