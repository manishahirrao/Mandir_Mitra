import 'package:flutter/foundation.dart';
import '../models/blog_post.dart';

class BlogProvider with ChangeNotifier {
  final List<BlogPost> _posts = [
    BlogPost(
      id: '1',
      title: 'Understanding the Significance of Maa Kali Puja',
      excerpt: 'Discover the deep spiritual meaning behind Maa Kali worship and how it can transform your life with divine protection and strength.',
      content: '''Maa Kali is one of the most powerful manifestations of the Divine Mother in Hindu tradition. Her worship holds profound significance for devotees seeking protection, strength, and spiritual transformation.

The Symbolism of Maa Kali
Maa Kali's fierce form represents the destruction of ego and negative forces. Her dark complexion symbolizes the infinite void from which all creation emerges and into which it dissolves.

Benefits of Kali Puja
Regular worship of Maa Kali brings protection from negative energies, removes obstacles, grants courage and strength, and accelerates spiritual growth.

How to Perform Kali Puja
The puja typically involves offering red flowers, lighting lamps, chanting mantras, and making offerings of sweets and fruits. It's best performed on Tuesdays or during Kali Puja festival.''',
      author: 'Pandit Rajesh Sharma',
      authorAvatar: 'https://i.pravatar.cc/150?img=12',
      date: DateTime.now().subtract(const Duration(days: 2)),
      imageUrl: 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220',
      category: 'Rituals Explained',
      readTime: 5,
    ),
    BlogPost(
      id: '2',
      title: 'How to Prepare for Your Ritual: Step-by-Step Guide',
      excerpt: 'A comprehensive guide to preparing yourself mentally, physically, and spiritually before participating in any Hindu ritual or puja.',
      content: '''Proper preparation enhances the spiritual benefits of any ritual. Here's your complete guide to preparing for a meaningful puja experience.

Mental Preparation
Begin with a calm mind. Meditate for 10-15 minutes before the ritual. Set clear intentions for what you wish to achieve through the puja.

Physical Preparation
Take a bath and wear clean, preferably traditional clothes. Keep your puja space clean and organized. Gather all necessary items beforehand.

Spiritual Preparation
Fast or eat light vegetarian food before the ritual. Chant preparatory mantras. Maintain a positive and devotional attitude throughout.''',
      author: 'Dr. Meera Iyer',
      authorAvatar: 'https://i.pravatar.cc/150?img=45',
      date: DateTime.now().subtract(const Duration(days: 5)),
      imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1c1c1',
      category: 'Spiritual Guidance',
      readTime: 7,
    ),
    BlogPost(
      id: '3',
      title: 'The Power of Aashirwad Boxes: Connecting Spiritually',
      excerpt: 'Learn how our specially curated Aashirwad Boxes bring temple blessings directly to your home and strengthen your spiritual connection.',
      content: '''The Aashirwad Box is more than just prasad delivery - it's a sacred connection between the temple, the deity, and your home.

What Makes It Special
Each item in the Aashirwad Box is energized during your ritual. The prasad carries the divine vibrations of the ceremony performed in your name.

How to Use Your Aashirwad Box
Receive it with reverence, offer it to your home deity first, consume prasad with family, use kumkum and vibhuti in daily worship, and keep the blessing card in your puja room.

The Spiritual Science
Ancient texts describe how blessed items carry positive energy that can transform the atmosphere of your home and bring peace to your family.''',
      author: 'Swami Anand Das',
      authorAvatar: 'https://i.pravatar.cc/150?img=33',
      date: DateTime.now().subtract(const Duration(days: 8)),
      imageUrl: 'https://images.unsplash.com/photo-1609619385002-f40f5e5c73b0',
      category: 'Spiritual Guidance',
      readTime: 6,
    ),
    BlogPost(
      id: '4',
      title: 'Astrology and Rituals: How to Resolve Doshas',
      excerpt: 'Understand how specific rituals can help mitigate planetary doshas and bring harmony to your life according to Vedic astrology.',
      content: '''Vedic astrology identifies various doshas (afflictions) in one's birth chart that can cause challenges. Specific rituals can help balance these energies.

Common Doshas and Their Remedies
Mangal Dosha: Perform Mangal Shanti Puja. Shani Dosha: Conduct Shani Puja on Saturdays. Kaal Sarp Dosha: Perform Kaal Sarp Dosh Nivaran Puja. Pitra Dosha: Conduct Pitra Shanti rituals.

How Rituals Work
Rituals create positive vibrations that counteract negative planetary influences. They invoke divine grace to overcome karmic obstacles.

Choosing the Right Ritual
Consult with an experienced astrologer to identify your specific doshas and recommend appropriate remedial rituals.''',
      author: 'Acharya Vikram Singh',
      authorAvatar: 'https://i.pravatar.cc/150?img=51',
      date: DateTime.now().subtract(const Duration(days: 12)),
      imageUrl: 'https://images.unsplash.com/photo-1532619675605-1ede6c2ed2b0',
      category: 'Astrology',
      readTime: 8,
    ),
    BlogPost(
      id: '5',
      title: 'Behind the Scenes: Preparing for Your Ritual',
      excerpt: 'Take a glimpse into the meticulous preparation that goes into every ritual performed at our partner temples.',
      content: '''Every ritual we facilitate involves careful planning and preparation to ensure authenticity and spiritual efficacy.

Temple Coordination
We work closely with temple authorities to schedule your ritual at auspicious times. Priests are briefed about your specific requirements and intentions.

Ritual Preparation
Sacred items are procured fresh. The ritual space is purified. All necessary materials are arranged according to traditional guidelines.

Quality Assurance
Our team ensures that every aspect of the ritual follows authentic Vedic procedures. We verify that all mantras are chanted correctly and all offerings are made properly.

Live Streaming Setup
Professional cameras are positioned to give you the best view. Audio equipment ensures clear mantra recitation. Backup systems guarantee uninterrupted streaming.''',
      author: 'Mandir Mitra Team',
      authorAvatar: 'https://i.pravatar.cc/150?img=60',
      date: DateTime.now().subtract(const Duration(days: 15)),
      imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1c1c6',
      category: 'Temple Stories',
      readTime: 6,
    ),
    BlogPost(
      id: '6',
      title: 'Temple Offerings for Better Life Outcomes',
      excerpt: 'Explore how different temple offerings and rituals can help you achieve specific life goals and overcome challenges.',
      content: '''Different deities and rituals are associated with specific life aspects. Understanding this can help you choose the right offerings.

For Career Success
Worship Lord Ganesha for obstacle removal. Offer prayers to Goddess Saraswati for knowledge and skills. Perform Lakshmi Puja for prosperity.

For Health and Wellness
Conduct Mahamrityunjaya Jaap for healing. Offer prayers to Dhanvantari, the deity of medicine. Perform Ayush Homam for longevity.

For Relationships
Worship Lord Shiva and Parvati for marital harmony. Perform Swayamvara Parvati Puja for finding a life partner. Offer prayers to Radha Krishna for love and devotion.

For Spiritual Growth
Regular meditation and mantra chanting. Participate in temple rituals. Study sacred texts and practice selfless service.''',
      author: 'Pandit Suresh Mishra',
      authorAvatar: 'https://i.pravatar.cc/150?img=13',
      date: DateTime.now().subtract(const Duration(days: 20)),
      imageUrl: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1c1c7',
      category: 'Spiritual Guidance',
      readTime: 9,
    ),
  ];

  List<BlogPost> get posts => _posts;

  BlogPost? getPostById(String id) {
    try {
      return _posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }

  List<BlogPost> getPostsByCategory(String category) {
    if (category == 'All') return _posts;
    return _posts.where((post) => post.category == category).toList();
  }

  List<BlogPost> getRelatedPosts(String currentPostId, int limit) {
    return _posts.where((post) => post.id != currentPostId).take(limit).toList();
  }

  List<String> get categories => [
    'All',
    'Spiritual Guidance',
    'Rituals Explained',
    'Astrology',
    'Temple Stories',
  ];
}
