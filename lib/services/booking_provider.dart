import 'package:flutter/foundation.dart';
import '../models/booking.dart';

class BookingProvider with ChangeNotifier {
  final List<Booking> _bookings = [];
  Booking? _currentBooking;
  bool _isLoading = false;

  List<Booking> get bookings => _bookings;
  Booking? get currentBooking => _currentBooking;
  bool get isLoading => _isLoading;

  void setCurrentBooking(Booking booking) {
    _currentBooking = booking;
    notifyListeners();
  }

  Future<Booking> createBooking(Booking booking) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _bookings.add(booking);
    _currentBooking = booking;

    _isLoading = false;
    notifyListeners();

    return booking;
  }

  Future<void> updateBooking(Booking booking) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final index = _bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      _bookings[index] = booking;
      if (_currentBooking?.id == booking.id) {
        _currentBooking = booking;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> cancelBooking(String bookingId, String reason) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(
        status: BookingStatus.cancelled,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  double calculateRefundAmount(Booking booking) {
    final hoursUntilRitual = booking.scheduledDateTime.difference(DateTime.now()).inHours;
    
    if (hoursUntilRitual > 48) {
      return booking.totalAmount;
    } else if (hoursUntilRitual >= 24) {
      return booking.totalAmount * 0.5;
    } else {
      return 0;
    }
  }

  void clearCurrentBooking() {
    _currentBooking = null;
    notifyListeners();
  }
}
