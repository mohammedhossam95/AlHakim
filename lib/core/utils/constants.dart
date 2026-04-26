// ignore_for_file: strict_top_level_inference

import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:animate_do/animate_do.dart';
import 'package:country_picker/country_picker.dart' as picker;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/api/dio_consumer.dart';
import '/core/utils/app_strings.dart';
import '/core/utils/extension.dart';
import '/core/utils/log_utils.dart';
import '../../config/locale/app_localizations.dart';
import '../../injection_container.dart';

final Color baseColorShimmer = Colors.grey.shade300;
final Color highlightColorShimmer = Colors.grey.shade100;

class Constants {
  static const String appVersionType = 'test'; // live, test
  static String getSystemLang() {
    Locale locale = ui.PlatformDispatcher.instance.locale;
    return locale.languageCode;
  }

  static Future<void> launchAppUrl(String url) async {
    Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Log.d(e.toString());
      throw 'Could not launch $url';
    }
  }

  static Future<void> openUrl(String url) async {
    Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Couldn\'t launch $url';
      }
    } catch (e) {
      Log.e(e.toString());
      throw 'Couldn\'t launch $url';
    }
  }

  static Future<File?> getCompressedFile(File file, String targetPath) async {
    XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
    );

    if (result != null) {
      log(
        "Original File Size -- ${file.lengthSync()} --- CompressedFile ${File(result.path).lengthSync()} ",
      );
      return File(result.path);
    } else {
      return null;
    }
  }

  static Future<bool> checkVersion(String newVersion) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    int current = int.parse(currentVersion.replaceAll('.', ""));
    int update = double.parse(newVersion.toString()).toInt();

    if (update > current) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool?> showExitApp(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Center(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0.r),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElasticInLeft(
                    child: Center(
                      child: Text('exit_app'.tr, style: TextStyles.bold18()),
                    ),
                  ),
                  Gaps.vGap12,
                  ElasticInRight(
                    child: Center(
                      child: Text(
                        "are_you_sure_you_want_to_exit_app".tr,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Gaps.vGap12,
                  Divider(height: 2),
                  Gaps.vGap16,
                  Row(
                    children: [
                      Expanded(
                        child: ElasticInRight(
                          child: MyDefaultButton(
                            height: 40.h,
                            onPressed: () => Navigator.of(context).pop(true),
                            btnText: 'yes',
                            color: colors.errorColor,
                            borderColor: colors.errorColor,
                          ),
                        ),
                      ),
                      Gaps.hGap16,
                      Expanded(
                        child: ElasticInLeft(
                          child: MyDefaultButton(
                            height: 40.h,
                            onPressed: () => Navigator.of(context).pop(false),
                            btnText: 'no',
                            color: colors.lightTextColor.withValues(alpha: 0.3),
                            borderColor: colors.lightTextColor.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String buildImage(String img) {
    String imagePath = '';
    if (img.isNotEmpty) {
      if (img.contains(ApiConstants.baseUrl)) {
        return img;
      } else {
        imagePath = "${ApiConstants.baseUrl}$img";
        return imagePath;
      }
    } else {
      return imagePath;
    }
  }

  // static Future<void> launchURL(String url) async {
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url));
  //   } else {
  //     log('Could not launch $url');
  //   }
  // }
  static Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  static Future<String?> getAgent({bool isFullAgent = true}) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return isFullAgent
          ? "${iosDeviceInfo.systemName} - ${iosDeviceInfo.name} - ${iosDeviceInfo.identifierForVendor} - ${iosDeviceInfo.model} - $version"
          : iosDeviceInfo.systemName;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return isFullAgent
          ? "Android - ${androidDeviceInfo.model} - $version"
          : "Android";
    } else {
      return '';
    }
  }

  static Future<String> getIPAddress() async {
    String ipAddress = 'Unknown';

    try {
      // Get a list of network interfaces
      List<NetworkInterface> interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );

      // Iterate over the network interfaces and find the first non-loopback interface
      for (NetworkInterface interface in interfaces) {
        if (!interface.name.toLowerCase().contains('lo')) {
          ipAddress = interface.addresses.first.address;
          break;
        }
      }
    } catch (e) {
      Log.e('Error getting IP address: $e');
    }

    return ipAddress;
  }

  static Future<String?> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    } else {
      return '';
    }
  }

  static Future<String> getModel() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.model;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model;
    } else {
      return '';
    }
  }
  // static Future<void> makePhoneCall(String phoneNumber) async {
  //   final Uri launchUri = Uri(
  //     scheme: 'tel',
  //     path: phoneNumber,
  //   );
  //   try {
  //     await launchUrl(launchUri);
  //   } catch (e) {
  //     throw 'Could not launch $launchUri';
  //   }
  // }

  // static picker.Country egyptCountryPicker = picker.Country(
  //   phoneCode: '20',
  //   countryCode: 'EG',
  //   e164Sc: 0,
  //   geographic: true,
  //   level: -1,
  //   name: 'Egypt',
  //   example: '1020304050',
  //   displayName: 'Egypt (EG) [+20]',
  //   displayNameNoCountryCode: 'Egypt (EG)',
  //   e164Key: '20-EG-0',
  // );
  static picker.Country saudiCountryPicker = picker.Country(
    phoneCode: '966',
    countryCode: 'SA',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Saudi Arabia',
    example: '512345678',
    displayName: 'Saudi Arabia (SA) [+966]',
    displayNameNoCountryCode: 'Saudi Arabia (SA)',
    e164Key: '966-SA-0',
  );

  static String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }

  static Color textColor(FocusNode focusNode, BuildContext context) {
    return focusNode.hasFocus ? colors.main : colors.textColor;
  }

  static ColorFilter colorFilter(Color color) {
    return ColorFilter.mode(color, BlendMode.srcIn);
  }

  static Future<String?> phoneParsing({
    String? phone,
    String? countryCode,
    bool withCode = true,
  }) async {
    PhoneNumber phoneParsed;
    try {
      phoneParsed = PhoneNumber.parse(
        phone!,
        callerCountry: IsoCode.values
            .where((element) => element.name == countryCode!.toUpperCase())
            .first,
        destinationCountry: countryCode == 'SA'
            ? IsoCode.SA
            : IsoCode.values
                  .where(
                    (element) => element.name == countryCode!.toUpperCase(),
                  )
                  .first,
      );

      if (phoneParsed.isValid()) {
        return withCode == true ? phoneParsed.international : phoneParsed.nsn;
      } else {
        log('Phone number is invalid');
        // throw 'Invalid Phone Number';
        return null;
      }
    } on PlatformException {
      rethrow;
    }
  }

  String getCountryCode(String phone) {
    try {
      final parsed = PhoneNumber.parse(phone);

      return parsed.countryCode; // ده كود الدولة
    } catch (e) {
      return '966';
    }
  }

  static bool checkPDFFiles(String file) {
    var newString = file.substring(file.length - 5);

    debugPrint('file $file');
    debugPrint('checkFile pdf or image  $newString');
    return newString.contains('pdf') ? true : false;
  }

  static bool checkAuth(String msg) {
    return msg == AppStrings.unAuthorizedFailure ||
        msg == AppStrings.tokenFailure;
  }

  static void showErrorDialog({
    required BuildContext context,
    required String msg,
    VoidCallback? onOkPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          msg,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (onOkPressed != null) {
                onOkPressed();
              } else {
                Navigator.pop;
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  static void showLoginWarningDialog(
    BuildContext context, {
    VoidCallback? onOkPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          title: Center(
            child: Icon(Icons.warning, color: colors.review, size: 30.sp),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('login_to_continue'.tr, style: TextStyle(fontSize: 16)),
              Gaps.vGap10,
              Divider(color: colors.review),
              Gaps.vGap10,
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MyDefaultButton(
                      height: 40.h,
                      borderRadius: 20.r,
                      color: colors.whiteColor,
                      borderColor: colors.main,
                      textColor: colors.main,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      btnText: 'close',
                    ),
                  ),
                  Gaps.hGap16,
                  Expanded(
                    flex: 2,
                    child: MyDefaultButton(
                      height: 40.h,
                      borderRadius: 20.r,
                      onPressed: () {
                        if (onOkPressed != null) {
                          onOkPressed();
                        }
                      },
                      btnText: 'login',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void showDeleteAccountDialog(
    BuildContext context, {
    VoidCallback? onOkPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          title: Center(
            child: Icon(Icons.delete, color: colors.errorColor, size: 30.sp),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'areYouSureToDeleteAccount'.tr,
                style: TextStyle(fontSize: 16),
              ),
              Gaps.vGap10,
              Divider(color: colors.lightTextColor.withValues(alpha: 0.5)),
              Gaps.vGap10,
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MyDefaultButton(
                      height: 40.h,
                      borderRadius: 20.r,
                      color: colors.whiteColor,
                      borderColor: colors.main,
                      textColor: colors.main,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      btnText: 'close',
                    ),
                  ),
                  Gaps.hGap16,
                  Expanded(
                    flex: 2,
                    child: MyDefaultButton(
                      height: 40.h,
                      borderRadius: 20.r,
                      onPressed: () {
                        if (onOkPressed != null) {
                          onOkPressed();
                        }
                      },
                      btnText: 'delete_account',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  // static void showToast(
  //     {required String msg, Color? color, ToastGravity? gravity}) {
  //   Fluttertoast.showToast(
  //       toastLength: Toast.LENGTH_LONG,
  //       msg: msg,
  //       backgroundColor: color ?? colors.main,
  //       gravity: gravity ?? ToastGravity.BOTTOM);
  // }

  /// Type: 1 done , 2: warning, 3: error
  static void showSnakToast({required context, message, type}) {
    Color background = colors.main;
    Color textColor = colors.textColor;
    var width = MediaQuery.of(context).size.width;

    String icon = '';

    switch (type) {
      // Add to WishList
      case 1:
        background = Colors.green;
        icon = 'assets/images/done.png';
        textColor = colors.backGround;
        textColor = colors.backGround;
        break;

      // warning
      case 2:
        background = Colors.orangeAccent;
        icon = 'assets/images/warning.png';
        textColor = colors.backGround;
        textColor = colors.backGround;
        break;
      // error
      case 3:
        background = Colors.red;
        icon = 'assets/images/warning.png';
        textColor = colors.backGround;
        textColor = colors.backGround;
        break;

      // General
      case 4:
        background = colors.backGround;
        icon = 'assets/address.svg';
        textColor = Colors.black;
        textColor = colors.backGround;
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: background,
        behavior: SnackBarBehavior.floating,
        elevation: 3,
        content: type != 5
            ? Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(icon, width: 25, color: textColor),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: width * 0.7,
                      child: Text(
                        message,
                        style: TextStyle(color: textColor),
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  SizedBox(
                    height: 35,
                    width: width * 0.8,
                    child: Center(
                      child: Text(
                        message,
                        style: TextStyles.medium14(color: colors.textColor),
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  //openGallery
  static void imagesSourcesShowModel({
    required BuildContext context,
    Function? onCameraPressed,
    Function? onGalleryPressed,
    Function? onPDFPressed,
    bool? containPDF = false,
    bool? allowMultible = false,
  }) async {
    buildCustomShowModel(
      context: context,
      height: containPDF == true ? 210.0 : 140.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.text('takePhoto'),
                  style: TextStyles.medium14(),
                ),
              ),
              onPressed: () {
                onCameraPressed!();
                //
              },
            ),
          ),
          // Gallery //
          Expanded(
            child: TextButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.text(
                    allowMultible == true ? 'selectImages' : 'selectImage',
                  ),
                  style: TextStyles.medium14(),
                ),
              ),
              onPressed: () {
                onGalleryPressed!();
              },
            ),
          ),
          containPDF == true
              ? Expanded(
                  child: TextButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        AppLocalizations.of(context)!.text('selectPDF'),
                        style: TextStyles.medium14(),
                      ),
                    ),
                    onPressed: () {
                      onPDFPressed!();
                    },
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  static void buildCustomShowModel({
    required BuildContext context,
    required Widget child,
    double? height,
    EdgeInsets? padding,
  }) async {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: colors.backGround,
          ),
          height: height,
          width: ScreenUtil().screenWidth,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16.0),
          child: child,
        );
      },
    );
  }

  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: colors.backGround,
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(50.0),
            child: CircularProgressIndicator(
              color: colors.textColor,
            ).appLoading,
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    context.pop();
  }

  static Future<int> getImageFileSize(File file) async {
    int fileSize = file.lengthSync();
    Log.d("File Size is: $fileSize");
    return fileSize;
  }

  // static void navigateTo(double lat, double lng) async {
  //   var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     throw 'Could not launch ${uri.toString()}';
  //   }
  // }
  static String getInitials(String fullName) {
    if (fullName.trim().isEmpty) return '';

    // Split by any whitespace and remove empty strings
    List<String> words = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();

    if (words.isEmpty) return '';

    // If there are at least two words, get the first character of each word
    if (words.length >= 2) {
      return words[0][0].toUpperCase() + words[1][0].toUpperCase();
    }

    // If there is only one word, return up to the first two characters capitalized
    if (words[0].length >= 2) {
      return words[0][0].toUpperCase() + words[0][1].toUpperCase();
    }

    // If only one character exists
    return words[0][0].toUpperCase();
  }

  static String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  static bool requireAuth(BuildContext context) {
    final status = context.read<SessionCubit>().state.status;

    if (status != SessionStatus.authenticated) {
      Constants.showLoginWarningDialog(
        context,
        onOkPressed: () {
          context.pushNamed(Routes.loginScreenRoute);
        },
      );
      return false;
    }
    return true;
  }

  static bool isAuth(BuildContext context) {
    return context.read<SessionCubit>().state.status ==
        SessionStatus.authenticated;
  }
}

abstract class ArabicNumeric {
  static String zero = '٠';
  static String one = '١';
  static String two = '٢';
  static String three = '٣';
  static String four = '٤';
  static String five = '٥';
  static String six = '٦';
  static String seven = '٧';
  static String eight = '٨';
  static String nine = '٩';
}
