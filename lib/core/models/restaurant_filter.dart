class RestaurantFilters {
  final String? cuisine;
  final double? minRating;
  final String? searchQuery; // name or address partial match
  final String? sortBy; // 'rating_desc', 'name_asc', etc

  const RestaurantFilters({
    this.cuisine,
    this.minRating,
    this.searchQuery,
    this.sortBy = 'rating_desc',
  });

  RestaurantFilters copyWith({
    String? cuisine,
    double? minRating,
    String? searchQuery,
    String? sortBy,
  }) {
    return RestaurantFilters(
      cuisine: cuisine ?? this.cuisine,
      minRating: minRating ?? this.minRating,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  Map<String, dynamic> toQueryParams() => {
    if (cuisine != null) 'cuisine_type': cuisine,
    if (minRating != null) 'rating': minRating,
    if (searchQuery != null && searchQuery!.trim().isNotEmpty)
      'search': searchQuery!.trim(),
  };
}
