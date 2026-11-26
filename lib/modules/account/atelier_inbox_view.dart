import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/account_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import 'widgets/account_ui.dart';

/// Notifications inbox with category filters, read state and swipe-to-delete
/// with undo.
class AtelierInboxView extends StatefulWidget {
  const AtelierInboxView({super.key});

  @override
  State<AtelierInboxView> createState() => _AtelierInboxViewState();
}

class _AtelierInboxViewState extends State<AtelierInboxView> {
  InboxCategory? _filter;

  static const _labels = {
    null: 'All',
    InboxCategory.order: 'Orders',
    InboxCategory.drop: 'Drops',
    InboxCategory.offer: 'Offers',
    InboxCategory.atelier: 'Atelier',
  };

  static IconData iconFor(InboxCategory c) => switch (c) {
        InboxCategory.order => CupertinoIcons.cube_box_fill,
        InboxCategory.drop => CupertinoIcons.sparkles,
        InboxCategory.offer => CupertinoIcons.tag_fill,
        InboxCategory.atelier => CupertinoIcons.scissors,
      };

  static Color colorFor(InboxCategory c) => switch (c) {
        InboxCategory.order => AppColors.silouBadgeBlue,
        InboxCategory.drop => AppColors.champagneGold,
        InboxCategory.offer => AppColors.silouPrimary,
        InboxCategory.atelier => AppColors.inStockGreen,
      };

  static String ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final account = AccountController.to;
    return Scaffold(
      backgroundColor: AccountUi.canvas(context),
      appBar: AccountUi.appBar(
        context,
        'Inbox',
        actions: [
          Obx(() => TextButton(
                onPressed: account.unreadCount == 0 ? null : account.markAllRead,
                child: Text(
                  'Read all',
                  style: TextStyle(
                    color: account.unreadCount == 0
                        ? AccountUi.muted(context)
                        : AppColors.champagneGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                for (final e in _labels.entries)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(e.value),
                      selected: _filter == e.key,
                      showCheckmark: false,
                      selectedColor: AccountUi.dark(context) ? AppColors.champagneGold : AppColors.ctaDark,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _filter == e.key ? Colors.white : AccountUi.text(context),
                      ),
                      onSelected: (_) {
                        HapticService.selection();
                        setState(() => _filter = e.key);
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final items = account.inbox
                  .where((m) => _filter == null || m.category == _filter)
                  .toList();
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: items.isEmpty
                    ? _empty(context)
                    : ListView.builder(
                        key: ValueKey('list-$_filter'),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, i) => _tile(context, items[i]),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context) => Center(
        key: const ValueKey('empty'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.bell_slash, size: 52, color: AppColors.champagneGold),
            const SizedBox(height: 14),
            Text(
              "You're all caught up",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AccountUi.text(context)),
            ),
            const SizedBox(height: 6),
            Text('New messages will appear here.', style: TextStyle(color: AccountUi.muted(context))),
          ],
        ),
      );

  Widget _tile(BuildContext context, InboxMessage m) {
    final account = AccountController.to;
    final color = colorFor(m.category);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: ValueKey(m.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          final removed = account.removeMessage(m.id);
          if (removed == null) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: const Text('Message deleted'),
                action: SnackBarAction(
                  label: 'UNDO',
                  textColor: AppColors.champagneGold,
                  onPressed: () => account.restoreMessage(removed),
                ),
              ),
            );
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: AppColors.saleRed,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(CupertinoIcons.trash, color: Colors.white),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              HapticService.light();
              account.markRead(m.id);
              _openDetail(context, m);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: m.isRead
                    ? AccountUi.surface(context)
                    : color.withValues(alpha: AccountUi.dark(context) ? 0.14 : 0.07),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AccountUi.border(context)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(iconFor(m.category), color: color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                m.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: m.isRead ? FontWeight.w600 : FontWeight.w800,
                                  color: AccountUi.text(context),
                                ),
                              ),
                            ),
                            Text(ago(m.time), style: TextStyle(fontSize: 11, color: AccountUi.muted(context))),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, height: 1.4, color: AccountUi.muted(context)),
                        ),
                      ],
                    ),
                  ),
                  if (!m.isRead) ...[
                    const SizedBox(width: 8),
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, InboxMessage m) {
    final color = colorFor(m.category);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AccountUi.canvas(context),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(iconFor(m.category), color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _labels[m.category]!.toUpperCase(),
                    style: TextStyle(fontSize: 11, letterSpacing: 1.4, fontWeight: FontWeight.w800, color: color),
                  ),
                  const Spacer(),
                  Text('${ago(m.time)} ago', style: TextStyle(color: AccountUi.muted(ctx), fontSize: 12)),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                m.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AccountUi.text(ctx)),
              ),
              const SizedBox(height: 10),
              Text(m.body, style: TextStyle(fontSize: 15, height: 1.5, color: AccountUi.muted(ctx))),
              const SizedBox(height: 24),
              AccountPrimaryButton(label: 'Got it', onPressed: () => Navigator.pop(ctx)),
            ],
          ),
        ),
      ),
    );
  }
}
