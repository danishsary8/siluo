import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/account_controller.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../orders/atelier_order_tracking_view.dart';
import 'widgets/account_ui.dart';

/// Full order history with status filter tabs.
class AtelierOrderHistoryView extends StatefulWidget {
  const AtelierOrderHistoryView({super.key});

  @override
  State<AtelierOrderHistoryView> createState() => _AtelierOrderHistoryViewState();
}

class _AtelierOrderHistoryViewState extends State<AtelierOrderHistoryView> {
  String _tab = 'All';
  static const _tabs = ['All', 'In Transit', 'Delivered', 'Returned'];

  Color _statusColor(String s) => switch (s) {
        'In Transit' => AppColors.silouFlash,
        'Delivered' => AppColors.inStockGreen,
        _ => AppColors.textMuted,
      };

  @override
  Widget build(BuildContext context) {
    final orders = AccountController.to.orders
        .where((o) => _tab == 'All' || o.status == _tab)
        .toList();
    final atelier = AtelierController.to;
    return Scaffold(
      backgroundColor: AccountUi.canvas(context),
      appBar: AccountUi.appBar(context, 'My Orders'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: CupertinoSlidingSegmentedControl<String>(
              groupValue: _tab,
              thumbColor: AccountUi.surface(context),
              backgroundColor: AccountUi.border(context).withValues(alpha: 0.6),
              children: {
                for (final t in _tabs)
                  t: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      t,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AccountUi.text(context)),
                    ),
                  ),
              },
              onValueChanged: (v) {
                if (v == null) return;
                HapticService.selection();
                setState(() => _tab = v);
              },
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: orders.isEmpty
                  ? Center(
                      key: const ValueKey('empty'),
                      child: Text('No orders here yet', style: TextStyle(color: AccountUi.muted(context))),
                    )
                  : ListView.separated(
                      key: ValueKey(_tab),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                      physics: const BouncingScrollPhysics(),
                      itemCount: orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final o = orders[i];
                        final c = _statusColor(o.status);
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              HapticService.light();
                              Get.to<void>(() => AtelierOrderTrackingView(orderId: o.id));
                            },
                            child: Ink(
                              padding: const EdgeInsets.all(14),
                              decoration: AccountUi.card(context),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.network(
                                      o.imageUrl,
                                      width: 70,
                                      height: 84,
                                      fit: BoxFit.cover,
                                      cacheWidth: 210,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 70,
                                        height: 84,
                                        color: AccountUi.border(context),
                                        child: const Icon(CupertinoIcons.bag, color: AppColors.champagneGold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              o.id,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: AccountUi.text(context),
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: c.withValues(alpha: 0.14),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                o.status,
                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: c),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          o.items,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 13, color: AccountUi.muted(context)),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(o.date, style: TextStyle(fontSize: 11, color: AccountUi.muted(context))),
                                            const Spacer(),
                                            Text(
                                              '${atelier.currencySymbol}${(o.total * atelier.currencyRate).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: AccountUi.text(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
