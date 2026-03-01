import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/features/home/review_home/application/review_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';

class ReviewPage extends ConsumerWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(reviewOverviewProvider);
    final formState = ref.watch(reviewFormProvider);
    final formController = ref.read(reviewFormProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      child: SafeArea(
        bottom: false,
        child: overviewState.when(
          data: (overview) {
            if (!formState.initialized &&
                overview.attachedImageAssets.isNotEmpty) {
              Future<void>.microtask(() {
                formController.setInitialPhotos(overview.attachedImageAssets);
              });
            }
            return Column(
              children: [
                _Header(onClose: () => context.go(AppRoutes.homeOrders)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                overview.heroImageAsset,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    overview.restaurantName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    overview.orderLabel,
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const Center(
                          child: Text(
                            'How was the food?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            'Rate your experience with the restaurant',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: _StarRow(
                            count: formState.foodRating,
                            size: 36,
                            onTap: formController.setFoodRating,
                            rowKey: const Key('review-food-stars'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Divider(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFF1F5F9),
                        ),
                        const SizedBox(height: 18),
                        Center(
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Symbols.delivery_dining,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            'How was your delivery?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            "Rate the rider's service",
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: _StarRow(
                            count: formState.deliveryRating,
                            size: 32,
                            onTap: formController.setDeliveryRating,
                            rowKey: const Key('review-delivery-stars'),
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Write a comment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          key: const Key('review-comment-field'),
                          minLines: 4,
                          maxLines: 5,
                          onChanged: formController.setComment,
                          decoration: InputDecoration(
                            hintText:
                                'What did you like or dislike about your order?',
                            filled: true,
                            fillColor: isDark
                                ? const Color(0x801E293B)
                                : const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: const [
                            Text(
                              'Add photos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Optional',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 96,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                width: 96,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFE2E8F0),
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Symbols.add_a_photo,
                                      color: Color(0xFF94A3B8),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Add Photo',
                                      style: TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              for (
                                var i = 0;
                                i < formState.photos.length;
                                i++
                              ) ...[
                                _PhotoTile(
                                  key: Key('review-photo-$i'),
                                  imageAsset: formState.photos[i],
                                  onRemove: () =>
                                      formController.removePhotoAt(i),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFF1F5F9),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          key: const Key('review-submit-button'),
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: QBTokens.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Submit Feedback',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'By submitting, you agree to the community guidelines.',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Unable to load review: $error')),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          IconButton(onPressed: onClose, icon: const Icon(Symbols.close)),
          const Expanded(
            child: Center(
              child: Text(
                'Write a Review',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({
    required this.count,
    required this.size,
    required this.onTap,
    required this.rowKey,
  });

  final int count;
  final double size;
  final ValueChanged<int> onTap;
  final Key rowKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: rowKey,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index < count;
        return IconButton(
          onPressed: () => onTap(index + 1),
          icon: Icon(
            Symbols.star,
            size: size,
            fill: filled ? 1 : 0,
            color: filled ? const Color(0xFFFACC15) : const Color(0xFFCBD5E1),
          ),
        );
      }),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    super.key,
    required this.imageAsset,
    required this.onRemove,
  });

  final String imageAsset;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(imageAsset, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: InkWell(
              key: const Key('review-remove-photo-button'),
              onTap: onRemove,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0x99000000),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Symbols.close, color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
