class Temple {
  final String id;
  final String name;
  final String location;
  final String city;
  final String state;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> images;
  final String overview;
  final String history;
  final String significance;
  final String timings;
  final String holidays;
  final List<String> servicesOffered;
  final String aashirwadBoxDetails;
  final int rating;
  final int reviewCount;

  Temple({
    required this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.state,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.overview,
    required this.history,
    required this.significance,
    required this.timings,
    required this.holidays,
    required this.servicesOffered,
    required this.aashirwadBoxDetails,
    this.rating = 5,
    this.reviewCount = 0,
  });

  String get fullLocation => '$city, $state';
}
