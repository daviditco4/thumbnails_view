library thumbnails_view;

import 'package:flutter/material.dart';

typedef ThumbnailBuilder = Widget Function(
  BuildContext context,
  ImageProvider image,
  bool isCurrent,
);

/// Defines the configuration for the [ThumbnailsView].
class ThumbnailsViewOptions {
  /// The [thumbnailsPosition] and [middleGap] must be non-null.
  const ThumbnailsViewOptions({
    required this.thumbnailsPosition,
    required this.middleGap,
    this.width,
    this.height,
    this.displayDecoration,
  });

  /// The direction in which to position the thumbnails.
  final AxisDirection thumbnailsPosition;

  /// The size in logical pixels of the gap between the thumbnails and the main
  /// display.
  final double middleGap;

  /// The width of the entire [ThumbnailsView].
  final double? width;

  /// The height of the entire [ThumbnailsView].
  final double? height;

  /// The decoration of the main display's container.
  final Decoration? displayDecoration;
}

/// Creates a main display of an image and a row or column of thumbnails to
/// select the image.
class ThumbnailsView extends StatefulWidget {
  /// All the constructor's parameters must be non-null except for the [key].
  ///
  /// [images] can't be an empty list and [initialIndex] must be between 0 and
  /// ([images.length] - 1) inclusive.
  ///
  /// [initialIndex] defaults to 0.
  const ThumbnailsView({
    Key? key,
    required this.images,
    required this.thumbnailBuilder,
    required this.options,
    this.initialIndex = 0,
  })  : assert(images.length > 0),
        assert(initialIndex >= 0 && initialIndex < images.length),
        super(key: key);

  /// The images that will be mapped to thumbnail widgets.
  final List<ImageProvider> images;

  /// The function that builds a thumbnail widget, including its margin. This
  /// widget is wrapped with an [InkWell] that implements the onTap function for
  /// making the images switch.
  final ThumbnailBuilder thumbnailBuilder;

  /// Configuration other than builder functions and image-related data.
  final ThumbnailsViewOptions options;

  /// The index of the first image that is shown in the main display.
  final int initialIndex;

  @override
  _ThumbnailsViewState createState() => _ThumbnailsViewState();
}

class _ThumbnailsViewState extends State<ThumbnailsView> {
  ImageProvider? currentImage;

  @override
  void initState() {
    super.initState();
    currentImage = widget.images[widget.initialIndex];
  }

  @override
  Widget build(BuildContext context) {
    const thumbnailsMargin = 10.0;
    final areThumbnailsVertical =
        widget.options.thumbnailsPosition == AxisDirection.left ||
            widget.options.thumbnailsPosition == AxisDirection.right;
    final thumbnails = widget.images.map(
      (image) {
        return InkWell(
          onTap: () {
            if (currentImage != image) setState(() => currentImage = image);
          },
          child: widget.thumbnailBuilder(context, image, image == currentImage),
        );
      },
    ).toList();
    var children = [
      Padding(
        padding: areThumbnailsVertical
            ? const EdgeInsets.symmetric(vertical: thumbnailsMargin)
            : const EdgeInsets.symmetric(horizontal: thumbnailsMargin),
        child: SingleChildScrollView(
          child: areThumbnailsVertical
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: thumbnails,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: thumbnails,
                ),
        ),
      ),
      areThumbnailsVertical
          ? SizedBox(width: widget.options.middleGap)
          : SizedBox(height: widget.options.middleGap),
      Expanded(
        child: Container(
          decoration: widget.options.displayDecoration,
          child: Image(
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            image: currentImage!,
          ),
        ),
      ),
    ];
    children = widget.options.thumbnailsPosition == AxisDirection.down ||
            widget.options.thumbnailsPosition == AxisDirection.right
        ? children.reversed.toList()
        : children;

    return Container(
      width: widget.options.width,
      height: widget.options.height,
      child: areThumbnailsVertical
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
    );
  }
}
