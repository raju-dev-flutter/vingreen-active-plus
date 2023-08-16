part of 'permission_cubit.dart';

abstract class PermissionState extends Equatable {
  final Permission currentPermission;
  final PermissionRepository permissionRepository;
  const PermissionState(
      {required this.currentPermission, required this.permissionRepository});

  @override
  List<Object> get props => [currentPermission, permissionRepository];
}

class WaitingForPermission extends PermissionState {
  final PermissionRepository permissionRepository;
  WaitingForPermission({required this.permissionRepository})
      : super(
            currentPermission: Permission.unknown,
            permissionRepository: PermissionRepository.waiting());
}

class AllPermissionsGranted extends PermissionState {
  final PermissionRepository permissionRepository;
  AllPermissionsGranted({required this.permissionRepository})
      : super(
            currentPermission: Permission.unknown,
            permissionRepository: PermissionRepository.granted());
}

class PermissionDenied extends PermissionState {
  final PermissionRepository permissionRepository;
  PermissionDenied(
      {required this.permissionRepository,
      required Permission currentPermission})
      : super(
            currentPermission: Permission.unknown,
            permissionRepository: PermissionRepository.denied());
}

class PermissionPermanentlyDenied extends PermissionState {
  final PermissionRepository permissionRepository;
  PermissionPermanentlyDenied(
      {required this.permissionRepository,
      required Permission currentPermission})
      : super(
            currentPermission: Permission.unknown,
            permissionRepository: PermissionRepository.permanentlyDenied());
}

class PermissionRestricted extends PermissionState {
  final PermissionRepository permissionRepository;
  PermissionRestricted(
      {required this.permissionRepository,
      required Permission currentPermission})
      : super(
            currentPermission: Permission.unknown,
            permissionRepository: PermissionRepository.permanentlyDenied());
}

class PermissionNeeded extends PermissionState {
  final PermissionRepository permissionRepository;
  PermissionNeeded({required this.permissionRepository})
      : super(
            currentPermission: Permission.unknown,
            permissionRepository: PermissionRepository.reRequesting());
}
