import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String name;
  final String image;
  final num rating;
  final String date;
  final String reviewDescription;

  const ReviewEntity({
    required this.name,
    required this.image,
    required this.rating,
    required this.date,
    required this.reviewDescription,
  });

  @override
  List<Object?> get props => [name, date, rating];
}
