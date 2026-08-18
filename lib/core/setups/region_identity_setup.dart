import 'package:intl/intl.dart';

abstract class RegionIdentity {
  String get country;
  String get countryCode;
  String get countryDialCode;
  String get locale; // e.g., 'en_NG' or 'en_US'
  String get currencySymbol;
  String get currencyCode;
  String get kycType;
  String get supportPhone;
  String get supportWhatsappLink;

  // Use a getter to dynamically fetch the symbol via intl
  // String get currencySymbol =>
  //     NumberFormat.simpleCurrency(locale: locale).currencySymbol;

  // Helper for formatting prices correctly for the region
  String formatPrice(double amount) =>
      NumberFormat.simpleCurrency(locale: locale).format(amount);
}

class NGIdentity extends RegionIdentity {
  @override
  String get country => 'Nigeria';
  @override
  String get countryCode => 'NG';
  @override
  String get countryDialCode => '+234';
  @override
  String get locale => 'en_NG';
  @override
  String get currencySymbol => '₦';
  @override
  String get currencyCode => 'NGN';
  @override
  String get kycType => 'NIN / BVN';
  @override
  String get supportPhone => '+234 704 700 3608';
  @override
  String get supportWhatsappLink => 'https://wa.me/message/TBPZOW7D3JTDA1';
}

class USIdentity extends RegionIdentity {
  @override
  String get country => 'United States';
  @override
  String get countryCode => 'US';
  @override
  String get countryDialCode => '+1';
  @override
  String get locale => 'en_US';
  @override
  String get currencySymbol => '\$';
  @override
  String get currencyCode => 'USD';
  @override
  String get kycType => 'SSN / State ID';
  @override
  String get supportPhone => '+1 817-554-8929';
  @override
  String get supportWhatsappLink => 'https://wa.me/message/P4BMYREGIHK3O1';
}
