import 'package:musix/core/models/spotify_models.dart';

class UserProfileModel {
  final String id;
  final String displayName;
  final String email;
  final String country;
  final List<ImageModel> images;
  final int followers;
  final String product;

  UserProfileModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.country,
    required this.images,
    required this.followers,
    required this.product,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      displayName: json['display_name'] ?? 'User',
      email: json['email'] ?? '',
      country: json['country'] ?? '',
      images: (json['images'] as List?)
              ?.map((e) => ImageModel.fromJson(e))
              .toList() ??
          [],
      followers: json['followers']?['total'] ?? 0,
      product: json['product'] ?? 'free',
    );
  }
}

