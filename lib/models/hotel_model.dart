class Hotel {
  final String id;
  final String name;
  final String location;
  final String country;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final String imagePath;
  final String description;
  final List<String> facilities;
  final bool isFavorite;
  final String? discountTag;

  const Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.country,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.imagePath,
    required this.description,
    required this.facilities,
    this.isFavorite = false,
    this.discountTag,
  });

  Hotel copyWith({
    String? id,
    String? name,
    String? location,
    String? country,
    double? rating,
    int? reviewCount,
    double? pricePerNight,
    String? imagePath,
    String? description,
    List<String>? facilities,
    bool? isFavorite,
    String? discountTag,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      country: country ?? this.country,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      facilities: facilities ?? this.facilities,
      isFavorite: isFavorite ?? this.isFavorite,
      discountTag: discountTag ?? this.discountTag,
    );
  }
}
