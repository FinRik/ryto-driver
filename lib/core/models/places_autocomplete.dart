class PlacesAutocomplete {
  final List<Prediction> predictions;
  final String status;

  PlacesAutocomplete({
    required this.predictions,
    required this.status,
  });

  factory PlacesAutocomplete.fromJson(Map<String, dynamic> json) {
    return PlacesAutocomplete(
      predictions: (json['predictions'] as List)
          .map((e) => Prediction.fromJson(e))
          .toList(),
      status: json['status'] ?? '',
    );
  }
}

class Prediction {
  final String description;
  final String placeId;
  final StructuredFormatting structuredFormatting;
  final List<String> types;

  Prediction({
    required this.description,
    required this.placeId,
    required this.structuredFormatting,
    required this.types,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'] ?? '',
      placeId: json['place_id'] ?? '',
      structuredFormatting: StructuredFormatting.fromJson(
        json['structured_formatting'],
      ),
      types: List<String>.from(json['types'] ?? []),
    );
  }
}

class StructuredFormatting {
  final String mainText;
  final String secondaryText;

  StructuredFormatting({
    required this.mainText,
    required this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] ?? '',
      secondaryText: json['secondary_text'] ?? '',
    );
  }
}