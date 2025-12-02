import 'package:fruits_hub/core/entities/review_entity.dart';

class ReviewModel {
  final String name;
  final String image;
  final num rating;
  final String date;
  final String reviewDescription;

  ReviewModel({
    required this.name,
    required this.image,
    required this.rating,
    required this.date,
    required this.reviewDescription,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      name: json['name']?.toString() ?? 'مستخدم',
      image: json['image']?.toString() ?? '',
      rating: (json['ratting'] ?? json['rating'] ?? 0).toDouble(),
      date: json['date']?.toString() ?? '',
      reviewDescription: json['reviewDescription']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'ratting': rating,
      'date': date,
      'reviewDescription': reviewDescription,
    };
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      name: name,
      image: image,
      rating: rating,
      date: date,
      reviewDescription: reviewDescription,
    );
  }

  @override
  String toString() {
    return 'ReviewModel(name: $name, rating: $rating)';
  }
}
