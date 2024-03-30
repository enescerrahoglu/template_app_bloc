import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:template_app_bloc/constants/image_constants.dart';
import 'package:template_app_bloc/helpers/ui_helper.dart';

class ProfilePhotoWidget extends StatelessWidget {
  final String imageUrl;
  const ProfilePhotoWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(500)),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: UIHelper.deviceWidth * 0.12,
        imageUrl: imageUrl,
        progressIndicatorBuilder: (context, url, progress) => const Center(
          child: CupertinoActivityIndicator(),
        ),
        errorWidget: (context, url, error) {
          return Image.asset(ImageConstants.defaultProfilePhoto);
        },
      ),
    );
  }
}
