import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/repositories/permission_repositories.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  Permission currentPermission;

  PermissionCubit({required this.currentPermission})
      : super(WaitingForPermission(
            permissionRepository: PermissionRepository.waiting()));

  void onAllPermissionGranted() {
    emit(AllPermissionsGranted(
        permissionRepository: PermissionRepository.granted()));
  }

  Future<void> checkIfPermissionNeeded() async {
    for (var _currentPermission in ResourceConstants.permissionList) {
      currentPermission = _currentPermission;
      var status = await _currentPermission.status;
      if (!status.isGranted) {
        emit(PermissionNeeded(
            permissionRepository: PermissionRepository.waiting()));
        return;
      }
    }
    onAllPermissionGranted();
  }

  Future<void> onRequestAllPermission() async {
    for (var _currentPermission in ResourceConstants.permissionList) {
      currentPermission = _currentPermission;
      var status = await _currentPermission.status;

      if (status.isDenied) {
        status = await _currentPermission.request();
        if (status.isDenied) {
          onPermissionDenied();
          return;
        }
      } else if (status.isPermanentlyDenied) {
        onPermissionPermanentlyDenied();
        return;
      } else if (status.isRestricted) {
        onPermissionRestricted();
        return;
      }
      debugPrint("Permission granted: ${currentPermission.toString()}");
    }
    for (var _currentPermission in ResourceConstants.permissionList) {
      var status = await _currentPermission.status;
      if (!status.isGranted) {
        return;
      }
    }
    onAllPermissionGranted();
  }

  void onPermissionDenied() {
    emit(PermissionDenied(
        currentPermission: currentPermission,
        permissionRepository: PermissionRepository.denied()));
  }

  void onPermissionPermanentlyDenied() {
    emit(PermissionPermanentlyDenied(
        currentPermission: currentPermission,
        permissionRepository: PermissionRepository.permanentlyDenied()));
  }

  void onPermissionRestricted() {
    emit(PermissionRestricted(
        currentPermission: currentPermission,
        permissionRepository: PermissionRepository.permanentlyDenied()));
  }

  @override
  String toString() =>
      'PermissionCubit(permissionList: ${ResourceConstants.permissionList})';
}
