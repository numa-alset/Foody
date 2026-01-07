import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/features/home/bloc/restaurant_cubit.dart';
import 'package:foody/features/home/bloc/restaurant_state.dart';
import 'package:foody/features/home/widgets/restaurant_card.dart';
import 'package:foody/features/home/widgets/restaurant_shimmer.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const _HomeHeader(),
            // const SizedBox(height: 20),
            // Expanded should wrap the SmartRefresher, not the child inside it
            Expanded(
              child: BlocBuilder<RestaurantCubit, RestaurantState>(
                builder: (context, state) {
                  Widget content;

                  if (state is RestaurantLoading) {
                    content = ListView.separated(
                      itemCount: 6,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (_, __) => const RestaurantShimmer(),
                    );
                  } else if (state is RestaurantLoaded) {
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
                    content = Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
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
}
