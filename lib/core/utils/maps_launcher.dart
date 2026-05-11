import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Unified utility for launching Google Maps directions, viewing locations,
/// dialing phone numbers, and multi-stop tour routes.
class MapsLauncher {
  MapsLauncher._();

  /// Opens Google Maps with turn-by-turn directions to a single destination.
  static Future<bool> openDirections({
    required double latitude,
    required double longitude,
    required String label,
    BuildContext? context,
  }) async {
    final String encodedLabel = Uri.encodeComponent(label);

    final Uri googleNavUri =
        Uri.parse('google.navigation:q=$latitude,$longitude&mode=d');
    final Uri geoUri = Uri.parse(
        'geo:$latitude,$longitude?q=$latitude,$longitude($encodedLabel)');
    final Uri webUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving');

    try {
      if (await canLaunchUrl(googleNavUri)) {
        return await launchUrl(googleNavUri,
            mode: LaunchMode.externalApplication);
      }
      if (await canLaunchUrl(geoUri)) {
        return await launchUrl(geoUri, mode: LaunchMode.externalApplication);
      }
      if (await canLaunchUrl(webUri)) {
        return await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
      if (context != null && context.mounted) {
        _showError(context, 'No map app available');
      }
      return false;
    } catch (_) {
      if (context != null && context.mounted) {
        _showError(context, 'Could not open directions');
      }
      return false;
    }
  }

  /// Opens Google Maps showing the location (just a pin, no directions).
  static Future<bool> openLocation({
    required double latitude,
    required double longitude,
    required String label,
    BuildContext? context,
  }) async {
    final String encodedLabel = Uri.encodeComponent(label);
    final Uri geoUri = Uri.parse(
        'geo:$latitude,$longitude?q=$latitude,$longitude($encodedLabel)');
    final Uri webUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    try {
      if (await canLaunchUrl(geoUri)) {
        return await launchUrl(geoUri, mode: LaunchMode.externalApplication);
      }
      if (await canLaunchUrl(webUri)) {
        return await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
      if (context != null && context.mounted) {
        _showError(context, 'No map app available');
      }
      return false;
    } catch (_) {
      if (context != null && context.mounted) {
        _showError(context, 'Could not open map');
      }
      return false;
    }
  }

  /// Opens the phone dialer with the given number pre-filled.
  static Future<bool> callPhone({
    required String phoneNumber,
    BuildContext? context,
  }) async {
    final String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri telUri = Uri.parse('tel:$cleaned');

    try {
      if (await canLaunchUrl(telUri)) {
        return await launchUrl(telUri, mode: LaunchMode.externalApplication);
      }
      if (context != null && context.mounted) {
        _showError(context, 'No phone app available');
      }
      return false;
    } catch (_) {
      if (context != null && context.mounted) {
        _showError(context, 'Could not start call');
      }
      return false;
    }
  }

  /// Opens Google Maps with a multi-stop driving route through all given stops.
  static Future<bool> openMultiStop({
    required List<({double lat, double lng})> stops,
    BuildContext? context,
  }) async {
    if (stops.isEmpty) {
      if (context != null && context.mounted) {
        _showError(context, 'No stops to route');
      }
      return false;
    }

    if (stops.length == 1) {
      return openDirections(
        latitude: stops.first.lat,
        longitude: stops.first.lng,
        label: 'Destination',
        context: context,
      );
    }

    final origin = '${stops.first.lat},${stops.first.lng}';
    final destination = '${stops.last.lat},${stops.last.lng}';
    final waypoints = stops
        .sublist(1, stops.length - 1)
        .map((s) => '${s.lat},${s.lng}')
        .join('|');

    final webUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=$origin'
      '&destination=$destination'
      '${waypoints.isNotEmpty ? '&waypoints=${Uri.encodeComponent(waypoints)}' : ''}'
      '&travelmode=driving',
    );

    try {
      if (await canLaunchUrl(webUri)) {
        return await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
      if (context != null && context.mounted) {
        _showError(context, 'No map app available');
      }
      return false;
    } catch (_) {
      if (context != null && context.mounted) {
        _showError(context, 'Could not open route');
      }
      return false;
    }
  }

  static void _showError(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}