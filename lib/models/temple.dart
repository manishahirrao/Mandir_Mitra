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
  final double rating;
  final int reviewCount;
  final String? category;
  final String? presidingDeity;
  final int? establishedYear;
  final List<String>? festivals;
  final String? dressCode;
  final List<String>? rules;
  final bool hasLiveDarshan;
  final List<String>? liveDarshanSchedule;
  final List<TempleAarti>? aartis;
  final String? howToReach;
  final List<String>? nearbyAttractions;
  final bool isFeatured;
  final List<String>? videoGallery;
  final String? virtualTourUrl;

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
    this.rating = 5.0,
    this.reviewCount = 0,
    this.category,
    this.presidingDeity,
    this.establishedYear,
    this.festivals,
    this.dressCode,
    this.rules,
    this.hasLiveDarshan = false,
    this.liveDarshanSchedule,
    this.aartis,
    this.howToReach,
    this.nearbyAttractions,
    this.isFeatured = false,
    this.videoGallery,
    this.virtualTourUrl,
  });

  String get fullLocation => '$city, $state';

  factory Temple.fromJson(Map<String, dynamic> json) {
    return Temple(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      overview: json['overview'] ?? '',
      history: json['history'] ?? '',
      significance: json['significance'] ?? '',
      timings: json['timings'] ?? '',
      holidays: json['holidays'] ?? '',
      servicesOffered: List<String>.from(json['servicesOffered'] ?? []),
      aashirwadBoxDetails: json['aashirwadBoxDetails'] ?? '',
      rating: (json['rating'] ?? 5.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      category: json['category'],
      presidingDeity: json['presidingDeity'],
      establishedYear: json['establishedYear'],
      festivals: json['festivals'] != null ? List<String>.from(json['festivals']) : null,
      dressCode: json['dressCode'],
      rules: json['rules'] != null ? List<String>.from(json['rules']) : null,
      hasLiveDarshan: json['hasLiveDarshan'] ?? false,
      liveDarshanSchedule: json['liveDarshanSchedule'] != null 
          ? List<String>.from(json['liveDarshanSchedule']) 
          : null,
      aartis: json['aartis'] != null
          ? (json['aartis'] as List).map((e) => TempleAarti.fromJson(e)).toList()
          : null,
      howToReach: json['howToReach'],
      nearbyAttractions: json['nearbyAttractions'] != null 
          ? List<String>.from(json['nearbyAttractions']) 
          : null,
      isFeatured: json['isFeatured'] ?? false,
      videoGallery: json['videoGallery'] != null 
          ? List<String>.from(json['videoGallery']) 
          : null,
      virtualTourUrl: json['virtualTourUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'city': city,
      'state': state,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'overview': overview,
      'history': history,
      'significance': significance,
      'timings': timings,
      'holidays': holidays,
      'servicesOffered': servicesOffered,
      'aashirwadBoxDetails': aashirwadBoxDetails,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category,
      'presidingDeity': presidingDeity,
      'establishedYear': establishedYear,
      'festivals': festivals,
      'dressCode': dressCode,
      'rules': rules,
      'hasLiveDarshan': hasLiveDarshan,
      'liveDarshanSchedule': liveDarshanSchedule,
      'aartis': aartis?.map((e) => e.toJson()).toList(),
      'howToReach': howToReach,
      'nearbyAttractions': nearbyAttractions,
      'isFeatured': isFeatured,
      'videoGallery': videoGallery,
      'virtualTourUrl': virtualTourUrl,
    };
  }
}

class TempleAarti {
  final String id;
  final String name;
  final String time;
  final String type; // morning, afternoon, evening
  final double sponsorPrice;
  final String description;
  final List<String>? videoUrls;

  TempleAarti({
    required this.id,
    required this.name,
    required this.time,
    required this.type,
    required this.sponsorPrice,
    required this.description,
    this.videoUrls,
  });

  factory TempleAarti.fromJson(Map<String, dynamic> json) {
    return TempleAarti(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? '',
      sponsorPrice: (json['sponsorPrice'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      videoUrls: json['videoUrls'] != null 
          ? List<String>.from(json['videoUrls']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'type': type,
      'sponsorPrice': sponsorPrice,
      'description': description,
      'videoUrls': videoUrls,
    };
  }
}

class TemplePuja {
  final String id;
  final String name;
  final String templeId;
  final String description;
  final int durationMinutes;
  final List<String> benefits;
  final String? nextAvailableSlot;
  final Map<String, double> packages; // package name -> price
  final List<String> includedItems;

  TemplePuja({
    required this.id,
    required this.name,
    required this.templeId,
    required this.description,
    required this.durationMinutes,
    required this.benefits,
    this.nextAvailableSlot,
    required this.packages,
    required this.includedItems,
  });

  factory TemplePuja.fromJson(Map<String, dynamic> json) {
    return TemplePuja(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      templeId: json['templeId'] ?? '',
      description: json['description'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 0,
      benefits: List<String>.from(json['benefits'] ?? []),
      nextAvailableSlot: json['nextAvailableSlot'],
      packages: Map<String, double>.from(json['packages'] ?? {}),
      includedItems: List<String>.from(json['includedItems'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'templeId': templeId,
      'description': description,
      'durationMinutes': durationMinutes,
      'benefits': benefits,
      'nextAvailableSlot': nextAvailableSlot,
      'packages': packages,
      'includedItems': includedItems,
    };
  }
}
