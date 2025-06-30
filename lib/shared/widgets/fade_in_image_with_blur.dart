import 'package:blurhash_ffi/blurhashffi_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../features/venues/domain/entities/venue.dart';

class FadeInImageWithBlurHash extends StatelessWidget {
  final ImageWithBlurHash image;

  const FadeInImageWithBlurHash({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: image.blurHash != null
          ? BlurhashFfiImage(image.blurHash!)
          : MemoryImage(kTransparentImage),
      image: CachedNetworkImageProvider(image.url),
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 400),
    );
  }
}
