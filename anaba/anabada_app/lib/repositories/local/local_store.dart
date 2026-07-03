import '../../models/app_notification.dart';
import '../../models/item_comment.dart';
import '../../models/notice.dart';
import '../../models/trade_item.dart';
import '../../models/trade_request.dart';

class LocalStore {
  LocalStore();

  factory LocalStore.seeded() {
    final LocalStore store = LocalStore();
    final DateTime now = DateTime.now();

    store.items.addAll([
      TradeItem(
        id: 'item-1',
        title: '깨끗한 텀블러',
        description: '사용 횟수가 적어 상태가 좋습니다.',
        wantedItem: '필기구',
        category: ItemCategory.etc,
        tradeMethod: TradeMethod.exchange,
        status: ItemTradeStatus.available,
        ownerId: 'user-2',
        ownerName: '김준수',
        ownerGeneration: '9기',
        createdAt: now.subtract(const Duration(minutes: 3)),
        likedUserIds: const {'fake-user-1', 'user-3'},
      ),
      TradeItem(
        id: 'item-2',
        title: '프로그래밍 입문서',
        description: '필기 없이 깨끗하게 사용했습니다.',
        wantedItem: '소설책',
        category: ItemCategory.book,
        tradeMethod: TradeMethod.exchange,
        status: ItemTradeStatus.available,
        ownerId: 'fake-user-1',
        ownerName: '테스트 사용자',
        ownerGeneration: '10기',
        createdAt: now.subtract(const Duration(hours: 2)),
        likedUserIds: const {'user-2', 'user-3', 'user-4'},
      ),
      TradeItem(
        id: 'item-3',
        title: '후드 집업',
        description: '사이즈가 맞지 않아 나눔합니다.',
        category: ItemCategory.clothes,
        tradeMethod: TradeMethod.share,
        status: ItemTradeStatus.available,
        ownerId: 'user-3',
        ownerName: '안율',
        ownerGeneration: '10기',
        createdAt: now.subtract(const Duration(hours: 5)),
        likedUserIds: const {'fake-user-1'},
      ),
      TradeItem(
        id: 'item-4',
        title: '간식 꾸러미',
        description: '유통기한이 넉넉한 미개봉 간식입니다.',
        category: ItemCategory.food,
        tradeMethod: TradeMethod.share,
        status: ItemTradeStatus.completed,
        ownerId: 'user-4',
        ownerName: '추혜인',
        ownerGeneration: '10기',
        createdAt: now.subtract(const Duration(days: 1)),
        likedUserIds: const {'user-2', 'user-3', 'user-5', 'fake-user-1'},
      ),
      TradeItem(
        id: 'item-5',
        title: '무선 마우스',
        description: '정상 작동하며 건전지도 함께 드립니다.',
        wantedItem: 'USB 허브',
        category: ItemCategory.etc,
        tradeMethod: TradeMethod.exchange,
        status: ItemTradeStatus.completed,
        ownerId: 'fake-user-1',
        ownerName: '테스트 사용자',
        ownerGeneration: '10기',
        createdAt: now.subtract(const Duration(days: 2)),
        likedUserIds: const {'user-2', 'user-3'},
      ),
    ]);

    store.comments.addAll([
      ItemComment(
        id: 'comment-1',
        itemId: 'item-1',
        authorId: 'user-3',
        authorName: '안율',
        content: '아직 교환 가능한가요?',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      ItemComment(
        id: 'comment-2',
        itemId: 'item-1',
        authorId: 'fake-user-1',
        authorName: '테스트 사용자',
        content: '어디에서 거래할 수 있나요?',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      ItemComment(
        id: 'comment-3',
        itemId: 'item-2',
        authorId: 'user-2',
        authorName: '김준수',
        content: '책 상태가 궁금합니다.',
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
    ]);

    store.notices.addAll([
      Notice(
        id: 'notice-1',
        title: '서비스 점검 안내',
        content: '''안녕하세요, 아나바다 운영팀입니다.

보다 안정적인 서비스 제공을 위해 시스템 점검을 진행할 예정입니다.

점검 시간 동안 서비스 이용이 일시적으로 제한될 수 있습니다.
이용에 불편을 드려 죄송합니다.''',
        author: '관리자',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      Notice(
        id: 'notice-2',
        title: '안전한 거래를 위한 안내',
        content: '교환 장소는 사람이 많은 공공장소를 이용해 주세요.',
        author: '관리자',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Notice(
        id: 'notice-3',
        title: '아나바다 이용 규칙',
        content: '서로를 배려하는 표현과 정확한 물건 정보를 사용해 주세요.',
        author: '관리자',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ]);

    store.notifications.addAll([
      AppNotification(
        id: 'notification-1',
        userId: 'fake-user-1',
        type: AppNotificationType.favorite,
        title: '찜 알림',
        content: '프로그래밍 입문서를 찜했어요.',
        createdAt: now.subtract(const Duration(minutes: 3)),
        relatedItemId: 'item-2',
      ),
      AppNotification(
        id: 'notification-2',
        userId: 'fake-user-1',
        type: AppNotificationType.request,
        title: '교환 요청',
        content: '프로그래밍 입문서에 대한 교환 요청이 도착했어요.',
        createdAt: now.subtract(const Duration(minutes: 15)),
        relatedItemId: 'item-2',
        relatedRequestId: 'request-1',
      ),
      AppNotification(
        id: 'notification-3',
        userId: 'fake-user-1',
        type: AppNotificationType.comment,
        title: '새 댓글',
        content: '프로그래밍 입문서에 새로운 댓글이 달렸어요.',
        createdAt: now.subtract(const Duration(minutes: 30)),
        relatedItemId: 'item-2',
      ),
      AppNotification(
        id: 'notification-4',
        userId: 'fake-user-1',
        type: AppNotificationType.notice,
        title: '공지사항',
        content: '서비스 점검 안내',
        createdAt: now.subtract(const Duration(hours: 3)),
        relatedNoticeId: 'notice-1',
      ),
    ]);

    store.requests.add(
      TradeRequest(
        id: 'request-1',
        itemId: 'item-2',
        requesterId: 'user-2',
        requesterName: '김준수',
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
    );
    store.recentItemIds['fake-user-1'] = ['item-1', 'item-3'];
    return store;
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
      orElse: () => throw StateError('물건을 찾을 수 없습니다.'),
    );
  }

  int itemIndex(String itemId) {
    final int index = items.indexWhere((item) => item.id == itemId);
    if (index == -1) throw StateError('물건을 찾을 수 없습니다.');
    return index;
  }

  String newId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';
  }
}
