import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app_bloc/blocs/auth/login/login_bloc.dart';
import 'package:template_app_bloc/blocs/auth/login/login_state.dart';
import 'package:template_app_bloc/blocs/profile/profile_bloc.dart';
import 'package:template_app_bloc/blocs/profile/profile_event.dart';
import 'package:template_app_bloc/blocs/profile/profile_state.dart';
import 'package:template_app_bloc/blocs/theme/theme_bloc.dart';
import 'package:template_app_bloc/blocs/theme/theme_state.dart';
import 'package:template_app_bloc/components/custom_trailing.dart';
import 'package:template_app_bloc/constants/app_constants.dart';
import 'package:template_app_bloc/constants/color_constants.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';
import 'package:template_app_bloc/helpers/app_helper.dart';
import 'package:template_app_bloc/helpers/ui_helper.dart';
import 'package:template_app_bloc/views/navigation/navigation_view.dart';
import 'package:template_app_bloc/views/profile/widgets/birthday_text_field.dart';
import 'package:template_app_bloc/views/profile/widgets/gender_text_field.dart';
import 'package:template_app_bloc/views/profile/widgets/image_dialog.dart';
import 'package:template_app_bloc/views/profile/widgets/profile_photo_widget.dart';
import 'package:template_app_bloc/views/profile/widgets/profile_text_field.dart';
import 'package:template_app_bloc/widgets/custom_scaffold.dart';
import 'package:template_app_bloc/widgets/unauthenticated_user_widget.dart';
part "profile_view_mixin.dart";

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with ProfileViewMixin {
  @override
  Widget build(BuildContext context) {
    final ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            return BlocListener<ProfileBloc, ProfileState>(
              listener: (context, profileState) {
                _listener(profileState);
              },
              child: PopScope(
                canPop: !profileState.isLoading,
                child: CustomScaffold(
                  title: LocaleKeys.profile,
                  trailing: CustomTrailing(
                    showLoadingIndicator: true,
                    text: LocaleKeys.done,
                    isLoading: profileState.user == null ? true : profileState.isLoading,
                    onPressed: () {
                      if (_checkValues() && profileState.user != null) {
                        profileState.user!.firstName = firstNameTextEditingController.text.trim();
                        profileState.user!.lastName = lastNameTextEditingController.text.trim();
                        profileState.user!.dateOfBirth = _selectedDate!;
                        profileState.user!.gender = _selectedGender!;
                        profileBloc.add(UpdateUser(user: profileState.user!));
                      } else {
                        AppHelper.showErrorMessage(
                            context: context, content: LocaleKeys.please_fill_in_all_fields.tr());
                      }
                    },
                  ),
                  children: [
                    profileState.user != null
                        ? Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: themeState.isDark ? ColorConstants.darkItem : ColorConstants.lightItem,
                                  borderRadius: UIHelper.borderRadius,
                                ),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CupertinoButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                showCupertinoDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return ImageDialog(imageUrl: profileState.user!.profilePhoto);
                                                  },
                                                );
                                              },
                                              child: ProfilePhotoWidget(imageUrl: profileState.user!.profilePhoto),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: const Text(LocaleKeys.enter_your_info).tr(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        CupertinoButton(
                                          onPressed: () {
                                            showCupertinoDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (context) {
                                                return ImageDialog(imageUrl: profileState.user!.profilePhoto);
                                              },
                                            );
                                          },
                                          padding: EdgeInsets.zero,
                                          child: Text(
                                            LocaleKeys.edit,
                                            style: TextStyle(
                                              color: themeState.isDark
                                                  ? ColorConstants.darkPrimaryIcon
                                                  : ColorConstants.lightPrimaryIcon,
                                            ),
                                          ).tr(),
                                        ),
                                      ],
                                    ),
                                    CupertinoListSection(
                                      backgroundColor: Colors.transparent,
                                      margin: EdgeInsets.zero,
                                      topMargin: 10,
                                      hasLeading: false,
                                      dividerMargin: 10,
                                      decoration: BoxDecoration(
                                        color: themeState.isDark ? ColorConstants.darkItem : ColorConstants.lightItem,
                                      ),
                                      children: [
                                        ProfileTextField(
                                          textEditingController: emailTextEditingController,
                                          placeholder: LocaleKeys.email.tr(),
                                          readOnly: true,
                                          maxLength: null,
                                        ),
                                        ProfileTextField(
                                          textEditingController: firstNameTextEditingController,
                                          placeholder: LocaleKeys.first_name.tr(),
                                        ),
                                        ProfileTextField(
                                          textEditingController: lastNameTextEditingController,
                                          placeholder: LocaleKeys.last_name.tr(),
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              CupertinoListSection(
                                header: const Text(LocaleKeys.date_of_birth).tr(),
                                separatorColor: Colors.transparent,
                                margin: const EdgeInsets.all(0),
                                decoration: const BoxDecoration(color: Colors.transparent),
                                backgroundColor: Colors.transparent,
                                children: [
                                  BirthdayTextFieldWidget(
                                    textEditingController: birthdayTextEditingController,
                                    initialDateTime: _selectedDate,
                                    onDateTimeChanged: (date) {
                                      _selectedDate = date;
                                      birthdayTextEditingController.text = dateFormat.format(_selectedDate!);
                                    },
                                  ),
                                ],
                              ),
                              CupertinoListSection(
                                header: const Text(LocaleKeys.gender).tr(),
                                separatorColor: Colors.transparent,
                                margin: const EdgeInsets.all(0),
                                decoration: const BoxDecoration(color: Colors.transparent),
                                backgroundColor: Colors.transparent,
                                children: [
                                  GenderTextFieldWidget(
                                    initialGender: _selectedGender,
                                    textEditingController: genderTextEditingController,
                                    onGenderChanged: (gender) {
                                      genderTextEditingController.text = AppConstants.getGender(gender);
                                      setState(() {
                                        _selectedGender = gender;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const UnauthenticatedUserWidget(),
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
