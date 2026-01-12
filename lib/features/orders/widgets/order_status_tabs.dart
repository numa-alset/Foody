import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/enums/order_status.dart';
import 'package:foody/features/orders/bloc/order_cubit.dart';
import 'package:foody/features/orders/bloc/order_state.dart';

class OrderStatusTabs extends StatelessWidget {
  const OrderStatusTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        if (state is! OrderLoaded) return const SizedBox.shrink();

        final selected = state.selectedStatus;

        return Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: OrderStatus.values.map((status) {
              final isSelected = selected == status;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  showCheckmark: false,
                  label: Text(
                    status.label,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: isSelected ? status.color : Colors.grey.shade700,
                    ),
                  ),
                  selected: isSelected,
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: status.color.withOpacity(0.18),
                  side: BorderSide(
                    color: isSelected ? status.color : Colors.transparent,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onSelected: (_) =>
                      context.read<OrderCubit>().changeFilter(status),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
