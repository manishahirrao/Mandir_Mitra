import 'package:flutter/material.dart';
import '../../models/faq.dart';
import '../../utils/app_theme.dart';

class FAQItem extends StatelessWidget {
  final FAQ faq;

  const FAQItem({super.key, required this.faq});

  IconData _getCategoryIcon() {
    switch (faq.category) {
      case 'Rituals':
        return Icons.auto_awesome;
      case 'Temples':
        return Icons.temple_hindu;
      case 'Aashirwad Box':
        return Icons.card_giftcard;
      case 'Payments':
        return Icons.payment;
      case 'Delivery':
        return Icons.local_shipping;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(_getCategoryIcon(), color: AppTheme.sacredBlue),
          title: Text(
            faq.question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.templeBrown,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq.answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
