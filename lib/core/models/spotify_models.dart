class ArtistModel {
  final String id;
  final String name;
  final List<ImageModel> images;
  final int? followers;
  final List<String> genres;
  final int? popularity;

  ArtistModel({
    required this.id,
    required this.name,
    this.images = const [],
    this.followers,
    this.genres = const [],
    this.popularity,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      images: (json['images'] as List?)
              ?.map((e) => ImageModel.fromJson(e))
              .toList() ??
          [],
      followers: json['followers']?['total'] as int?,
      genres: (json['genres'] as List?)?.map((e) => e.toString()).toList() ?? [],
      popularity: json['popularity'] as int?,
    );
  }
}

class ImageModel {
  final String url;
  final int? height;
  final int? width;

  ImageModel({required this.url, this.height, this.width});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url'] ?? '',
      height: json['height'],
      width: json['width'],
    );
  }
}

class AlbumModel {
  final String id;
  final String name;
  final List<ImageModel> images;
  final List<ArtistModel>? artists;
  final String? releaseDate;
  final List<TrackModel> tracks;

  AlbumModel({
    required this.id,
    required this.name,
    required this.images,
    this.artists,
    this.releaseDate,
    this.tracks = const [],
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      images: (json['images'] as List?)
              ?.map((e) => ImageModel.fromJson(e))
              .toList() ??
          [],
      artists: (json['artists'] as List?)
          ?.map((e) => ArtistModel.fromJson(e))
          .toList(),
      releaseDate: json['release_date'],
      tracks: (json['tracks']?['items'] as List?)
              ?.map((e) => TrackModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TrackModel {
  final String id;
  final String name;
  final String uri;
  final int durationMs;
  final AlbumModel? album;
  final List<ArtistModel> artists;

  TrackModel({
    required this.id,
    required this.name,
    required this.uri,
    required this.durationMs,
    this.album,
    required this.artists,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      uri: json['uri'] ?? '',
      durationMs: json['duration_ms'] ?? 0,
      album: json['album'] != null ? AlbumModel.fromJson(json['album']) : null,
      artists: (json['artists'] as List?)
              ?.map((e) => ArtistModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PlaylistModel {
  final String id;
  final String name;
  final String? description;
  final List<ImageModel> images;
  final String ownerName;

  PlaylistModel({
    required this.id,
    required this.name,
    this.description,
    required this.images,
    required this.ownerName,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      images: (json['images'] as List?)
              ?.map((e) => ImageModel.fromJson(e))
              .toList() ??
          [],
      ownerName: json['owner']?['display_name'] ?? 'Spotify',
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final List<ImageModel> icons;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icons,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icons: (json['icons'] as List?)
              ?.map((e) => ImageModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
