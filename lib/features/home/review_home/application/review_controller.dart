import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final reviewOverviewProvider = FutureProvider<ReviewOverview>((ref) async {
  return ref.read(homeRepositoryProvider).getReviewOverview();
});

class ReviewFormState {
  const ReviewFormState({
    this.foodRating = 4,
    this.deliveryRating = 0,
    this.comment = '',
    this.photos = const [],
    this.initialized = false,
  });

  final int foodRating;
  final int deliveryRating;
  final String comment;
  final List<String> photos;
  final bool initialized;

  ReviewFormState copyWith({
    int? foodRating,
    int? deliveryRating,
    String? comment,
    List<String>? photos,
    bool? initialized,
  }) {
    return ReviewFormState(
      foodRating: foodRating ?? this.foodRating,
      deliveryRating: deliveryRating ?? this.deliveryRating,
      comment: comment ?? this.comment,
      photos: photos ?? this.photos,
      initialized: initialized ?? this.initialized,
    );
  }
}

final reviewFormProvider =
    NotifierProvider<ReviewFormController, ReviewFormState>(
      ReviewFormController.new,
    );

class ReviewFormController extends Notifier<ReviewFormState> {
  @override
  ReviewFormState build() => const ReviewFormState();

  void setFoodRating(int value) {
    state = state.copyWith(foodRating: value.clamp(0, 5));
  }

  void setDeliveryRating(int value) {
    state = state.copyWith(deliveryRating: value.clamp(0, 5));
  }

  void setComment(String value) {
    state = state.copyWith(comment: value);
  }

  void setInitialPhotos(List<String> photos) {
    if (state.initialized) {
      return;
    }
    state = state.copyWith(photos: photos, initialized: true);
  }

  void removePhotoAt(int index) {
    if (index < 0 || index >= state.photos.length) {
      return;
    }
    final next = [...state.photos]..removeAt(index);
    state = state.copyWith(photos: next);
  }
}
