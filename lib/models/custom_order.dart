class CustomOrder {
  String fullName;
  String email;
  String phoneNumber;
  String? ritualType;
  List<String> deityPreferences;
  DateTime? selectedDate;
  String? selectedTime;
  String specialInstructions;
  List<String> aashirwadBoxPreferences;
  String additionalNotes;

  CustomOrder({
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.ritualType,
    this.deityPreferences = const [],
    this.selectedDate,
    this.selectedTime,
    this.specialInstructions = '',
    this.aashirwadBoxPreferences = const [],
    this.additionalNotes = '',
  });

  bool get isValid {
    return fullName.length >= 2 &&
        email.isNotEmpty &&
        _isValidEmail(email) &&
        phoneNumber.length == 10 &&
        ritualType != null &&
        selectedDate != null &&
        selectedTime != null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void reset() {
    fullName = '';
    email = '';
    phoneNumber = '';
    ritualType = null;
    deityPreferences = [];
    selectedDate = null;
    selectedTime = null;
    specialInstructions = '';
    aashirwadBoxPreferences = [];
    additionalNotes = '';
  }
}
