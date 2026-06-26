class USData {
  final List<USState> states;
  final List<USState> territories;

  USData({required this.states, required this.territories});

  factory USData.fromJson(Map<String, dynamic> json) {
    return USData(
      states: (json['united_states'] as List)
          .map((i) => USState.fromJson(i))
          .toList(),
      territories: (json['districts_and_territories'] as List)
          .map((i) => USState.fromJson(i))
          .toList(),
    );
  }
}

class USState {
  final String name;
  final String shortcode;

  USState({required this.name, required this.shortcode});

  factory USState.fromJson(Map<String, dynamic> json) {
    return USState(
      name: json['name'],
      shortcode: json['shortcode'],
    );
  }
}