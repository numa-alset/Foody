import 'package:flutter/material.dart';
import 'package:foody/core/models/delivery.dart';
import 'package:foody/core/models/driver.dart';
import 'package:foody/features/deliveries/bloc/delivery_with_driver.dart';
import 'package:foody/features/deliveries/widgets/rating_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

class DeliveryCard extends StatelessWidget {
  final DeliveryWithDriver item;

  const DeliveryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final delivery = item.delivery;
    final driver = item.driver;

    final remainingMinutes = delivery.estimatedTime
        .difference(DateTime.now())
        .inMinutes;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${delivery.orderId.substring(0, 8)}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                _statusChip(delivery.deliveryStatus),
              ],
            ),

            const SizedBox(height: 8),

            /// ETA
            Text(
              remainingMinutes > 0
                  ? "Arriving in $remainingMinutes min"
                  : "Arriving soon",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const Divider(height: 24),

            /// Driver preview
            Row(
              children: [
                const Icon(Icons.delivery_dining),
                const SizedBox(width: 8),
                Expanded(child: Text("${driver.name} • ${driver.vehicleType}")),
                TextButton(
                  onPressed: () => _showDriverDetails(context, driver),
                  child: const Text("Details"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: delivery.deliveryStatus == "delivered"
                        ? null
                        : () => _showRatingSheet(context, delivery),
                    child: const Text("Confirm Delivered"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _statusChip(String status) {
    final color = switch (status) {
      "pending" => Colors.orange,
      "on_the_way" => Colors.blue,
      "delivered" => Colors.green,
      _ => Colors.grey,
    };

    return Chip(
      label: Text(status.replaceAll("_", " ").toUpperCase()),
      backgroundColor: color.withValues(alpha: 0.15),
      labelStyle: TextStyle(color: color),
    );
  }

  void _showRatingSheet(BuildContext context, Delivery delivery) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => RatingBottomSheet(delivery: delivery),
    );
  }

  void _showDriverDetails(BuildContext context, Driver driver) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _actionButton(Icons.phone_rounded, "Call", () {
              SharePlus.instance.share(
                ShareParams(uri: Uri.parse('tel:${driver.phone}')),
              );
            }),
            const SizedBox(height: 8),
            Row(children: [Text("Phone: ${driver.phone}")]),
            Text("Vehicle: ${driver.vehicleType}"),
            Text(
              driver.availabilityStatus ? "Available" : "Unavailable",
              style: TextStyle(
                color: driver.availabilityStatus ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
