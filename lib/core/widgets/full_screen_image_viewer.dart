import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/injection_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String? link;

  const FullScreenImageViewer({super.key, required this.imageUrl, this.link});

  static Future<void> show(
    BuildContext context, {
    required String imageUrl,
    String? link,
  }) {
    if (imageUrl.trim().isEmpty) return Future.value();

    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (_) => FullScreenImageViewer(imageUrl: imageUrl, link: link),
    );
  }

  bool get _hasLink {
    final value = link?.trim() ?? '';
    return value.isNotEmpty;
  }

  Future<void> _openLink() async {
    final value = link?.trim() ?? '';
    if (value.isEmpty) return;

    final url = value.startsWith('http://') || value.startsWith('https://')
        ? value
        : 'https://$value';

    await Constants.launchURL(url);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(imageUrl),
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                errorBuilder: (_, _, _) => Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: colors.whiteColor,
                    size: 48.sp,
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              top: 8.h,
              end: 8.w,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close_rounded,
                  color: colors.whiteColor,
                  size: 28.sp,
                ),
              ),
            ),
            if (_hasLink)
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
                child: MyDefaultButton(
                  btnText: 'open_link',
                  onPressed: _openLink,
                  textStyle: TextStyles.semiBold14(color: colors.whiteColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
