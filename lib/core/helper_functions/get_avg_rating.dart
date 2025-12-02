import 'package:fruits_hub/core/models/review_model.dart';

double getAvgRating(List<ReviewModel> reviews) {
  if (reviews.isEmpty) return 0.0;

  try {
    final totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return double.parse((totalRating / reviews.length).toStringAsFixed(1));
  } catch (e) {
    print('❌ Error calculating average rating: $e');
    return 0.0;
  }
}
