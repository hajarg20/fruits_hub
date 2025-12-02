import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    String url = imageUrl;

    // Fix double extensions
    if (url.contains('..jpg')) url = url.replaceAll('..jpg', '.jpg');
    if (url.contains('..png')) url = url.replaceAll('..png', '.png');
    if (url.contains('..jpeg')) url = url.replaceAll('..jpeg', '.jpeg');

    if (url.isEmpty) url = 'https://via.placeholder.com/150';

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      ),
    );
  }
}
