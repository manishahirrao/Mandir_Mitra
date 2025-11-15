import 'package:flutter/foundation.dart';
import '../models/temple.dart';

class TempleProvider with ChangeNotifier {
  List<Temple> _allTemples = [];
  String _selectedCategory = 'All Temples';
  bool _isLoading = false;
  String? _error;
  List<Temple> _comparisonList = [];

  List<Temple> get allTemples => _allTemples;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Temple> get comparisonList => _comparisonList;

  List<Temple> get filteredTemples {
    if (_selectedCategory == 'All Temples') {
      return _allTemples;
    }
    return _allTemples
        .where((t) => t.category == _selectedCategory)
        .toList();
  }

  Temple? get featuredTemple {
    try {
      return _allTemples.firstWhere((t) => t.isFeatured);
    } catch (e) {
      return _allTemples.isNotEmpty ? _allTemples.first : null;
    }
  }

  List<String> get categories {
    final cats = _allTemples
        .where((t) => t.category != null)
        .map((t) => t.category!)
        .toSet()
        .toList();
    return ['All Temples', ...cats];
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadTemples() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _allTemples = _getMockTemples();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Temple? getTempleById(String id) {
    try {
      return _allTemples.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  void addToComparison(Temple temple) {
    if (!_comparisonList.any((t) => t.id == temple.id) && _comparisonList.length < 3) {
      _comparisonList.add(temple);
      notifyListeners();
    }
  }

  void removeFromComparison(Temple temple) {
    _comparisonList.removeWhere((t) => t.id == temple.id);
    notifyListeners();
  }

  void clearComparison() {
    _comparisonList.clear();
    notifyListeners();
  }

  List<Temple> _getMockTemples() {
    return [
      Temple(
        id: 't1',
        name: 'Grishneshwar Jyotirlinga',
        location: 'Aurangabad',
        city: 'Aurangabad',
        state: 'Maharashtra',
        address: 'Verul, Aurangabad, Maharashtra 431101',
        latitude: 20.0244,
        longitude: 75.1772,
        images: [
          'https://images.unsplash.com/photo-1582510003544-4d00b7f74220',
          'https://images.unsplash.com/photo-1548013146-72479768bada',
        ],
        overview: 'One of the 12 Jyotirlinga shrines dedicated to Lord Shiva',
        history: 'Ancient temple with rich history dating back centuries',
        significance: 'Last of the 12 Jyotirlingas mentioned in Shiva Purana',
        timings: '5:30 AM - 9:30 PM',
        holidays: 'Open all days',
        servicesOffered: ['Abhishek', 'Rudrabhishek', 'Chadhava', 'Aarti'],
        aashirwadBoxDetails: 'Prasad and blessings delivered',
        rating: 4.8,
        reviewCount: 1234,
        category: 'Jyotirlingas',
        presidingDeity: 'Lord Shiva',
        establishedYear: 1100,
        festivals: ['Mahashivratri', 'Shravan Month', 'Kartik Purnima'],
        dressCode: 'Traditional attire recommended',
        rules: [
          'Remove footwear before entering',
          'Photography not allowed inside sanctum',
          'Maintain silence in temple premises',
        ],
        hasLiveDarshan: true,
        liveDarshanSchedule: ['6:00 AM', '12:00 PM', '7:00 PM'],
        aartis: [
          TempleAarti(
            id: 'a1',
            name: 'Kakad Aarti',
            time: '5:30 AM',
            type: 'morning',
            sponsorPrice: 501,
            description: 'Morning aarti to wake up the deity',
          ),
          TempleAarti(
            id: 'a2',
            name: 'Madhyan Aarti',
            time: '12:00 PM',
            type: 'afternoon',
            sponsorPrice: 351,
            description: 'Afternoon aarti',
          ),
          TempleAarti(
            id: 'a3',
            name: 'Sandhya Aarti',
            time: '7:00 PM',
            type: 'evening',
            sponsorPrice: 751,
            description: 'Evening aarti with full rituals',
          ),
        ],
        howToReach: 'By Air: Aurangabad Airport (30 km)\nBy Rail: Aurangabad Railway Station\nBy Road: Well connected by state highways',
        nearbyAttractions: ['Ellora Caves', 'Daulatabad Fort', 'Bibi Ka Maqbara'],
        isFeatured: true,
      ),
      Temple(
        id: 't2',
        name: 'Ambabai Shaktipeeth',
        location: 'Kolhapur',
        city: 'Kolhapur',
        state: 'Maharashtra',
        address: 'Mahadwar Road, Kolhapur, Maharashtra 416012',
        latitude: 16.6945,
        longitude: 74.2233,
        images: [
          'https://images.unsplash.com/photo-1580477667995-2b94f01c9516',
        ],
        overview: 'Ancient Shaktipeeth temple dedicated to Goddess Mahalakshmi',
        history: 'One of the 51 Shakti Peethas',
        significance: 'Where the third eye of Goddess Sati fell',
        timings: '5:00 AM - 10:00 PM',
        holidays: 'Open all days',
        servicesOffered: ['Abhishek', 'Chadhava', 'Aarti', 'Kumkum Archana'],
        aashirwadBoxDetails: 'Prasad and kumkum delivered',
        rating: 4.9,
        reviewCount: 2156,
        category: 'Shaktipeeths',
        presidingDeity: 'Goddess Mahalakshmi',
        establishedYear: 700,
        festivals: ['Navratri', 'Diwali', 'Kirnotsav'],
        dressCode: 'Traditional attire required',
        rules: [
          'Men must remove shirts before entering',
          'Women in traditional saree/salwar',
          'No leather items allowed',
        ],
        hasLiveDarshan: true,
        liveDarshanSchedule: ['6:00 AM', '12:00 PM', '8:00 PM'],
        aartis: [
          TempleAarti(
            id: 'a4',
            name: 'Kakad Aarti',
            time: '5:00 AM',
            type: 'morning',
            sponsorPrice: 551,
            description: 'Morning aarti',
          ),
          TempleAarti(
            id: 'a5',
            name: 'Sandhya Aarti',
            time: '8:00 PM',
            type: 'evening',
            sponsorPrice: 851,
            description: 'Grand evening aarti',
          ),
        ],
        howToReach: 'By Air: Kolhapur Airport\nBy Rail: Kolhapur Railway Station (2 km)\nBy Road: NH4 connects to major cities',
        nearbyAttractions: ['Panhala Fort', 'Rankala Lake', 'New Palace'],
        isFeatured: false,
      ),
      Temple(
        id: 't3',
        name: 'Khatu Shyam Temple',
        location: 'Sikar',
        city: 'Khatu',
        state: 'Rajasthan',
        address: 'Khatu, Sikar District, Rajasthan 332602',
        latitude: 27.6094,
        longitude: 75.0047,
        images: [
          'https://images.unsplash.com/photo-1609920658906-8223bd289001',
        ],
        overview: 'Famous temple dedicated to Barbarika (Khatu Shyam)',
        history: 'Temple built in 1027 AD',
        significance: 'Khatu Shyam is believed to be an incarnation of Lord Krishna',
        timings: '4:00 AM - 11:00 PM',
        holidays: 'Open all days',
        servicesOffered: ['Abhishek', 'Chadhava', 'Aarti', 'Bhog'],
        aashirwadBoxDetails: 'Prasad delivered',
        rating: 4.7,
        reviewCount: 987,
        category: 'Popular',
        presidingDeity: 'Khatu Shyam (Barbarika)',
        establishedYear: 1027,
        festivals: ['Phalguna Mela', 'Kartik Ekadashi', 'Janmashtami'],
        dressCode: 'Modest clothing',
        rules: [
          'Remove footwear',
          'No photography inside',
          'Maintain cleanliness',
        ],
        hasLiveDarshan: false,
        aartis: [
          TempleAarti(
            id: 'a6',
            name: 'Mangla Aarti',
            time: '4:30 AM',
            type: 'morning',
            sponsorPrice: 451,
            description: 'Early morning aarti',
          ),
          TempleAarti(
            id: 'a7',
            name: 'Sandhya Aarti',
            time: '7:30 PM',
            type: 'evening',
            sponsorPrice: 651,
            description: 'Evening aarti',
          ),
        ],
        howToReach: 'By Air: Jaipur Airport (80 km)\nBy Rail: Ringas Railway Station (17 km)\nBy Road: Well connected by roads',
        nearbyAttractions: ['Salasar Balaji', 'Jeenmata Temple', 'Harsh Nath Temple'],
        isFeatured: false,
      ),
      Temple(
        id: 't4',
        name: 'Badrinath Temple',
        location: 'Chamoli',
        city: 'Badrinath',
        state: 'Uttarakhand',
        address: 'Badrinath, Chamoli District, Uttarakhand 246422',
        latitude: 30.7433,
        longitude: 79.4938,
        images: [
          'https://images.unsplash.com/photo-1605649487212-47bdab064df7',
        ],
        overview: 'One of the Char Dham pilgrimage sites',
        history: 'Ancient temple established by Adi Shankaracharya',
        significance: 'Dedicated to Lord Vishnu in his Badrinarayan form',
        timings: '4:30 AM - 9:00 PM (Summer), Closed in winter',
        holidays: 'Closed November to April',
        servicesOffered: ['Abhishek', 'Chadhava', 'Aarti', 'Special Puja'],
        aashirwadBoxDetails: 'Prasad and tulsi delivered',
        rating: 4.9,
        reviewCount: 3421,
        category: 'Char Dham',
        presidingDeity: 'Lord Badrinarayan (Vishnu)',
        establishedYear: 800,
        festivals: ['Badri-Kedar Festival', 'Mata Murti Ka Mela'],
        dressCode: 'Warm traditional clothing',
        rules: [
          'Remove footwear',
          'No leather items',
          'Follow queue system',
        ],
        hasLiveDarshan: true,
        liveDarshanSchedule: ['6:00 AM', '12:00 PM', '7:00 PM'],
        aartis: [
          TempleAarti(
            id: 'a8',
            name: 'Abhishek Aarti',
            time: '4:30 AM',
            type: 'morning',
            sponsorPrice: 1001,
            description: 'Morning abhishek and aarti',
          ),
          TempleAarti(
            id: 'a9',
            name: 'Sandhya Aarti',
            time: '7:00 PM',
            type: 'evening',
            sponsorPrice: 1251,
            description: 'Evening aarti',
          ),
        ],
        howToReach: 'By Air: Jolly Grant Airport, Dehradun (317 km)\nBy Rail: Rishikesh (294 km)\nBy Road: Motorable road from Rishikesh',
        nearbyAttractions: ['Mana Village', 'Vasudhara Falls', 'Tapt Kund'],
        isFeatured: false,
      ),
    ];
  }

  List<TemplePuja> getTemplePujas(String templeId) {
    // Mock puja data
    return [
      TemplePuja(
        id: 'p1',
        name: 'Rudrabhishek',
        templeId: templeId,
        description: 'Complete Rudrabhishek with 11 items',
        durationMinutes: 90,
        benefits: ['Peace of mind', 'Removal of obstacles', 'Spiritual growth'],
        nextAvailableSlot: '2025-11-16 06:00 AM',
        packages: {
          'Basic': 501,
          'Standard': 1001,
          'Premium': 2100,
        },
        includedItems: ['Milk', 'Honey', 'Ghee', 'Flowers', 'Bilva leaves'],
      ),
      TemplePuja(
        id: 'p2',
        name: 'Abhishek',
        templeId: templeId,
        description: 'Traditional abhishek ceremony',
        durationMinutes: 45,
        benefits: ['Blessings', 'Prosperity', 'Health'],
        nextAvailableSlot: '2025-11-16 07:00 AM',
        packages: {
          'Basic': 251,
          'Standard': 501,
        },
        includedItems: ['Water', 'Milk', 'Flowers'],
      ),
    ];
  }
}
