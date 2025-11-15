import 'package:flutter/foundation.dart';
import '../models/chadhava.dart';

class ChadhavaProvider with ChangeNotifier {
  List<Chadhava> _allChadhavas = [];
  List<MultiTempleChadhava> _multiTempleChadhavas = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String? _error;

  List<Chadhava> get allChadhavas => _allChadhavas;
  List<MultiTempleChadhava> get multiTempleChadhavas => _multiTempleChadhavas;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Chadhava> get filteredChadhavas {
    if (_selectedCategory == 'All') {
      return _allChadhavas;
    }
    return _allChadhavas
        .where((c) => c.category == _selectedCategory)
        .toList();
  }

  List<String> get categories {
    final cats = _allChadhavas.map((c) => c.category).toSet().toList();
    return ['All', ...cats];
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadChadhavas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _allChadhavas = _getMockChadhavas();
      _multiTempleChadhavas = _getMockMultiTempleChadhavas();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Chadhava> _getMockChadhavas() {
    return [
      // Daily Deity Chadhava
      Chadhava(
        id: '1',
        name: 'Maa Kali Daily Chadhava',
        description: 'Daily offering to Maa Kali for protection and strength',
        imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1b1b1',
        basePrice: 51,
        category: 'Daily Deity',
        deityName: 'Maa Kali',
        includedOfferings: ['Flowers', 'Incense', 'Diya'],
        availableOfferings: [
          OfferingType(id: '1', name: 'Flowers', icon: '🌸', price: 0, isDefault: true),
          OfferingType(id: '2', name: 'Honey', icon: '🍯', price: 21),
          OfferingType(id: '3', name: 'Diya', icon: '🕯️', price: 11, isDefault: true),
          OfferingType(id: '4', name: 'Coconut', icon: '🥥', price: 31),
        ],
      ),
      Chadhava(
        id: '2',
        name: 'Shri Ganesh Daily Chadhava',
        description: 'Daily offering to Lord Ganesh for removing obstacles',
        imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1b1b1',
        basePrice: 51,
        category: 'Daily Deity',
        deityName: 'Shri Ganesh',
        includedOfferings: ['Modak', 'Flowers', 'Durva Grass'],
        availableOfferings: [
          OfferingType(id: '1', name: 'Flowers', icon: '🌸', price: 0, isDefault: true),
          OfferingType(id: '2', name: 'Modak', icon: '🍬', price: 51),
          OfferingType(id: '3', name: 'Diya', icon: '🕯️', price: 11),
          OfferingType(id: '4', name: 'Coconut', icon: '🥥', price: 31, isDefault: true),
        ],
      ),
      // Ekadashi Special
      Chadhava(
        id: '3',
        name: 'Utpanna Ekadashi Chadhava',
        description: 'Special offering on Utpanna Ekadashi',
        imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1b1b1',
        basePrice: 151,
        category: 'Ekadashi',
        deityName: 'Lord Vishnu',
        includedOfferings: ['Tulsi', 'Fruits', 'Flowers', 'Panchamrit'],
        isSpecialOccasion: true,
        occasion: 'Utpanna Ekadashi',
        nextAvailableDate: '2025-11-20',
        significance: 'First Ekadashi of the year, highly auspicious',
        availableOfferings: [
          OfferingType(id: '1', name: 'Flowers', icon: '🌸', price: 0, isDefault: true),
          OfferingType(id: '2', name: 'Fruits', icon: '🍎', price: 101),
          OfferingType(id: '3', name: 'Tulsi', icon: '🌿', price: 21, isDefault: true),
          OfferingType(id: '4', name: 'Panchamrit', icon: '🥛', price: 51, isDefault: true),
        ],
      ),
      // Gauseva
      Chadhava(
        id: '4',
        name: 'Gauseva Chadhava',
        description: 'Serve and feed holy cows',
        imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1b1b1',
        basePrice: 101,
        category: 'Gauseva',
        deityName: 'Gaumata',
        includedOfferings: ['Green Fodder', 'Jaggery', 'Grains'],
        availableOfferings: [
          OfferingType(id: '1', name: 'Green Fodder', icon: '🌾', price: 0, isDefault: true),
          OfferingType(id: '2', name: 'Jaggery', icon: '🍯', price: 51),
          OfferingType(id: '3', name: 'Grains', icon: '🌾', price: 101, isDefault: true),
        ],
      ),
      // Life Benefit - Success
      Chadhava(
        id: '5',
        name: 'Career Success Chadhava',
        description: 'Special offering for career growth and success',
        imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1b1b1',
        basePrice: 251,
        category: 'Success & Growth',
        deityName: 'Lord Ganesh & Maa Lakshmi',
        includedOfferings: ['Yellow Flowers', 'Turmeric', 'Saffron', 'Sweets'],
        availableOfferings: [
          OfferingType(id: '1', name: 'Flowers', icon: '🌸', price: 0, isDefault: true),
          OfferingType(id: '2', name: 'Sweets', icon: '🍬', price: 101, isDefault: true),
          OfferingType(id: '3', name: 'Fruits', icon: '🍎', price: 151),
          OfferingType(id: '4', name: 'Silver Coin', icon: '🪙', price: 501),
        ],
      ),
      // Health & Healing
      Chadhava(
        id: '6',
        name: 'Health & Healing Chadhava',
        description: 'Offering for good health and recovery',
        imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1b1b1',
        basePrice: 201,
        category: 'Health & Healing',
        deityName: 'Dhanvantari',
        includedOfferings: ['Medicinal Herbs', 'Flowers', 'Honey'],
        availableOfferings: [
          OfferingType(id: '1', name: 'Flowers', icon: '🌸', price: 0, isDefault: true),
          OfferingType(id: '2', name: 'Honey', icon: '🍯', price: 51, isDefault: true),
          OfferingType(id: '3', name: 'Fruits', icon: '🍎', price: 101),
          OfferingType(id: '4', name: 'Herbs', icon: '🌿', price: 151),
        ],
      ),
    ];
  }

  List<MultiTempleChadhava> _getMockMultiTempleChadhavas() {
    return [
      MultiTempleChadhava(
        id: 'mt1',
        name: 'Panch Devi-Devta 5 Temple Chadhava',
        description: 'Praise 5 deities at 5 ancient temples',
        imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1b1b1',
        occasion: 'Saturday Maha Ekadashi',
        totalPrice: 1151,
        temples: [
          TempleChadhava(
            templeId: 't1',
            templeName: 'Vishnu Pad Temple',
            deityName: 'Lord Vishnu',
            imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1b1b1',
            price: 251,
          ),
          TempleChadhava(
            templeId: 't2',
            templeName: 'Narsingh Temple',
            deityName: 'Lord Narsingh',
            imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1b1b1',
            price: 201,
          ),
          TempleChadhava(
            templeId: 't3',
            templeName: 'Khatu Shyam Temple',
            deityName: 'Khatu Shyam',
            imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1b1b1',
            price: 251,
          ),
          TempleChadhava(
            templeId: 't4',
            templeName: 'Ambabai Shaktipeeth',
            deityName: 'Maa Ambabai',
            imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1b1b1',
            price: 251,
          ),
          TempleChadhava(
            templeId: 't5',
            templeName: 'Navgrah Shani Temple',
            deityName: 'Shani Dev',
            imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1b1b1',
            price: 197,
          ),
        ],
      ),
    ];
  }

  Chadhava? getChadhavaById(String id) {
    try {
      return _allChadhavas.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  MultiTempleChadhava? getMultiTempleChadhavaById(String id) {
    try {
      return _multiTempleChadhavas.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
