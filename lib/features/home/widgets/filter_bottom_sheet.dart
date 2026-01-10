import 'package:flutter/material.dart';

class FilterBottomSheetContent extends StatefulWidget {
  final String? initialCuisine;
  final double initialMinRating;
  final void Function(String? cuisine, double minRating) onApply;
  final VoidCallback onReset;

  const FilterBottomSheetContent({
    super.key,
    required this.initialCuisine,
    required this.initialMinRating,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<FilterBottomSheetContent> createState() =>
      _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<FilterBottomSheetContent> {
  late String? _selectedCuisine;
  late double _minRating;

  @override
  void initState() {
    super.initState();
    _selectedCuisine = widget.initialCuisine;
    _minRating = widget.initialMinRating;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.68,
      minChildSize: 0.52,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filter Restaurants",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  if (_selectedCuisine != null || _minRating > 0.1)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedCuisine = null;
                          _minRating = 0.0;
                        });
                        widget.onReset();
                        Navigator.pop(context);
                      },
                      child: const Text("Clear All"),
                    ),
                ],
              ),
              const SizedBox(height: 28),

              const Text(
                "Cuisine Type",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildChip(
                    "All",
                    _selectedCuisine == null,
                    () => setState(() => _selectedCuisine = null),
                  ),
                  _buildChip(
                    "Italian",
                    _selectedCuisine == "Italian",
                    () => setState(() => _selectedCuisine = "Italian"),
                  ),
                  _buildChip(
                    "Japanese",
                    _selectedCuisine == "Japanese",
                    () => setState(() => _selectedCuisine = "Japanese"),
                  ),
                  _buildChip(
                    "American",
                    _selectedCuisine == "American",
                    () => setState(() => _selectedCuisine = "American"),
                  ),
                  _buildChip(
                    "Indian",
                    _selectedCuisine == "Indian",
                    () => setState(() => _selectedCuisine = "Indian"),
                  ),
                  _buildChip(
                    "Mexican",
                    _selectedCuisine == "Mexican",
                    () => setState(() => _selectedCuisine = "Mexican"),
                  ),
                  _buildChip(
                    "Chinese",
                    _selectedCuisine == "Chinese",
                    () => setState(() => _selectedCuisine = "Chinese"),
                  ),
                  // You can later make this list dynamic from DB
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                "Minimum Rating",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _minRating,
                min: 0,
                max: 5,
                divisions: 5,
                label: _minRating.toStringAsFixed(1),
                onChanged: (value) => setState(() => _minRating = value),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    widget.onApply(_selectedCuisine, _minRating);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Show Results",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
      labelStyle: TextStyle(
        color: selected
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : null,
        fontWeight: selected ? FontWeight.w600 : null,
      ),
    );
  }
}
