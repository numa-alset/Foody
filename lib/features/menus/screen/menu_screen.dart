import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/features/menus/bloc/menu_cubit.dart';
import 'package:foody/features/menus/bloc/menu_state.dart';
import 'package:foody/features/menus/widgets/menu_card.dart';
import 'package:foody/features/menus/widgets/review_tile.dart';

class MenuScreen extends StatelessWidget {
  final List<String> menuScreenParam;

  const MenuScreen({super.key, required this.menuScreenParam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(menuScreenParam[1]), centerTitle: true),
      body: BlocBuilder<MenuCubit, MenuState>(
        bloc: MenuCubit()..fetchRestaurantDetails(menuScreenParam[0]),
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MenuError) {
            return Center(child: Text(state.message));
          }

          if (state is MenuLoaded) {
            return CustomScrollView(
              slivers: [
                _buildHeader(),
                _buildMenus(state),
                _buildReviews(state),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  /// 🔝 HEADER
  SliverToBoxAdapter _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Menu",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
        ),
      ),
    );
  }

  /// 🍔 MENUS
  SliverList _buildMenus(MenuLoaded state) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(childCount: state.menus.length, (
        context,
        index,
      ) {
        final menu = state.menus[index];
        return MenuCard(menu: menu);
      }),
    );
  }

  /// ⭐ REVIEWS
  SliverToBoxAdapter _buildReviews(MenuLoaded state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              "Reviews",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...state.reviews.map((review) => ReviewTile(review: review)),
          ],
        ),
      ),
    );
  }
}
