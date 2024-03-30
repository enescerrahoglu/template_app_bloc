import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:template_app_bloc/blocs/profile/profile_bloc.dart';
import 'package:template_app_bloc/blocs/profile/profile_event.dart';
import 'package:template_app_bloc/blocs/profile/profile_state.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/components/custom_trailing.dart';
import 'package:template_app_bloc/constants/color_constants.dart';
import 'package:template_app_bloc/constants/image_constants.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';
import 'package:template_app_bloc/helpers/app_helper.dart';
import 'package:template_app_bloc/helpers/ui_helper.dart';
import 'package:template_app_bloc/services/firebase_service.dart';

class ImageDialog extends StatefulWidget {
  final String imageUrl;

  const ImageDialog({super.key, required this.imageUrl});

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> with SingleTickerProviderStateMixin {
  late PhotoViewController _photoViewController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _dragStartY = 0.0;

  File? pickedImage;

  @override
  void initState() {
    super.initState();

    _photoViewController = PhotoViewController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _photoViewController.dispose();
    super.dispose();
  }

  void _handleVerticalDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    final double dragDistance = details.globalPosition.dy - _dragStartY;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double dragPercentage = dragDistance.abs() / screenHeight;

    _animationController.value = dragPercentage.clamp(0.0, 1.0);
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating || _animationController.status == AnimationStatus.completed) {
      return;
    }

    if (_animationController.value > 0.1) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            return PopScope(
              canPop: !profileState.isLoading,
              child: CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: const Text(LocaleKeys.profile_photo).tr(),
                  backgroundColor: Colors.transparent,
                  border: const Border(),
                  brightness: themeState.isDark ? Brightness.dark : Brightness.light,
                  trailing: pickedImage == null
                      ? CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
                                  child: CupertinoPageScaffold(
                                    backgroundColor:
                                        themeState.isDark ? ColorConstants.darkItem : ColorConstants.lightBackground,
                                    child: SafeArea(
                                      child: SingleChildScrollView(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: UIHelper.borderRadius,
                                                  child: CachedNetworkImage(
                                                    width: UIHelper.deviceWidth * 0.10,
                                                    imageUrl: widget.imageUrl,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  LocaleKeys.edit_profile_photo,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: themeState.isDark
                                                        ? CupertinoColors.white
                                                        : CupertinoColors.black,
                                                  ),
                                                ).tr(),
                                                const SizedBox(width: 10),
                                                const Spacer(),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: themeState.isDark
                                                        ? ColorConstants.darkBackgroundColorActivated
                                                        : ColorConstants.lightBackgroundColorActivated,
                                                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                                                  ),
                                                  child: CupertinoButton(
                                                    padding: EdgeInsets.zero,
                                                    minSize: 30,
                                                    child: const Icon(CupertinoIcons.clear,
                                                        size: 18, color: CupertinoColors.white),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            ClipRRect(
                                              borderRadius: const BorderRadius.vertical(
                                                  top: Radius.circular(10.0), bottom: Radius.circular(10.0)),
                                              child: CupertinoListSection.insetGrouped(
                                                additionalDividerMargin: 0,
                                                hasLeading: false,
                                                footer: null,
                                                margin: EdgeInsets.zero,
                                                topMargin: 0,
                                                children: [
                                                  CupertinoListTile(
                                                    title: const Text(LocaleKeys.take_a_photo).tr(),
                                                    trailing: Icon(
                                                      CupertinoIcons.camera,
                                                      color: themeState.isDark
                                                          ? ColorConstants.lightItem
                                                          : ColorConstants.darkItem,
                                                    ),
                                                    backgroundColor: themeState.isDark
                                                        ? ColorConstants.darkBottomSheetItem
                                                        : ColorConstants.lightBottomSheetItem,
                                                    backgroundColorActivated: themeState.isDark
                                                        ? ColorConstants.darkBackgroundColorActivated
                                                        : ColorConstants.lightBackgroundColorActivated,
                                                    onTap: () async {
                                                      try {
                                                        await AppHelper.pickImageFromCamera().then((file) {
                                                          setState(() => pickedImage = file);
                                                        });
                                                        if (context.mounted) {
                                                          Navigator.pop(context);
                                                        }
                                                      } catch (e) {
                                                        if (context.mounted) {
                                                          Navigator.pop(context);
                                                          AppHelper.showErrorMessage(
                                                            context: context,
                                                            title: LocaleKeys.camera_access_denied.tr(),
                                                            content: LocaleKeys.directed_to_app_settings.tr(),
                                                            onPressed: () {
                                                              openAppSettings();
                                                            },
                                                          );
                                                        }
                                                      }
                                                    },
                                                  ),
                                                  CupertinoListTile(
                                                    title: const Text(LocaleKeys.select_photo).tr(),
                                                    trailing: Icon(
                                                      CupertinoIcons.photo,
                                                      color: themeState.isDark
                                                          ? ColorConstants.lightItem
                                                          : ColorConstants.darkItem,
                                                    ),
                                                    backgroundColor: themeState.isDark
                                                        ? ColorConstants.darkBottomSheetItem
                                                        : ColorConstants.lightBottomSheetItem,
                                                    backgroundColorActivated: themeState.isDark
                                                        ? ColorConstants.darkBackgroundColorActivated
                                                        : ColorConstants.lightBackgroundColorActivated,
                                                    onTap: () async {
                                                      try {
                                                        await AppHelper.pickImageFromGallery().then((file) {
                                                          setState(() => pickedImage = file);
                                                        });
                                                        if (context.mounted) {
                                                          Navigator.pop(context);
                                                        }
                                                      } catch (e) {
                                                        if (context.mounted) {
                                                          Navigator.pop(context);
                                                          AppHelper.showErrorMessage(
                                                            context: context,
                                                            title: LocaleKeys.gallery_access_denied.tr(),
                                                            content: LocaleKeys.directed_to_app_settings.tr(),
                                                            onPressed: () {
                                                              openAppSettings();
                                                            },
                                                          );
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            LocaleKeys.edit,
                            style: TextStyle(
                              color:
                                  themeState.isDark ? ColorConstants.darkPrimaryIcon : ColorConstants.lightPrimaryIcon,
                            ),
                          ).tr())
                      : CustomTrailing(
                          showLoadingIndicator: true,
                          text: LocaleKeys.done,
                          isLoading: profileState.user == null ? true : profileState.isLoading,
                          onPressed: () async {
                            try {
                              profileBloc.add(const SetLoading(isLoading: true));
                              profileState.user!.profilePhoto = await FirebaseService.uploadImage(
                                  pickedImage!, FirebaseService.getProfilePhotoChild(profileState.user!));

                              profileBloc.add(UpdateUser(user: profileState.user!));
                            } catch (e) {
                              if (context.mounted) {
                                AppHelper.showErrorMessage(
                                    context: context, title: LocaleKeys.something_went_wrong.tr());
                              }
                            }
                          },
                        ),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animation.value,
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onVerticalDragStart: _handleVerticalDragStart,
                        onVerticalDragUpdate: _handleVerticalDragUpdate,
                        onVerticalDragEnd: _handleVerticalDragEnd,
                        child: PhotoView(
                          controller: _photoViewController,
                          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                          basePosition: Alignment.center,
                          onScaleEnd: (context, details, controllerValue) {
                            _photoViewController.reset();
                          },
                          loadingBuilder: (context, event) {
                            return const Center(child: CupertinoActivityIndicator());
                          },
                          imageProvider: pickedImage == null
                              ? widget.imageUrl.isNotEmpty
                                  ? NetworkImage(widget.imageUrl)
                                  : Image.asset(ImageConstants.defaultProfilePhoto).image
                              : FileImage(pickedImage!) as ImageProvider,
                        ),
                      ),
                    ),
                    ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                          child: Row(
                            children: [
                              PullDownButton(
                                itemBuilder: (context) => [
                                  PullDownMenuItem(
                                    title: LocaleKeys.save_image.tr(),
                                    icon: CupertinoIcons.square_arrow_down,
                                    onTap: () async {
                                      await AppHelper.downloadImage(widget.imageUrl);
                                    },
                                  ),
                                ],
                                buttonBuilder: (context, showMenu) => CupertinoButton(
                                  onPressed: showMenu,
                                  child: Icon(
                                    CupertinoIcons.share,
                                    color: themeState.isDark
                                        ? ColorConstants.darkPrimaryIcon
                                        : ColorConstants.lightPrimaryIcon,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
