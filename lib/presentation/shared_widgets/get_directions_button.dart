import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/maps_launcher.dart';

/// Secondary outlined button that opens Google Maps directions to the
/// given coordinates. Reusable across AttractionDetail and RestaurantDetail.
class GetDirectionsButton extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String label;
  final bool expanded;

  const GetDirectionsButton({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.label,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: () => MapsLauncher.openDirections(
        latitude: latitude,
        longitude: longitude,
        label: label,
        context: context,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accent,
        side: const BorderSide(color: AppColors.accent, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_outlined, size: 20),
          SizedBox(width: 6),
          Flexible(
            child: Text(
              'Directions',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}