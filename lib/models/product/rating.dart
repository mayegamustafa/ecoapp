import 'dart:convert';

import 'package:e_com/_core/_core.dart';

class Rating {
  Rating({
    required this.totalReview,
    required this.avgRating,
    required this.review,
  });

  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      totalReview: map.parseInt('total_review'),
      avgRating: map.parseDouble('avg_rating'),
      review: map['review'] is! List
          ? []
          : List<Review>.from(map['review']?.map((x) => Review.fromMap(x))),
    );
  }

  final double avgRating;
  final List<Review> review;
  final int totalReview;

  Map<String, dynamic> toMap() {
    return {
      'total_review': totalReview,
      'avg_rating': avgRating,
      'review': review.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

class Review {
  Review({
    required this.user,
    required this.profile,
    required this.rating,
    required this.review,
  });

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      profile: map['profile'] ?? '',
      rating: intFromAny(map['rating']),
      review: map['review'] ?? '',
      user: map['user'] ?? '',
    );
  }

  final String profile;
  final int rating;
  final String review;
  final String user;

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'profile': profile,
      'rating': rating,
      'review': review,
    };
  }

  String toJson() => json.encode(toMap());
}

class ReviewPostData {
  ReviewPostData({
    required this.uid,
    required this.review,
    required this.rate,
  });

  final int rate;
  final String review;
  final String uid;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'rate': rate});
    result.addAll({'review': review});
    result.addAll({'product_uid': uid});

    return result;
  }

  ReviewPostData copyWith({
    int? rate,
    String? review,
    String? uid,
  }) {
    return ReviewPostData(
      rate: rate ?? this.rate,
      review: review ?? this.review,
      uid: uid ?? this.uid,
    );
  }
}
