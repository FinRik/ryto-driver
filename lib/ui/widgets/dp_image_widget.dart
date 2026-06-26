import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef OnChanged = void Function(File);

double _profileHeight = 93;
double _profileRadius = _profileHeight / 2;
double _smallCircleRadius = 23 / 2;

class DpImageWidget extends StatefulWidget {
  final String? placeholderAsset;
  String? imageUrl;
  String? assetImageUrl;
  final bool hasError;
  final double frameRadius;
  final bool isCircular;
  final double borderRadius;
  final double? height;
  final double? width;
  final bool showEditIcon;

  // New callbacks
  final String? initialsOrErrorMessage;
  final OnChanged? onChanged;

  DpImageWidget({
    super.key,
    this.placeholderAsset,
    this.imageUrl,
    // this.imageFile,
    this.assetImageUrl,
    // this.editCallback,
    this.hasError = false,
    this.frameRadius = 45.0,
    this.isCircular = true,
    this.borderRadius = 12,
    this.height,
    this.width,
    this.showEditIcon = false,
    this.initialsOrErrorMessage,
    this.onChanged,
  });

  @override
  State<DpImageWidget> createState() => _DpImageWidgetTwoState();
}

class _DpImageWidgetTwoState extends State<DpImageWidget> {
  File? _pickedImage; // Locally picked image
  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _pickedImage = File(pickedFile.path);
      widget.imageUrl = null;
      widget.assetImageUrl = null;
      // Trigger callback for parent widget
      if (widget.onChanged != null) {
        widget.onChanged!(_pickedImage!);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.height ?? widget.frameRadius * 2;

    return Stack(
      children: [
        // Image container with loading/error handling
        Builder(
          builder: (context) {
            final frameDecoration = BoxDecoration(
              color: Colors.grey.shade200,
              shape: widget.isCircular ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: !widget.isCircular
                  ? BorderRadius.circular(widget.borderRadius)
                  : null,
            );

            final _PlaceHolder placeholder = _PlaceHolder(
              isCircular: widget.isCircular,
              borderRadius: widget.borderRadius,
              placeholderAsset: widget.placeholderAsset,
              height: widget.height,
              frameRadius: widget.frameRadius,
              width: widget.width,
            );

            if (_pickedImage != null) {
              // Local image (from file)
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: frameDecoration,
                height: size,
                width: widget.width ?? size,
                child: Image.file(_pickedImage!, fit: BoxFit.cover),
              );
            } else if (widget.assetImageUrl != null) {
              // Asset image
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: frameDecoration,
                height: size,
                width: widget.width ?? size,
                child: Image.asset(widget.assetImageUrl!, fit: BoxFit.cover),
              );
            } else if (widget.imageUrl == null) {
              // Placeholder image
              return placeholder;
            } else {
              // Network image with cached image and loading/error handling
              return CachedNetworkImage(
                imageUrl: widget.imageUrl!,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: frameDecoration,
                    height: size,
                    width: widget.width ?? size,
                    child: Image(image: imageProvider, fit: BoxFit.cover),
                  );
                },
                placeholder: (context, url) => placeholder,
                errorWidget: (context, url, error) => placeholder.copyWith(
                  hasError: true,
                  errorMessage: widget.initialsOrErrorMessage != null
                      ? (error is HandshakeException)
                            ? "Connection Error"
                            : "Error"
                      : null,
                ),
              );
            }
          },
        ),

        // Optional edit icon overlay
        if (widget.showEditIcon)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () async => await _pickImage(),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0061FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PlaceHolder extends StatelessWidget {
  const _PlaceHolder({
    required this.isCircular,
    required this.borderRadius,
    required this.placeholderAsset,
    required this.height,
    required this.frameRadius,
    required this.width,
    this.hasError = false,
    this.errorMessage,
  });

  final bool isCircular;
  final double borderRadius;
  final String? placeholderAsset;
  final double? height;
  final double frameRadius;
  final double? width;
  final bool hasError;
  final String? errorMessage;

  _PlaceHolder copyWith({bool hasError = false, String? errorMessage}) {
    return _PlaceHolder(
      isCircular: isCircular,
      borderRadius: borderRadius,
      placeholderAsset: placeholderAsset,
      height: height,
      frameRadius: frameRadius,
      width: width,
      hasError: hasError,
      errorMessage: errorMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double size = height ?? frameRadius * 2;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: !isCircular ? BorderRadius.circular(borderRadius) : null,
        image: placeholderAsset != null
            ? DecorationImage(
                image: AssetImage(placeholderAsset!),
                colorFilter: hasError
                    ? ColorFilter.mode(
                        Colors.red.withOpacity(0.4),
                        BlendMode.modulate,
                      )
                    : null,
                fit: BoxFit.cover,
              )
            : null,
      ),
      height: size,
      width: width ?? size,
      child: hasError
          ? Center(
              child: Text(
                errorMessage ?? "Error",
                style: const TextStyle(color: Colors.red),
              ),
            )
          : null,
    );
  }
}
