import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum OtpResultStatus { codeSent, autoVerified, verified }

class OtpResult {
  final OtpResultStatus status;
  final String? verificationId;

  OtpResult({required this.status, this.verificationId});
}

/// Custom Exception for OTP verification
class OtpVerificationException implements Exception {
  final String code;

  OtpVerificationException(this.code);

  @override
  String toString() => code;
}

/// Abstract OTP service
abstract class OtpVerificationService {
  Future<OtpResult> sendOtp(String phoneNumber);
  Future<OtpResult> verifyOtp(String verificationId, String otp);
  Future<OtpResult> resendOtp(String phoneNumber);
}

/// Firebase OTP implementation
class FirebaseOtpVerificationService implements OtpVerificationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _lastVerificationId;
  int? _resendToken;

  // String _normalizePhone(String phoneNumber) {
  //   return phoneNumber.replaceAll(RegExp(r'\s+'), '');
  // }

  // bool _isValidE164Phone(String phoneNumber) {
  //   return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(phoneNumber);
  // }

  @override
  Future<OtpResult> sendOtp(String phoneNumber) async {
    final completer = Completer<OtpResult>();
    if (kDebugMode) {
      await _auth.setSettings(appVerificationDisabledForTesting: true);
    }
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 90),

      /// ✅ AUTO VERIFIED (SUCCESS)
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);

        if (!completer.isCompleted) {
          completer.complete(OtpResult(status: OtpResultStatus.autoVerified));
        }
      },

      /// ❌ FAILED
      verificationFailed: (FirebaseAuthException e) {
        log(
          'Phone verification failed: ${e.code} ${e.message}',
          name: 'FirebaseOtp',
        );
        debugPrint('[FirebaseOtp] verificationFailed');
        debugPrint('[FirebaseOtp] code: ${e.code}');
        debugPrint('[FirebaseOtp] message: ${e.message}');
        debugPrint('[FirebaseOtp] plugin: ${e.plugin}');
        if (!completer.isCompleted) {
          completer.completeError(_mapFirebaseError(e));
        }
      },

      /// 📩 CODE SENT
      codeSent: (String verificationId, int? resendToken) {
        _lastVerificationId = verificationId;
        _resendToken = resendToken;
        log('verificationId: $_lastVerificationId');

        if (!completer.isCompleted) {
          completer.complete(
            OtpResult(
              status: OtpResultStatus.codeSent,
              verificationId: verificationId,
            ),
          );
        }
      },

      /// ⏱ TIMEOUT
      codeAutoRetrievalTimeout: (String verificationId) {
        _lastVerificationId = verificationId;

        if (!completer.isCompleted) {
          completer.complete(
            OtpResult(
              status: OtpResultStatus.codeSent,
              verificationId: verificationId,
            ),
          );
        }
      },

      /// 🔁 IMPORTANT FOR RESEND
      forceResendingToken: _resendToken,
    );

    return await completer.future;
  }

  @override
  Future<OtpResult> verifyOtp(String verificationId, String otp) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      return OtpResult(status: OtpResultStatus.verified);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    } catch (e) {
      throw OtpVerificationException('UNKNOWN_ERROR');
    }
  }

  @override
  Future<OtpResult> resendOtp(String phoneNumber) async {
    if (_resendToken == null) {
      throw OtpVerificationException('RESEND_NOT_AVAILABLE');
    }

    return sendOtp(phoneNumber);
  }

  /// 🔥 CENTRALIZED ERROR MAPPING
  OtpVerificationException _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-verification-code':
        return OtpVerificationException('INVALID_OTP');
      case 'session-expired':
        return OtpVerificationException('OTP_EXPIRED');
      case 'too-many-requests':
        return OtpVerificationException('TOO_MANY_REQUESTS');
      case 'invalid-phone-number':
        return OtpVerificationException('INVALID_PHONE');
      case 'network-request-failed':
        return OtpVerificationException('NETWORK_ERROR');
      case 'quota-exceeded':
        return OtpVerificationException('QUOTA_EXCEEDED');
      case 'app-not-authorized':
      case 'operation-not-allowed':
        return OtpVerificationException('APP_NOT_AUTHORIZED');
      case 'missing-client-identifier':
      case 'captcha-check-failed':
      case 'web-context-cancelled':
        return OtpVerificationException('CAPTCHA_FAILED');
      default:
        return OtpVerificationException('UNKNOWN_ERROR');
    }
  }
}

/// Manager class to handle verification state
class OtpVerificationManager {
  final OtpVerificationService _service;
  String? _verificationId;

  OtpVerificationManager(this._service);

  Future<OtpResult> sendOtp(String phoneNumber) async {
    final result = await _service.sendOtp(phoneNumber);

    if (result.verificationId != null) {
      _verificationId = result.verificationId;
    }

    return result;
  }

  /// Verify OTP using stored verificationId
  Future<OtpResult> verifyOtp(String otp) async {
    if (_verificationId == null) {
      throw OtpVerificationException('NO_VERIFICATION_ID');
    }

    return _service.verifyOtp(_verificationId!, otp);
  }

  /// Resend OTP
  Future<OtpResult> resendOtp(String phoneNumber) async {
    final result = await _service.resendOtp(phoneNumber);

    if (result.verificationId != null) {
      _verificationId = result.verificationId;
    }

    return result;
  }
}
