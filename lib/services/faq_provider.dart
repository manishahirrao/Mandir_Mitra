import 'package:flutter/foundation.dart';
import '../models/faq.dart';

class FAQProvider with ChangeNotifier {
  final List<FAQ> _faqs = [
    FAQ(
      id: '1',
      category: 'Rituals',
      question: 'How long does it take to schedule a ritual?',
      answer: 'Most rituals can be scheduled within 24-48 hours. However, for specific dates or special occasions, we recommend booking at least 7 days in advance to ensure availability of priests and temple slots.',
    ),
    FAQ(
      id: '2',
      category: 'Rituals',
      question: 'Can I choose a specific priest?',
      answer: 'Yes, you can request a specific priest when booking your ritual. However, availability depends on the priest\'s schedule. We have a team of experienced and certified priests who can perform your ritual with equal devotion and authenticity.',
    ),
    FAQ(
      id: '3',
      category: 'Rituals',
      question: 'What happens if there\'s a technical issue during streaming?',
      answer: 'We have backup systems in place to ensure uninterrupted streaming. In the rare event of technical difficulties, we will reschedule your ritual at no additional cost and provide a recording of the ceremony.',
    ),
    FAQ(
      id: '4',
      category: 'Aashirwad Box',
      question: 'How is the Aashirwad Box delivered?',
      answer: 'The Aashirwad Box is carefully packaged and shipped via trusted courier services within 2-3 days after your ritual is completed. You will receive tracking information via SMS and email.',
    ),
    FAQ(
      id: '5',
      category: 'Rituals',
      question: 'Are the rituals authentic and verified?',
      answer: 'Absolutely! All our rituals are performed by certified priests following traditional Vedic procedures. We partner only with renowned temples and ensure complete authenticity in every ceremony.',
    ),
    FAQ(
      id: '6',
      category: 'Payments',
      question: 'What are the payment options?',
      answer: 'We accept all major payment methods including UPI, Credit/Debit Cards, Net Banking, and digital wallets. All transactions are secured with 256-bit encryption.',
    ),
    FAQ(
      id: '7',
      category: 'Rituals',
      question: 'Can I cancel or reschedule my ritual?',
      answer: 'Yes, you can cancel or reschedule up to 24 hours before the scheduled time. Cancellations made within 24 hours may incur a small processing fee. Rescheduling is free of charge.',
    ),
    FAQ(
      id: '8',
      category: 'Delivery',
      question: 'How do I track my Aashirwad Box?',
      answer: 'Once your Aashirwad Box is shipped, you\'ll receive a tracking number via SMS and email. You can also track it from the "My Rituals" section in the app.',
    ),
    FAQ(
      id: '9',
      category: 'Rituals',
      question: 'What\'s included in each package type?',
      answer: 'Shared Package: Basic ritual with live streaming. Family Package: Personalized ritual with family name, live streaming, and standard Aashirwad Box. Personal Package: Exclusive ritual, premium streaming, customized Aashirwad Box, and priest consultation.',
    ),
    FAQ(
      id: '10',
      category: 'Rituals',
      question: 'Do you offer custom rituals?',
      answer: 'Yes! We offer custom ritual services tailored to your specific needs. Contact our support team to discuss your requirements and we\'ll create a personalized package for you.',
    ),
    FAQ(
      id: '11',
      category: 'Temples',
      question: 'Which temples do you partner with?',
      answer: 'We partner with over 50 renowned temples across India including Jagannath Temple (Puri), Kashi Vishwanath (Varanasi), Meenakshi Temple (Madurai), and many more. Each temple is carefully selected for its authenticity and spiritual significance.',
    ),
    FAQ(
      id: '12',
      category: 'Payments',
      question: 'Is my payment information secure?',
      answer: 'Yes, we use industry-standard encryption and comply with PCI DSS standards. We never store your complete card details on our servers.',
    ),
    FAQ(
      id: '13',
      category: 'Aashirwad Box',
      question: 'What items are included in the Aashirwad Box?',
      answer: 'The Aashirwad Box typically includes prasad, sacred ash (vibhuti), kumkum, sacred thread (kalava), holy water, and a personalized blessing card from the priest. Contents may vary based on the ritual and package selected.',
    ),
    FAQ(
      id: '14',
      category: 'Rituals',
      question: 'Can I attend the ritual in person?',
      answer: 'Yes, if you wish to attend in person, please mention this during booking. We\'ll coordinate with the temple and provide you with all necessary details including timing and location.',
    ),
    FAQ(
      id: '15',
      category: 'Delivery',
      question: 'Do you deliver internationally?',
      answer: 'Currently, we deliver Aashirwad Boxes within India only. However, devotees from anywhere in the world can book rituals and watch the live streaming.',
    ),
    FAQ(
      id: '16',
      category: 'Rituals',
      question: 'How long does a typical ritual last?',
      answer: 'Duration varies by ritual type. Simple pujas last 30-45 minutes, while elaborate ceremonies like Satyanarayan Puja can take 2-3 hours. The exact duration is mentioned in the ritual description.',
    ),
    FAQ(
      id: '17',
      category: 'Payments',
      question: 'Do you offer refunds?',
      answer: 'Refunds are processed for cancellations made 24+ hours before the ritual. The amount is credited back to your original payment method within 5-7 business days.',
    ),
    FAQ(
      id: '18',
      category: 'Temples',
      question: 'Can I request a ritual at a specific temple?',
      answer: 'Yes, you can select your preferred temple when booking. If a specific ritual is not available at your chosen temple, we\'ll suggest the nearest alternative.',
    ),
    FAQ(
      id: '19',
      category: 'Aashirwad Box',
      question: 'How should I store the prasad from the Aashirwad Box?',
      answer: 'Prasad should be consumed within 2-3 days of receipt. Store it in a cool, dry place. Other items like kumkum and vibhuti can be stored in your puja room for regular use.',
    ),
    FAQ(
      id: '20',
      category: 'Rituals',
      question: 'Can I book multiple rituals at once?',
      answer: 'Yes, you can book multiple rituals for different dates or even on the same day at different temples. We offer package discounts for bulk bookings.',
    ),
  ];

  List<FAQ> get faqs => _faqs;

  List<FAQ> getFAQsByCategory(String category) {
    if (category == 'All') return _faqs;
    return _faqs.where((faq) => faq.category == category).toList();
  }

  List<FAQ> searchFAQs(String query) {
    if (query.isEmpty) return _faqs;
    return _faqs.where((faq) =>
      faq.question.toLowerCase().contains(query.toLowerCase()) ||
      faq.answer.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<String> get categories => [
    'All',
    'Rituals',
    'Temples',
    'Aashirwad Box',
    'Payments',
    'Delivery',
  ];
}
