import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../models/app_notification.dart';
import '../models/trade_request.dart';
import '../services/auth_service.dart';
import '../utils/time_formatter.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/notification_filter_tab.dart';
import '../widgets/notification_header.dart';
import '../widgets/notification_item_tile.dart';
import '../widgets/notification_section_title.dart';
import 'item_detail_page.dart';
import 'notice_detail_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int selectedTabIndex = 0;

  AppNotificationType? get _selectedType => switch (selectedTabIndex) {
    1 => AppNotificationType.request,
    2 => AppNotificationType.comment,
    3 => AppNotificationType.favorite,
    4 => AppNotificationType.notice,
    _ => null,
  };

  IconData _iconFor(AppNotificationType type) => switch (type) {
    AppNotificationType.request => Icons.compare_arrows,
    AppNotificationType.comment => Icons.chat_bubble_outline,
    AppNotificationType.favorite => Icons.favorite_border,
    AppNotificationType.notice => Icons.notifications_none,
  };

  Future<void> _openNotification(AppNotification notification) async {
    await appController.markNotificationRead(notification.id);
    if (!mounted) return;

    final String? requestId = notification.relatedRequestId;
    if (notification.type == AppNotificationType.request &&
        requestId != null) {
      TradeRequest? request;
      for (final TradeRequest entry in appController.requests) {
        if (entry.id == requestId) {
          request = entry;
          break;
        }
      }

      final item = request == null
          ? null
          : appController.itemById(request.itemId);
      final user = authService.currentUser;
      if (request != null &&
          item != null &&
          user?.id == item.ownerId &&
          request.status == TradeRequestStatus.pending) {
        final TradeRequestStatus? result =
            await showDialog<TradeRequestStatus>(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: Text('${item.tradeMethod.label} 요청'),
                  content: Text(
                    '${request!.requesterName}님의 요청을 처리해주세요.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(
                        dialogContext,
                        TradeRequestStatus.rejected,
                      ),
                      child: const Text('거절'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(
                        dialogContext,
                        TradeRequestStatus.accepted,
                      ),
                      child: const Text('수락'),
                    ),
                  ],
                );
              },
            );

        if (result != null) {
          await appController.updateTradeRequestStatus(
            requestId: request.id,
            status: result,
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result == TradeRequestStatus.accepted
                    ? '요청을 수락했습니다.'
                    : '요청을 거절했습니다.',
              ),
            ),
          );
        }
      }
    }

    if (!mounted) return;

    if (notification.relatedItemId != null &&
        appController.itemById(notification.relatedItemId!) != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemDetailPage(itemId: notification.relatedItemId!),
        ),
      );
      return;
    }

    if (notification.relatedNoticeId != null &&
        appController.noticeById(notification.relatedNoticeId!) != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              NoticeDetailPage(noticeId: notification.relatedNoticeId!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const NotificationHeader(),
              const SizedBox(height: 26),
              NotificationFilterTab(
                selectedIndex: selectedTabIndex,
                onTap: (index) {
                  setState(() => selectedTabIndex = index);
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: AnimatedBuilder(
                  animation: Listenable.merge([appController, authService]),
                  builder: (context, child) {
                    final user = authService.currentUser;
                    final AppNotificationType? selectedType = _selectedType;
                    final List<AppNotification> notifications = user == null
                        ? []
                        : appController
                              .notificationsFor(user.id)
                              .where(
                                (notification) =>
                                    selectedType == null ||
                                    notification.type == selectedType,
                              )
                              .toList()
                          ..sort(
                            (a, b) => b.createdAt.compareTo(a.createdAt),
                          );

                    if (notifications.isEmpty) {
                      return const Center(child: Text('알림이 없습니다.'));
                    }

                    final DateTime now = DateTime.now();
                    final List<AppNotification> today = notifications.where((
                      notification,
                    ) {
                      final date = notification.createdAt;
                      return date.year == now.year &&
                          date.month == now.month &&
                          date.day == now.day;
                    }).toList();
                    final List<AppNotification> previous = notifications
                        .where((notification) => !today.contains(notification))
                        .toList();

                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        if (today.isNotEmpty) ...[
                          const NotificationSectionTitle(title: '오늘'),
                          const SizedBox(height: 18),
                          ...today.map(_buildTile),
                        ],
                        if (previous.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const NotificationSectionTitle(title: '이전 알림'),
                          const SizedBox(height: 18),
                          ...previous.map(_buildTile),
                        ],
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildTile(AppNotification notification) {
    return NotificationItemTile(
      icon: _iconFor(notification.type),
      title: notification.title,
      content: notification.content,
      time: formatRelativeTime(notification.createdAt),
      isRead: notification.isRead,
      onTap: () => _openNotification(notification),
    );
  }
}
