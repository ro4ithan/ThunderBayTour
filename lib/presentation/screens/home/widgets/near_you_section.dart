import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../providers/attractions_provider.dart';
import 'featured_card.dart';

class NearYouSection extends ConsumerStatefulWidget {
  const NearYouSection({super.key});

  @override
  ConsumerState<NearYouSection> createState() => _NearYouSectionState();
}

class _NearYouSectionState extends ConsumerState<NearYouSection> {
  final _controller = PageController(viewportFraction: 0.85);
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _page = _controller.page ?? 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featured = ref.watch(featuredAttractionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Text(
            'Start Your Journey Here 📍',
            style: AppTextStyles.headlineMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Top picks near Thunder Bay downtown',
            style: AppTextStyles.bodyMedium,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 380,
          child: PageView.builder(
            controller: _controller,
            itemCount: featured.length,
            itemBuilder: (context, i) {
              final scale = (1 - (_page - i).abs() * 0.08).clamp(0.92, 1.0);
              return Transform.scale(
                scale: scale,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: SizedBox(
                    width: 280,
                    child: FeaturedCard(attraction: featured[i]),
                  ),
                ),
              )
                  .animate(delay: (150 * i).ms)
                  .fadeIn(duration: 450.ms)
                  .slideY(begin: 0.15, end: 0);
            },
          ),
        ),
      ],
    );
  }
}