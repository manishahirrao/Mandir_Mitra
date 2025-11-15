class Chadhava {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double basePrice;
  final String category;
  final String deityName;
  final List<String> includedOfferings;
  final String? nextAvailableDate;
  final bool isSpecialOccasion;
  final String? occasion;
  final List<OfferingType> availableOfferings;
  final String? significance;
  final int estimatedDuration; // in hours
  final bool videoIncluded;
  final String? templeId;
  final String? templeName;

  Chadhava({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.basePrice,
    required this.category,
    required this.deityName,
    required this.includedOfferings,
    this.nextAvailableDate,
    this.isSpecialOccasion = false,
    this.occasion,
    required this.availableOfferings,
    this.significance,
    this.estimatedDuration = 24,
    this.videoIncluded = true,
    this.templeId,
    this.templeName,
  });

  factory Chadhava.fromJson(Map<String, dynamic> json) {
    return Chadhava(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      deityName: json['deityName'] ?? '',
      includedOfferings: List<String>.from(json['includedOfferings'] ?? []),
      nextAvailableDate: json['nextAvailableDate'],
      isSpecialOccasion: json['isSpecialOccasion'] ?? false,
      occasion: json['occasion'],
      availableOfferings: (json['availableOfferings'] as List?)
              ?.map((e) => OfferingType.fromJson(e))
              .toList() ??
          [],
      significance: json['significance'],
      estimatedDuration: json['estimatedDuration'] ?? 24,
      videoIncluded: json['videoIncluded'] ?? true,
      templeId: json['templeId'],
      templeName: json['templeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'basePrice': basePrice,
      'category': category,
      'deityName': deityName,
      'includedOfferings': includedOfferings,
      'nextAvailableDate': nextAvailableDate,
      'isSpecialOccasion': isSpecialOccasion,
      'occasion': occasion,
      'availableOfferings': availableOfferings.map((e) => e.toJson()).toList(),
      'significance': significance,
      'estimatedDuration': estimatedDuration,
      'videoIncluded': videoIncluded,
      'templeId': templeId,
      'templeName': templeName,
    };
  }
}

class OfferingType {
  final String id;
  final String name;
  final String icon;
  final double price;
  final bool isDefault;

  OfferingType({
    required this.id,
    required this.name,
    required this.icon,
    required this.price,
    this.isDefault = false,
  });

  factory OfferingType.fromJson(Map<String, dynamic> json) {
    return OfferingType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'price': price,
      'isDefault': isDefault,
    };
  }
}

class MultiTempleChadhava {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<TempleChadhava> temples;
  final double totalPrice;
  final String occasion;
  final bool isSpecial;

  MultiTempleChadhava({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.temples,
    required this.totalPrice,
    required this.occasion,
    this.isSpecial = true,
  });

  factory MultiTempleChadhava.fromJson(Map<String, dynamic> json) {
    return MultiTempleChadhava(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      temples: (json['temples'] as List?)
              ?.map((e) => TempleChadhava.fromJson(e))
              .toList() ??
          [],
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      occasion: json['occasion'] ?? '',
      isSpecial: json['isSpecial'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'temples': temples.map((e) => e.toJson()).toList(),
      'totalPrice': totalPrice,
      'occasion': occasion,
      'isSpecial': isSpecial,
    };
  }
}

class TempleChadhava {
  final String templeId;
  final String templeName;
  final String deityName;
  final String imageUrl;
  final double price;
  final bool isSelected;

  TempleChadhava({
    required this.templeId,
    required this.templeName,
    required this.deityName,
    required this.imageUrl,
    required this.price,
    this.isSelected = true,
  });

  factory TempleChadhava.fromJson(Map<String, dynamic> json) {
    return TempleChadhava(
      templeId: json['templeId'] ?? '',
      templeName: json['templeName'] ?? '',
      deityName: json['deityName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isSelected: json['isSelected'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'templeId': templeId,
      'templeName': templeName,
      'deityName': deityName,
      'imageUrl': imageUrl,
      'price': price,
      'isSelected': isSelected,
    };
  }

  TempleChadhava copyWith({bool? isSelected}) {
    return TempleChadhava(
      templeId: templeId,
      templeName: templeName,
      deityName: deityName,
      imageUrl: imageUrl,
      price: price,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
