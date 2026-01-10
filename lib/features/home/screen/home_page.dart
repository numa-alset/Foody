import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/models/restaurant_filter.dart';
import 'package:foody/core/ui/app_empty_view.dart';
import 'package:foody/core/ui/app_error_view.dart';
import 'package:foody/core/ui/app_loading_view.dart';
import 'package:foody/features/home/bloc/restaurant_cubit.dart';
import 'package:foody/features/home/bloc/restaurant_state.dart';
import 'package:foody/features/home/widgets/filter_bottom_sheet.dart';
import 'package:foody/features/home/widgets/restaurant_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    final cubit = context.read<RestaurantCubit>();
    await cubit.fetchRestaurants();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // In HomePage - better visual feedback when filters are active
      floatingActionButton: Builder(
        builder: (context) {
          final state = context.watch<RestaurantCubit>().state;
          final hasFilters =
              state is RestaurantLoaded &&
              (state.restaurantFilters.cuisine != null ||
                  state.restaurantFilters.minRating != null);

          return FloatingActionButton.extended(
            onPressed: () => _showFilterBottomSheet(context),
            icon: const Icon(Icons.filter_list_rounded),
            label: Row(
              children: [
                const Text("Filter"),
                if (hasFilters) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("Active", style: TextStyle(fontSize: 11)),
                  ),
                ],
              ],
            ),
            backgroundColor: hasFilters ? Colors.green.shade700 : null,
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<RestaurantCubit, RestaurantState>(
                builder: (context, state) {
                  Widget content;

                  if (state is RestaurantLoading) {
                    // content = ListView.separated(
                    //   itemCount: 6,
                    //   separatorBuilder: (_, __) => const SizedBox(height: 20),
                    //   itemBuilder: (_, __) => const RestaurantShimmer(),
                    // );
                    content = AppLoadingView(message: "loading Restaurants");
                  } else if (state is RestaurantLoaded) {
                    if (state.restaurants.isEmpty) {
                      content = AppEmptyView(
                        title: "No restaurants found.",
                        subtitle: "Try adjusting your filters.",
                        actionText: "Clear Filters",
                        onAction: () =>
                            context.read<RestaurantCubit>().resetFilters(),
                      );
                      return content;
                    }
                    content = ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.restaurants.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (_, index) {
                        return RestaurantCard(
                          restaurant: state.restaurants[index],
                        );
                      },
                    );
                  } else if (state is RestaurantError) {
                    content = AppErrorView(
                      onRetry: () =>
                          context.read<RestaurantCubit>().fetchRestaurants(),
                      message: state.message,
                    );
                  } else {
                    content = const SizedBox();
                  }

                  return SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    header: const WaterDropHeader(),
                    onRefresh: _onRefresh,
                    child: content,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFilterBottomSheet(BuildContext context) {
    final cubit = context.read<RestaurantCubit>();
    final current =
        (cubit.state as RestaurantLoaded?)?.restaurantFilters ??
        const RestaurantFilters();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => FilterBottomSheetContent(
        initialCuisine: current.cuisine,
        initialMinRating: current.minRating ?? 0.0,
        onApply: (cuisine, minRating) {
          cubit.updateFilters(
            RestaurantFilters(
              cuisine: cuisine,
              minRating: minRating > 0.1
                  ? minRating
                  : null, // 0.1 to avoid floating point noise
            ),
          );
        },
        onReset: () {
          cubit.resetFilters();
        },
      ),
    );
  }

  // Widget _cuisineChip(String label, bool selected, VoidCallback onTap) {
  //   return ChoiceChip(
  //     label: Text(label),
  //     selected: selected,
  //     onSelected: (_) => onTap(),
  //     selectedColor: Theme.of(
  //       context,
  //     ).colorScheme.primary.withValues(alpha: 0.15),
  //     backgroundColor: Colors.grey.shade100,
  //   );
  // }
}
