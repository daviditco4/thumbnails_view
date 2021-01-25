/// This is a Flutter package that creates a widget with thumbnails that contain
/// images and a big display for the selected image. The thumbnails' appearance
/// is fully customizable, as is their position, which may be the top, bottom,
/// left or right.
///
/// The thumbnails' layout depends on the direction that they were given inside
/// the widget:
///
/// * [up] and [down] indicate that the thumbnails are above or below the main
/// display, respectively. Therefore, they are in a row.
/// * [left] and [right] on the other hand, mean that a column will be used.
///
/// When a thumbnail is tapped, its image gets loaded into a large display for
/// users to observe. This way users can view any image they choose and switch
/// the current one for another.
///
/// The inspiration used to create and configure this widget ([ThumbnailsView])
/// was an Amazon website (like [this one][]) that has a product images viewer
/// similar to the one this package provides.
///
/// [this one]: https://www.amazon.com/Hanes-Long-Sleeve-Beefy-Henley-T-Shirt/dp/B010277HZQ?ref_=Oct_s9_apbd_otopr_hd_bw_b2hbDCl&pf_rd_r=QY5VGXJM5F57RRPBPSQB&pf_rd_p=87bece57-c076-5184-8106-2db5fa20af44&pf_rd_s=merchandised-search-11&pf_rd_t=BROWSE&pf_rd_i=2476517011
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
