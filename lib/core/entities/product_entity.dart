import 'package:equatable/equatable.dart';
import 'review_entity.dart';

class ProductEntity extends Equatable {
  final String name;
  final String code;
  final String description;
  final num price;
  final bool isFeatured;
  final String? imageUrl;
  final int expirationsMonths;
  final bool isOrganic;
  final int numberOfCalories;
  final int unitAmount;
  final num avgRating;
  final num ratingCount;
  final List<ReviewEntity> reviews;
  final num sellingCount;

  const ProductEntity({
    required this.name,
    required this.code,
    required this.description,
    required this.price,
    required this.reviews,
    required this.expirationsMonths,
    required this.numberOfCalories,
    required this.unitAmount,
    this.isOrganic = false,
    required this.isFeatured,
    this.imageUrl,
    this.avgRating = 0,
    this.ratingCount = 0,
    required this.sellingCount,
  });

  @override
  List<Object?> get props => [
    code,
    name,
    price,
    unitAmount,
    imageUrl,
    isOrganic,
    isFeatured,
  ]; // كل الخصائص المهمة

  @override
  bool? get stringify => true;
}
