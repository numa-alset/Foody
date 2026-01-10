import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/models/restaurant.dart';
import 'package:foody/core/ui/app_empty_view.dart';
import 'package:foody/core/ui/app_error_view.dart';
import 'package:foody/core/ui/app_loading_view.dart';
import 'package:foody/features/menus/bloc/menu_cubit.dart';
import 'package:foody/features/menus/bloc/menu_state.dart';
import 'package:foody/features/menus/widgets/menu_card.dart';
import 'package:foody/features/menus/widgets/review_tile.dart';
import 'package:share_plus/share_plus.dart';

class MenuScreen extends StatelessWidget {
  final Restaurant restaurant;

  const MenuScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => MenuCubit()..fetchRestaurantDetails(restaurant.id),
        child: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(context),
                    SliverToBoxAdapter(child: _buildRestaurantHeader(context)),
                    if (state is MenuLoading)
                      const SliverFillRemaining(
                        child: AppLoadingView(message: "Loading menu..."),
                      )
                    else if (state is MenuError)
                      SliverFillRemaining(
                        child: AppErrorView(
                          message: state.message,
                          onRetry: () => context
                              .read<MenuCubit>()
                              .fetchRestaurantDetails(restaurant.id),
                        ),
                      )
                    else if (state is MenuLoaded) ...[
                      _buildPopularMenusSection(context, state),
                      _buildReviewsSection(state),
                      const SliverToBoxAdapter(child: SizedBox(height: 80)),
                    ],
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        centerTitle: false,
        title: Text(
          restaurant.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            shadows: [Shadow(blurRadius: 6, color: Colors.black45)],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Hero image / cover
            restaurant.logo != null
                ? Image.network(
                    restaurant.logo!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderCover(),
                  )
                : _placeholderCover(),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded),
          onPressed: () {
            SharePlus.instance.share(
              ShareParams(
                text:
                    'Check out this restaurant on Foody 🍽️\n\n'
                    '📍 ${restaurant.name}\n'
                    '⭐ ${restaurant.rating}\n',
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _placeholderCover() {
    return Container(
      color: Colors.grey.shade300,
      child: const Icon(Icons.restaurant, size: 80, color: Colors.grey),
    );
  }

  Widget _buildRestaurantHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                restaurant.cuisineType,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _actionButton(Icons.phone_rounded, "Call", () {
                SharePlus.instance.share(
                  ShareParams(uri: Uri.parse('tel:${restaurant.phone}')),
                );
              }),
              const SizedBox(width: 12),
              _actionButton(Icons.location_on_rounded, "Map", () {
                SharePlus.instance.share(
                  ShareParams(
                    uri: Uri.parse(
                      'https://maps.google.com/?q=${restaurant.address}',
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
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

  _buildPopularMenusSection(BuildContext context, MenuLoaded state) {
    if (state.menus.isEmpty) {
      return AppEmptyView(
        title: "No Menus",
        actionText: "try again",
        onAction: () =>
            context.read<MenuCubit>().fetchRestaurantDetails(restaurant.id),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 24),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Popular Menus",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 310,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: state.menus.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 280, // ← important for good proportions
                    child: MenuCard(menu: state.menus[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildReviewsSection(MenuLoaded state) {
    if (state.reviews.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text("No reviews yet", style: TextStyle(fontSize: 16)),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Text(
                  "Reviews",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                ReviewTile(review: state.reviews[index]),
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ReviewTile(review: state.reviews[index]),
          );
        }, childCount: state.reviews.length),
      ),
    );
  }
}
