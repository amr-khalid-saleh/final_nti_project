import 'package:musix/core/models/spotify_models.dart';

class UserProfileModel {
  final String id;
  final String displayName;
  final String email;
  final String country;
  final List<ImageModel> images;
  final int followers;
  final int followingCount;
  final int playlistCount;
  final String product;

  UserProfileModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.country,
    required this.images,
    required this.followers,
    this.followingCount = 0,
    this.playlistCount = 0,
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

  UserProfileModel copyWith({
    int? followingCount,
    int? playlistCount,
  }) {
    return UserProfileModel(
      id: id,
      displayName: displayName,
      email: email,
      country: country,
      images: images,
      followers: followers,
      followingCount: followingCount ?? this.followingCount,
      playlistCount: playlistCount ?? this.playlistCount,
      product: product,
    );
  }
}

