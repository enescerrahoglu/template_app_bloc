import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:template_app_bloc/constants/app_constants.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';
import 'package:http/http.dart' as http;
import 'package:template_app_bloc/models/http_response_model.dart';
import 'package:uuid/uuid.dart';

class AppHelper {
  static HttpResponseModel checkEmailAndPassword({required String email, required String password}) {
    if (!AppConstants.emailRegex.hasMatch(email)) {
      return HttpResponseModel(statusCode: 401, message: LocaleKeys.enter_valid_email.tr());
    }
    if (!AppConstants.passwordRegex.hasMatch(password)) {
      return HttpResponseModel(statusCode: 401, message: LocaleKeys.enter_valid_password.tr());
    }
    return HttpResponseModel(statusCode: 200);
  }

  static HttpResponseModel checkEmail({required String email}) {
    if (!AppConstants.emailRegex.hasMatch(email)) {
      return HttpResponseModel(statusCode: 401, message: LocaleKeys.enter_valid_email.tr());
    }
    return HttpResponseModel(statusCode: 200);
  }

  static HttpResponseModel checkPassword({required String password}) {
    if (!AppConstants.passwordRegex.hasMatch(password)) {
      return HttpResponseModel(statusCode: 401, message: LocaleKeys.enter_valid_password.tr());
    }
    return HttpResponseModel(statusCode: 200);
  }

  static void showErrorMessage(
      {required BuildContext context,
      String? title,
      String? content,
      void Function()? onPressed,
      bool barrierDismissible = true}) {
    showCupertinoDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: title != null
            ? Text(
                title,
                style: const TextStyle(color: CupertinoColors.systemRed),
              )
            : null,
        content: content != null
            ? Text(
                content,
                textAlign: TextAlign.start,
              )
            : null,
        actions: [
          CupertinoDialogAction(
            onPressed: onPressed ?? () => Navigator.pop(context),
            child: const Text(LocaleKeys.ok).tr(),
          )
        ],
      ),
    );
  }

  static Future<File?> pickImageFromGallery() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      try {
        PermissionStatus permissionStatus = PermissionStatus.denied;
        if (int.parse(androidInfo.version.release) > 12) {
          await Permission.photos.request();
          permissionStatus = await Permission.photos.status;
        } else {
          await Permission.storage.request();
          permissionStatus = await Permission.storage.status;
        }
        if (permissionStatus.isGranted) {
          try {
            final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100, maxWidth: 1920);
            if (image == null) return null;
            final imageTemp = File(image.path);
            File? croppedImage = await cropImage(imageTemp);
            return croppedImage;
          } on Exception catch (e) {
            throw Exception([e]);
          }
        } else {
          return null;
        }
      } catch (e) {
        throw Exception([e]);
      }
    } else if (Platform.isIOS) {
      try {
        final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100, maxWidth: 1920);
        if (image == null) return null;
        final imageTemp = File(image.path);
        File? croppedImage = await cropImage(imageTemp);
        return croppedImage;
      } on Exception catch (e) {
        throw Exception([e]);
      }
    } else {
      return null;
    }
  }

  static Future<File?> pickImageFromCamera() async {
    if (Platform.isAndroid) {
      try {
        await Permission.camera.request();
        var permissionStatus = await Permission.camera.status;
        if (permissionStatus.isGranted) {
          try {
            final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 100, maxWidth: 1920);
            if (image == null) return null;
            final imageTemp = File(image.path);
            File? croppedImage = await cropImage(imageTemp);
            return croppedImage;
          } on PlatformException catch (e) {
            throw Exception([e]);
          }
        } else {
          return null;
        }
      } catch (e) {
        throw Exception([e]);
      }
    } else if (Platform.isIOS) {
      try {
        final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 100, maxWidth: 1920);
        if (image == null) return null;
        final imageTemp = File(image.path);
        File? croppedImage = await cropImage(imageTemp);
        return croppedImage;
      } catch (e) {
        throw Exception([e]);
      }
    } else {
      return null;
    }
  }

  static Future<File?> cropImage(File image) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      uiSettings: [
        IOSUiSettings(
            aspectRatioPickerButtonHidden: true,
            resetButtonHidden: true,
            aspectRatioLockEnabled: true,
            doneButtonTitle: LocaleKeys.ok.tr(),
            cancelButtonTitle: LocaleKeys.cancel.tr()),
        AndroidUiSettings(
          lockAspectRatio: true,
        )
      ],
      sourcePath: image.path,
      cropStyle: CropStyle.rectangle,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    if (croppedImage == null) {
      return null;
    } else {
      return File(croppedImage.path);
    }
  }

  static Future<void> downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final documentDirectory = await getApplicationDocumentsDirectory();
      final File file = File('${documentDirectory.path}/${const Uuid().v1()}.jpg');
      await file.writeAsBytes(response.bodyBytes);
      await Gal.putImage(file.path);
      await file.delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
