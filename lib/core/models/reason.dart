class CancellationReason {
  final String id;
  final String name;

  CancellationReason({required this.id, required this.name});

  static List<CancellationReason> reasons = [
    CancellationReason(id: "CHANGE_OF_PLANS",name: "Change of plans"),
    CancellationReason(id: "BOOKED_BY_MISTAKE",name: "Booked by mistake"),
    CancellationReason(id: "FOUND_OTHER_RIDE",name: "Found another ride"),
    CancellationReason(id: "PICKUP_TIME_NOT_CONVENIENT",name: "Pickup time no longer works"),
    CancellationReason(id: "EMERGENCY",name: "Emergency"),
    CancellationReason(id: "PRICE_TOO_HIGH",name: "Price too high"),
    CancellationReason(id: "VEHICLE_ISSUE",name: "Vehicle broke down"),
    CancellationReason(id: "OTHER",name: "Other"),
  ];
}

extension ReasonIdExt on String {
  /// Converts a raw reason ID into its human-readable display name.
  /// Fallbacks to the raw ID if no matches are found.
  String toReadableReason() {
    return CancellationReason.reasons.firstWhere(
          (element) => element.id.toUpperCase() == trim().toUpperCase(),
      orElse: () => CancellationReason(id: this, name: this),
    ).name;
  }
}