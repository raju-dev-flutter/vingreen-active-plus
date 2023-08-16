import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class UserRepositories { 
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> hasToken() async {
    var value = await storage.read(key: 'token');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> hasUserId() async {
    var value = await storage.read(key: 'id');
    return value!;
  }

  Future<bool> hasPermissionToken() async {
    var value = await storage.read(key: 'appPermission');
    if (value == 'true') {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> hasMethodChannel() async {
    var value = await storage.read(key: 'methodChannel');
    if (value == 'Success') {
      return true;
    } else {
      return false;
    }
  }
  
  Future<User> hasUserDetails() async {
    final String? userId = await storage.read(key: 'userId');
    final String? userPic = await storage.read(key: 'UserPic');
    final String? email = await storage.read(key: 'email');
    final String? mobileNo = await storage.read(key: 'mobileNo');
    final String? designation = await storage.read(key: 'designation');

    return User(
      id: int.parse(userId!),
      profileUpload: userPic,
      email: email,
      personalMobileNumber: mobileNo,
      designationId: designation,
    );
  }

  Future<void> persisteToken(String token, String userId) async {
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'id', value: userId);
  }

  Future<void> persisteUserDetails(User user) async {
    await storage.write(key: 'userId', value: user.id.toString());
    await storage.write(key: 'userPic', value: user.profileUpload.toString());
    await storage.write(key: 'email', value: user.email.toString());
    await storage.write(
        key: 'mobileNo', value: user.personalMobileNumber.toString());
    await storage.write(
        key: 'designation', value: user.designationId.toString());
  }

  Future<void> persistePermissionToken(String appPermission) async {
    await storage.write(key: 'appPermission', value: appPermission);
  }
  
  Future<void> setmethodChannel(String method) async {
    await storage.write(key: 'methodChannel', value: method);
  }

  Future<void> deletemethodChannel(String method) async {
    storage.delete(key: 'methodChannel'); 
  }


  Future<void> deleteToken() async {
    storage.delete(key: 'token');
  }

  Future<void> deleteAll() async {
    storage.deleteAll();
  }
}
