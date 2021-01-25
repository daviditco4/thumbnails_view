library thumbnails_view;

import 'package:flutter/material.dart';

typedef ThumbnailBuilder = Widget Function(
  BuildContext context,
  ImageProvider image,
  bool isCurrent,
);

class ThumbnailsViewOptions {
  const ThumbnailsViewOptions({
    required this.thumbnailsPosition,
    required this.middleGap,
    this.width,
    this.height,
    this.viewDecoration,
  });

  final AxisDirection thumbnailsPosition;
  final double middleGap;
  final double? width;
  final double? height;
  final Decoration? viewDecoration;
}

class ThumbnailsView extends StatefulWidget {
  const ThumbnailsView({
    Key? key,
    required this.images,
    required this.thumbnailBuilder,
    required this.options,
    this.initialIndex = 0,
  })  : assert(images.length > 0),
        assert(initialIndex >= 0 && initialIndex < images.length),
        super(key: key);

  final List<ImageProvider> images;
  final ThumbnailBuilder thumbnailBuilder;
  final ThumbnailsViewOptions options;
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
          decoration: widget.options.viewDecoration,
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
