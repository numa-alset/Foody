import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/ui/app_empty_view.dart';
import 'package:foody/core/ui/app_error_view.dart';
import 'package:foody/core/ui/app_loading_view.dart';
import 'package:foody/features/deliveries/bloc/delivery_cubit.dart';
import 'package:foody/features/deliveries/bloc/delivery_state.dart';
import 'package:foody/features/deliveries/widgets/delivery_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh(BuildContext context) async {
    await context.read<DeliveryCubit>().fetchDeliveriesWithDrivers();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      builder: (context, state) {
        if (state is DeliveryLoading) {
          return AppLoadingView();
        }

        if (state is DeliveryError) {
          return AppErrorView(
            message: state.message,
            onRetry: () =>
                context.read<DeliveryCubit>().fetchDeliveriesWithDrivers(),
          );
        }

        if (state is DeliveryLoaded) {
          if (state.deliveries.isEmpty) {
            return AppEmptyView(
              title: "No active deliveries",
              onAction: () =>
                  context.read<DeliveryCubit>().fetchDeliveriesWithDrivers(),
            );
          }

          return SmartRefresher(
            controller: _refreshController,
            onRefresh: () => _onRefresh(context),
            header: const WaterDropHeader(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.deliveries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return DeliveryCard(item: state.deliveries[index]);
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
