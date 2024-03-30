part of "profile_view.dart";

mixin ProfileViewMixin on State<ProfileView> {
  final DateFormat dateFormat = DateFormat("dd.MM.yyyy");
  late TextEditingController emailTextEditingController;
  late TextEditingController firstNameTextEditingController;
  late TextEditingController lastNameTextEditingController;
  late TextEditingController birthdayTextEditingController;
  late TextEditingController genderTextEditingController;
  DateTime? _selectedDate;
  int? _selectedGender;

  @override
  void initState() {
    final ProfileState profileState = context.read<ProfileBloc>().state;
    emailTextEditingController = TextEditingController();
    firstNameTextEditingController = TextEditingController();
    lastNameTextEditingController = TextEditingController();
    birthdayTextEditingController = TextEditingController();
    genderTextEditingController = TextEditingController();

    if (profileState.user != null) {
      emailTextEditingController.text = profileState.user!.email;
      firstNameTextEditingController.text = profileState.user!.firstName;
      lastNameTextEditingController.text = profileState.user!.lastName;
      if (profileState.user!.dateOfBirth.toUtc() != AppConstants.nullDate) {
        _selectedDate = profileState.user!.dateOfBirth;
        birthdayTextEditingController.text = dateFormat.format(_selectedDate ?? DateTime.now());
      }
      if (profileState.user!.gender >= 1 && profileState.user!.gender <= 3) {
        _selectedGender = profileState.user!.gender;
        genderTextEditingController.text = AppConstants.getGender(profileState.user!.gender);
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    firstNameTextEditingController.dispose();
    lastNameTextEditingController.dispose();
    birthdayTextEditingController.dispose();
    genderTextEditingController.dispose();
    super.dispose();
  }

  void _listener(ProfileState state) {
    final ValidateSuccess validateSuccess = context.read<LoginBloc>().state as ValidateSuccess;
    final ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);
    if (state is UpdateUserSuccess) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => const NavigationView(),
          ),
          (route) => false,
        );
      }
    } else if (state is UpdateUserFailed) {
      profileBloc.add(SetUser(user: validateSuccess.user));
      AppHelper.showErrorMessage(context: context, content: state.message ?? LocaleKeys.something_went_wrong.tr());
    }
  }

  bool _checkValues() {
    if (firstNameTextEditingController.text.trim().isEmpty) return false;
    if (lastNameTextEditingController.text.trim().isEmpty) return false;
    if (_selectedDate == null) return false;
    if (_selectedGender == null) return false;
    return true;
  }
}
