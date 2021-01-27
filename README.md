This is a Flutter package that creates a widget with thumbnails that contain
images and a big display for the selected image. The thumbnails' appearance
is fully customizable, as is their position, which may be the top, bottom,
left or right.

The thumbnails' layout depends on the direction that they were given inside
the widget:

* `up` and `down` indicate that the thumbnails are above or below the main
display, respectively. Therefore, they are in a row.
* `left` and `right` on the other hand, mean that a column will be used.

When a thumbnail is tapped, its image gets loaded into a large display for
users to observe. This way users can view any image they choose and switch
the current one for another.

The inspiration used to create and configure this widget (`ThumbnailsView`)
was an Amazon website (like [this one][]) that has a product images viewer
similar to the one this package provides.

[this one]: https://www.amazon.com/Hanes-Long-Sleeve-Beefy-Henley-T-Shirt/dp/B010277HZQ?ref_=Oct_s9_apbd_otopr_hd_bw_b2hbDCl&pf_rd_r=QY5VGXJM5F57RRPBPSQB&pf_rd_p=87bece57-c076-5184-8106-2db5fa20af44&pf_rd_s=merchandised-search-11&pf_rd_t=BROWSE&pf_rd_i=2476517011
