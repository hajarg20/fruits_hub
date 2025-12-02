import 'package:fruits_hub/core/entities/product_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../helper_functions/get_avg_rating.dart';
import 'review_model.dart';

class ProductModel {
  final String name;
  final String code;
  final String description;
  final num price;
  final bool isFeatured;
  final num sellingCount;
  final String? imageUrl;
  final int expirationsMonths;
  final bool isOrganic;
  final int numberOfCalories;
  final num avgRating;
  final num ratingCount;
  final int unitAmount;
  final List<ReviewModel> reviews;

  ProductModel({
    required this.name,
    required this.code,
    required this.description,
    required this.expirationsMonths,
    required this.numberOfCalories,
    required this.avgRating,
    required this.ratingCount,
    required this.unitAmount,
    required this.sellingCount,
    required this.reviews,
    required this.price,
    required this.isOrganic,
    required this.isFeatured,
    this.imageUrl,
  });

  // دالة مساعدة لمعالجة مسارات الصور (static)
  static String? getImageUrl(String? rawImagePath) {
    if (rawImagePath == null || rawImagePath.isEmpty) {
      return 'https://via.placeholder.com/200?text=No+Image';
    }

    try {
      final supabase = Supabase.instance.client;

      // تنظيف المسار
      String cleanPath = rawImagePath.trim();

      // إزالة البادئة المكررة إذا وجدت
      if (cleanPath.startsWith('fruits_images/')) {
        cleanPath = cleanPath.replaceFirst('fruits_images/', '');
      }

      if (cleanPath.contains('..')) {
        cleanPath = cleanPath.replaceAll('..', '.');
      }

      if (cleanPath.startsWith('/')) {
        cleanPath = cleanPath.substring(1);
      }

      final publicUrl = supabase.storage
          .from('fruits_images')
          .getPublicUrl(cleanPath);

      print('📁 Original Path: $rawImagePath');
      print('🔧 Cleaned Path: $cleanPath');
      print('🌐 Final Image URL: $publicUrl');

      return publicUrl;
    } catch (e) {
      print('❌ Error getting image URL for "$rawImagePath": $e');
      return 'https://via.placeholder.com/200?text=Error+Loading';
    }
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawImage = json['imageUrl']?.toString();

    // تحويل الريفيوهات
    List<ReviewModel> reviewList = [];
    if (json['reviews'] != null) {
      try {
        reviewList = List<ReviewModel>.from(
          (json['reviews'] as List).map((e) => ReviewModel.fromJson(e)),
        );
      } catch (e) {
        print('❌ Error parsing reviews: $e');
        reviewList = [];
      }
    }

    final avgRatingValue = getAvgRating(reviewList);

    return ProductModel(
      name: json['name']?.toString() ?? 'Unknown Product',
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      expirationsMonths: (json['expirationsMonths'] as num?)?.toInt() ?? 0,
      numberOfCalories: (json['numberOfCalories'] as num?)?.toInt() ?? 0,
      unitAmount: (json['unitAmount'] as num?)?.toInt() ?? 0,
      sellingCount: (json['sellingCount'] as num?)?.toDouble() ?? 0.0,
      reviews: reviewList,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isOrganic: json['isOrganic'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      avgRating: avgRatingValue,
      ratingCount: reviewList.length,
      imageUrl: getImageUrl(rawImage),
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      name: name,
      code: code,
      description: description,
      price: price,
      reviews: reviews.map((e) => e.toEntity()).toList(),
      expirationsMonths: expirationsMonths,
      numberOfCalories: numberOfCalories,
      unitAmount: unitAmount,
      isOrganic: isOrganic,
      isFeatured: isFeatured,
      imageUrl: imageUrl,
      avgRating: avgRating,
      ratingCount: ratingCount,
      sellingCount: sellingCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'description': description,
      'price': price,
      'isFeatured': isFeatured,
      'sellingCount': sellingCount,
      'imageUrl': imageUrl,
      'expirationsMonths': expirationsMonths,
      'isOrganic': isOrganic,
      'numberOfCalories': numberOfCalories,
      'avgRating': avgRating,
      'ratingCount': ratingCount,
      'unitAmount': unitAmount,
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'ProductModel(name: $name, code: $code, price: $price)';
  }
}
