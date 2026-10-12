import '../models/hotel_model.dart';

class MockData {
  static const Hotel baliExotica = Hotel(
    id: 'bali-exotica',
    name: 'Bali Exotica',
    location: 'Indonesia, Bali',
    country: 'Indonesia',
    rating: 4.8,
    reviewCount: 1200,
    pricePerNight: 220,
    imagePath: 'assets/images/bali_exotica.jpg',
    description:
        'Experience luxury and comfort at Bali Exotica, where modern amenities meet breathtaking views of the ocean. Perfect for couples, families and solo travelers.',
    facilities: [
      'Pool',
      'Wifi',
      'Ocean View',
      'Breakfast',
      'Spa',
      'Gym',
      'Parking',
      'Restaurant'
    ],
    isFavorite: true,
  );

  static const List<Hotel> recommendedHotels = [
    baliExotica,
    Hotel(
      id: 'mountain-villa',
      name: 'Alpine Crest Villa',
      location: 'Valais, Switzerland',
      country: 'Switzerland',
      rating: 4.9,
      reviewCount: 850,
      pricePerNight: 310,
      imagePath: 'assets/images/mountain_dest.jpg',
      description:
          'Panoramic mountain views with serene alpine air and private sauna facilities.',
      facilities: ['Wifi', 'Spa', 'Gym', 'Breakfast'],
      isFavorite: false,
    ),
    Hotel(
      id: 'sunset-ocean',
      name: 'Sunset Ocean Resort',
      location: 'Male, Maldives',
      country: 'Maldives',
      rating: 4.7,
      reviewCount: 940,
      pricePerNight: 280,
      imagePath: 'assets/images/beach_dest.jpg',
      description:
          'Step directly into crystal waters from your private deck at this luxury overwater resort.',
      facilities: ['Pool', 'Wifi', 'Ocean View', 'Breakfast', 'Spa'],
      isFavorite: false,
    ),
  ];

  static const List<Hotel> flashDeals = [
    Hotel(
      id: 'flash-deal-1',
      name: 'Grand Sunset Haven',
      location: 'Phuket, Thailand',
      country: 'Thailand',
      rating: 4.8,
      reviewCount: 510,
      pricePerNight: 150,
      imagePath: 'assets/images/flash_deal_hotel.jpg',
      description: 'Exclusive flash discount on luxury villas for this week.',
      facilities: ['Pool', 'Wifi', 'Breakfast', 'Restaurant'],
      discountTag: 'Up to 50% Off',
    ),
    Hotel(
      id: 'flash-deal-2',
      name: 'Azure Beach Suites',
      location: 'Bali, Indonesia',
      country: 'Indonesia',
      rating: 4.6,
      reviewCount: 380,
      pricePerNight: 120,
      imagePath: 'assets/images/beach_dest.jpg',
      description: 'Relaxed beachfront stay with complimentary spa sessions.',
      facilities: ['Pool', 'Wifi', 'Spa'],
      discountTag: '30% Off',
    ),
  ];
}
