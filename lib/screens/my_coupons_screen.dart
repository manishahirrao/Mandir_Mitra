import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/coupon_provider.dart';
import '../models/coupon.dart';
import '../utils/app_theme.dart';

class MyCouponsScreen extends StatelessWidget {
  const MyCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Coupons'),
          backgroundColor: AppTheme.sacredBlue,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Used'),
              Tab(text: 'Expired'),
            ],
          ),
        ),
        body: Consumer<CouponProvider>(
          builder: (context, provider, child) {
            return TabBarView(
              children: [
                _buildCouponList(provider.activeCoupons, CouponStatus.active),
                _buildCouponList(provider.usedCoupons, CouponStatus.used),
                _buildCouponList(provider.expiredCoupons, CouponStatus.expired),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCouponList(List<Coupon> coupons, CouponStatus status) {
    if (coupons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.card_giftcard, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No ${status.toString().split('.').last} coupons',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        return _buildCouponCard(coupons[index]);
      },
    );
  }

  Widget _buildCouponCard(Coupon coupon) {
    return Builder(
      builder: (context) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: coupon.status == CouponStatus.active
                  ? [AppTheme.divineGold.withOpacity(0.1), Colors.white]
                  : [Colors.grey[300]!, Colors.grey[100]!],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      coupon.getDiscountText(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: coupon.status == CouponStatus.active
                            ? AppTheme.divineGold
                            : Colors.grey,
                      ),
                    ),
                    if (coupon.status == CouponStatus.active)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ACTIVE',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  coupon.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  coupon.description,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.divineGold, width: 2, style: BorderStyle.solid),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        coupon.code,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: coupon.code));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Code copied!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Valid till ${DateFormat('dd MMM yyyy').format(coupon.validTill)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (coupon.status == CouponStatus.active)
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/main');
                        },
                        child: const Text('Apply Now'),
                      ),
                  ],
                ),
                if (coupon.status == CouponStatus.used && coupon.usedOn != null)
                  Text(
                    'Used on ${DateFormat('dd MMM yyyy').format(DateTime.parse(coupon.usedOn!))}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
