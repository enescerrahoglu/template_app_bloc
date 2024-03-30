import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:template_app_bloc/generated/locale_keys.g.dart';
import 'package:template_app_bloc/models/user_model.dart';
import 'package:uuid/uuid.dart';

class FirebaseService {
  static Future<String> uploadImage(File image, String child) async {
    final storageRef = FirebaseStorage.instance.ref();
    try {
      TaskSnapshot snapshot = await storageRef.child(child).putFile(image);
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (error) {
      throw Exception([error]);
    }
  }

  static String getProfilePhotoChild(UserModel userModel) {
    return "ProfilePhotos/${userModel.email}/${const Uuid().v1()}.jpg";
  }

  static Future<int?> sendVerificationCode({required String toMail}) async {
    try {
      HttpsCallableResult result =
          await FirebaseFunctions.instance.httpsCallable('sendVerificationCode').call(<String, dynamic>{
        'to': toMail,
        'subject': LocaleKeys.verification_code_mail_subject.tr(),
        'text': LocaleKeys.verification_code_mail_text.tr(),
      });

      if (result.data["success"] == true) {
        return result.data["verificationCode"];
      } else {
        return null;
      }
    } on FirebaseFunctionsException catch (error) {
      throw Exception([error]);
    }
  }

  static Future<bool> sendMail({required String toMail, required String subject, String? text, String? html}) async {
    try {
      HttpsCallableResult result = await FirebaseFunctions.instance.httpsCallable('sendMail').call(<String, dynamic>{
        'to': toMail,
        'subject': subject,
        'text': text,
        'html': html,
      });

      if (result.data["success"] == true) {
        return true;
      } else {
        return false;
      }
    } on FirebaseFunctionsException catch (error) {
      throw Exception([error]);
    }
  }
}
