import 'package:clothing_app/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/orders_controller.dart';
import '../../data/order.dart';
import '../../routes/app_routes.dart';

class CheckoutReviewView extends StatelessWidget {
  const CheckoutReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final ordersCtrl = Get.find<OrdersController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Review Order",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.black12.withValues(alpha: 0.06)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          children: [
            // Items List
            Expanded(
              child: ListView(
                children: cart.items.values.map((item) {
                  final total =
                  (item.product.price * item.qty.value).toStringAsFixed(2);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            item.product.image,
                            width: 62,
                            height: 62,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "\$${item.product.price.toStringAsFixed(2)}  ×  ${item.qty.value}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "\$$total",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            // Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _priceRow(
                      "Subtotal", "\$${cart.subtotal.toStringAsFixed(2)}"),
                  _priceRow("Delivery", "\$3.00"),
                  _priceRow("Tax", "\$0.00"),
                  const Divider(height: 22),
                  _priceRow(
                    "Total",
                    "\$${(cart.subtotal + 8).toStringAsFixed(2)}",
                    bold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // create new order
                  // create the order
                  final newOrder = Order(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    date: DateTime.now(),
                    items: cart.items.values.toList(),
                    total: cart.subtotal + 8,
                  );

// Build invoice summary text
                  final invoiceLines = newOrder.items
                      .map((item) =>
                  "${item.product.name} x${item.qty.value}: \$${(item.product.price * item.qty.value).toStringAsFixed(2)}")
                      .join("\n");

                  final invoiceText =
                      "Order #${newOrder.id}\n$invoiceLines\nShipping: \$8.00\nTotal: \$${newOrder.total.toStringAsFixed(2)}";

// add notification
                  final notificationsCtrl =
                  Get.find<NotificationsController>();
                  notificationsCtrl.addNotification(
                    NotificationItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: "Order Confirmed!",
                      body:
                      "Your order #${newOrder.id} has been placed successfully!",
                      invoice: invoiceText, // 🟢 now defined correctly
                      time: DateTime.now(),
                    ),
                  );

// save order
                  ordersCtrl.addOrder(newOrder);

// clear cart
                  cart.items.clear();
                  cart.saveToStorage();

// navigate to success screen
                  Get.offAllNamed(AppRoutes.orderSuccess);
                },
                child: const Text(
                  "Place Order",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _priceRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: bold ? 16 : 14,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 16 : 14,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
