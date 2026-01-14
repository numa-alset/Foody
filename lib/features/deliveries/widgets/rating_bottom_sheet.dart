import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/models/delivery.dart';
import 'package:foody/features/deliveries/bloc/delivery_cubit.dart';

class RatingBottomSheet extends StatefulWidget {
  final Delivery delivery;

  const RatingBottomSheet({super.key, required this.delivery});

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  int rating = 5;
  bool isLoading = false;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Rate Your Delivery",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Slider(
            value: rating.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: rating.toString(),
            onChanged: (v) => setState(() => rating = v.toInt()),
          ),

          TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Leave feedback (optional)",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      context.read<DeliveryCubit>().confirmDeliveryAndAddReview(
                        context,
                        widget.delivery,
                        rating,
                        controller.value.text,
                      );
                    },
                    child: const Text("Submit"),
                  ),
          ),
        ],
      ),
    );
  }
}
