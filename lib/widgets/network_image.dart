
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget loadNetwordImage(imageUrl, {BoxFit fit = BoxFit.cover, double? width, double? height, color, colorBlendMode}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    // placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
    errorWidget: (context, url, error) => new Icon(Icons.error),
    fit: fit,
    height: height,
    width: width,
    color: color,
    colorBlendMode: colorBlendMode,
  );
}
