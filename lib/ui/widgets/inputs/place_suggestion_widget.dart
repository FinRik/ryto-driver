import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../app/app_setup_locator.dart';
import '../../../core/models/lat_lng.dart';
import '../../../core/models/places_autocomplete.dart';
import '../../../core/repos/places_repo.dart';
import '../../../core/setups/region_identity_setup.dart';

class PlacesSuggestionWidget extends StatefulWidget {
  final String hint;
  final String? label;
  final Function(LatLng)? onPlaceSelected;
  final TextEditingController? controller;
  final TextStyle? labelStyle;
  final String? prefixSvg;
  final IconData? prefixIcon;

  const PlacesSuggestionWidget({
    super.key,
    this.label,
    this.hint = 'Type a place name...',
    this.onPlaceSelected,
    this.controller,
    this.labelStyle,
    this.prefixSvg,
    this.prefixIcon = Icons.text_increase_rounded,
  });

  @override
  State<PlacesSuggestionWidget> createState() => _PlacesSuggestionWidgetState();
}

class _PlacesSuggestionWidgetState extends State<PlacesSuggestionWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  Future<List<Prediction>?> fetchPlaces(String pattern) async {
    final region = sl<RegionIdentity>();
    final placesRepo = context.read<PlacesRepo>();
    final result = await placesRepo.getSuggestions(
      pattern,
      country: region.countryCode.toLowerCase(),
    );
    return result;
  }

  Future<LatLng?> fetchLatLng(String placeId, String result) async {
    final placesRepo = context.read<PlacesRepo>();
    final latLng = await placesRepo.getLatLngFromPlaceId(placeId, result);
    return latLng;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: const TextStyle(
              color: Color(0xff696E7E),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ).merge(widget.labelStyle ?? const TextStyle()),
          ),
        SizedBox(height: 4.0),
        TypeAheadField<Prediction>(
          controller: _controller,
          debounceDuration: const Duration(
            milliseconds: 300,
          ), // good UX + cost saving
          hideOnEmpty: false,
          hideOnLoading: false,
          hideOnError: false,

          // STATE HANDLING BUILDERS
          loadingBuilder: (context) => const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          emptyBuilder: (context) => const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No places found',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          errorBuilder: (context, error) {
            String? formattedError;
            if (error.toString().contains("REQUEST_DENIED")) {
              formattedError = "Request Denied";
            } else {
              formattedError = "Failed to fetch location";
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                formattedError,
                style: const TextStyle(color: Colors.red),
              ),
            );
          },

          suggestionsCallback: fetchPlaces,
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: const Icon(Icons.location_on, color: Colors.blueGrey),
              title: Text(
                suggestion.description,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                suggestion.structuredFormatting.secondaryText,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },

          onSelected: (suggestion) async {
            _controller.text = suggestion.description;
            final result = suggestion.structuredFormatting.mainText;
            final placeId = suggestion.placeId;
            print("Getting coord data: $result");
            final coord = await fetchLatLng(placeId, result);
            print("Coord Data: ${coord?.toJson()}");
            if (coord != null) {
              widget.onPlaceSelected?.call(coord);
            } else {
              print("Could not find coordinates");
            }
          },

          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: widget.hint,
                prefixIcon: widget.prefixIcon != null
                    ? Container(
                        margin: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8.0,
                          left: 12,
                        ),
                        child: widget.prefixSvg != null
                            ? SvgPicture.asset(widget.prefixSvg!)
                            : Icon(widget.prefixIcon),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(width: 1, color: Color(0xffE5E5E6)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(width: 1, color: Color(0xffE5E5E6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(width: 1, color: Color(0xffE5E5E6)),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            );
          },
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
