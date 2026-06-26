class StateModel {
  final String? name;
  final String? stateCode;   // renamed for clarity

  StateModel({
    this.name,
    this.stateCode,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      name: json['name'] as String?,
      // ✅ Fixed: Use null-aware cast instead of forcing 'as String'
      stateCode: json['state_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'state_code': stateCode,
    };
  }
}