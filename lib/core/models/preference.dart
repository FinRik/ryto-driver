class Preferences {
  final bool idCheckRequired;
  final bool petsAllowed;
  final bool smokingAllowed;
  final bool packagesAllowed;
  final bool musicAllowed;

  Preferences({
    required this.idCheckRequired,
    required this.petsAllowed,
    required this.smokingAllowed,
    required this.packagesAllowed,
    required this.musicAllowed,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      idCheckRequired: json['idCheckRequired'] ?? false,
      petsAllowed: json['petsAllowed'] ?? false,
      smokingAllowed: json['smokingAllowed'] ?? false,
      packagesAllowed: json['packagesAllowed'] ?? false,
      musicAllowed: json['musicAllowed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCheckRequired': idCheckRequired,
      'petsAllowed': petsAllowed,
      'smokingAllowed': smokingAllowed,
      'packagesAllowed': packagesAllowed,
      'musicAllowed': musicAllowed,
    };
  }
}