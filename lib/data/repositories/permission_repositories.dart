import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';

class PermissionRepository {
  bool? isDenied;
  bool? isGranted;
  bool? isPermanentlyDenied;
  bool? isUnknown;
  bool? isReRequesting;

  PermissionRepository({
    this.isDenied,
    this.isGranted,
    this.isPermanentlyDenied,
    this.isUnknown,
    this.isReRequesting,
  });

  PermissionRepository.granted()
      : isDenied = false,
        isGranted = true,
        isPermanentlyDenied = false,
        isUnknown = false,
        isReRequesting = false;

  PermissionRepository.denied()
      : isDenied = true,
        isGranted = false,
        isPermanentlyDenied = false,
        isUnknown = false,
        isReRequesting = false;

  PermissionRepository.permanentlyDenied()
      : isDenied = false,
        isGranted = false,
        isPermanentlyDenied = true,
        isUnknown = false,
        isReRequesting = false;

  PermissionRepository.unknown()
      : isDenied = false,
        isGranted = false,
        isPermanentlyDenied = false,
        isUnknown = true,
        isReRequesting = false;

  PermissionRepository.waiting()
      : isDenied = false,
        isGranted = false,
        isPermanentlyDenied = false,
        isUnknown = false,
        isReRequesting = false;

  PermissionRepository.reRequesting()
      : isDenied = false,
        isGranted = false,
        isPermanentlyDenied = false,
        isUnknown = false,
        isReRequesting = true;

  @override
  String toString() {
    return 'PermissionRepository('
        'isDenied: $isDenied,'
        'isGranted: $isGranted,'
        'isPermanentlyDenied: $isPermanentlyDenied,'
        'isUnknown: $isUnknown,'
        'isReRequesting: $isReRequesting'
        ')';
  }

  PermissionRepository copyWith({
    bool? isDenied,
    bool? isGranted,
    bool? isPermanentlyDenied,
    bool? isUnknown,
    bool? isReRequesting,
  }) {
    return PermissionRepository(
      isDenied: isDenied ?? this.isDenied,
      isGranted: isGranted ?? this.isGranted,
      isPermanentlyDenied: isPermanentlyDenied ?? this.isPermanentlyDenied,
      isUnknown: isUnknown ?? this.isUnknown,
      isReRequesting: isReRequesting ?? this.isReRequesting,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PermissionRepository &&
        other.isDenied == isDenied &&
        other.isGranted == isGranted &&
        other.isPermanentlyDenied == isPermanentlyDenied &&
        other.isUnknown == isUnknown &&
        other.isReRequesting == isReRequesting;
  }

  @override
  int get hashCode {
    return isDenied.hashCode ^
        isGranted.hashCode ^
        isPermanentlyDenied.hashCode ^
        isUnknown.hashCode ^
        isReRequesting.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'isDenied': isDenied,
      'isGranted': isGranted,
      'isPermanentlyDenied': isPermanentlyDenied,
      'isUnknown': isUnknown,
      'isReRequesting': isReRequesting,
    };
  }

  factory PermissionRepository.fromMap(Map<String, dynamic> map) {
    if (map == null) return PermissionRepository();

    return PermissionRepository(
      isDenied: map['isDenied'],
      isGranted: map['isGranted'],
      isPermanentlyDenied: map['isPermanentlyDenied'],
      isUnknown: map['isUnknown'],
      isReRequesting: map['isReRequesting'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PermissionRepository.fromJson(String source) =>
      PermissionRepository.fromMap(json.decode(source));
}

class ResourceConstants {
  static List<Permission> permissionList = [
    Permission.storage,
    Permission.phone,
    Permission.location,
    Permission.sms,
    Permission.camera
  ];
}
