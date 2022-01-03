import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  // Future<void> cameraAndMicrophonePermissionsGranted() async {
  //   await [
  //     Permission.microphone,
  //     Permission.camera,
  //   ].request();
  // }

  //  Future<void> contactsPermissionsGranted() async {
  //   await Permission.contacts.request();
  // }

  Future<bool> cameraAndMicrophonePermissionsGranted() async {
    var cameraPermissionStatus = await _getCameraPermission();
    var microphonePermissionStatus = await _getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(
          cameraPermissionStatus, microphonePermissionStatus);
      return false;
    }
  }

  Future<bool> contactPermissionsGranted() async {
    var contactPermissionStatus = await _getContactPermission();

    if (contactPermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissionsContact(contactPermissionStatus);
      return false;
    }
  }

  Future<PermissionStatus> _getCameraPermission() async {
    var permission = await Permission.camera.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      return permission;
    } else {
      var permissionStatus =
          await [Permission.camera, Permission.storage].request();
      return permissionStatus[Permission.camera] ??
          PermissionStatus.permanentlyDenied;
    }
  }

  Future<PermissionStatus> _getMicrophonePermission() async {
    var permission = await Permission.microphone.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      return permission;
    } else {
      var permissionStatus = await [Permission.microphone].request();
      return permissionStatus[Permission.microphone] ??
          PermissionStatus.permanentlyDenied;
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    var permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      return permission;
    } else {
      var permissionStatus = await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.permanentlyDenied;
    }
  }

  void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and microphone denied",
          details: null);
    } else if (cameraPermissionStatus == PermissionStatus.permanentlyDenied &&
        microphonePermissionStatus == PermissionStatus.permanentlyDenied) {
      throw PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  void _handleInvalidPermissionsContact(
    PermissionStatus contactPermissionStatus,
  ) {
    if (contactPermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to contact denied",
          details: null);
    } else if (contactPermissionStatus == PermissionStatus.permanentlyDenied) {
      throw PlatformException(
          code: "PERMISSION_DISABLED",
          message: "data is not available on device",
          details: null);
    }
  }
}
