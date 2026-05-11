import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/maps_launcher.dart';
import '../../../../domain/models/restaurant.dart';

/// Bottom action bar with Directions / Call / Website buttons.
class RestaurantActionBar extends StatelessWidget {
  const RestaurantActionBar({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _PrimaryButton(
              icon: Icons.directions,
              label: 'Directions',
              onTap: () => MapsLauncher.openDirections(
                latitude: restaurant.latitude,
                longitude: restaurant.longitude,
                label: restaurant.name,
                context: context,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _IconButton(
            icon: Icons.phone,
            enabled: restaurant.phoneNumber.isNotEmpty,
            onTap: () => MapsLauncher.callPhone(
              phoneNumber: restaurant.phoneNumber,
              context: context,
            ),
          ),
          const SizedBox(width: 10),
          _IconButton(
            icon: Icons.language,
            enabled: restaurant.website != null,
            onTap: () => _openWebsite(context, restaurant.website),
          ),
        ],
      ),
    );
  }

  Future<void> _openWebsite(BuildContext context, String? url) async {
    if (url == null) return;
    // url_launcher is already used by MapsLauncher; reuse here for website.
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open website')),
      );
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.background, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? AppColors.background
          : AppColors.background.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled ? onTap : null,
        child: Container(
          width: 56,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: enabled ? 0.6 : 0.2),
              width: 1.2,
            ),
          ),
          child: Icon(
            icon,
            color: enabled
                ? AppColors.accent
                : AppColors.accent.withValues(alpha: 0.3),
            size: 22,
          ),
        ),
      ),
    );
  }
}
