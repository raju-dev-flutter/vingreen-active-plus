import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/models/user_detail_model.dart';
import '../../../data/repositories/profile_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../../cubit/profile_update_form/profile_update_form_cubit.dart';

class ProfileUpdateBloc {
  final userRepositories = UserRepositories();
  final profileRepositories = ProfileRepositories();

  final ImagePicker imagePicker = ImagePicker();

  late TextEditingController firstName = TextEditingController();
  late TextEditingController lastName = TextEditingController();
  late TextEditingController mobileNumber = TextEditingController();
  late TextEditingController emgContectNumber = TextEditingController();
  late TextEditingController address = TextEditingController();
  late TextEditingController pinCode = TextEditingController();

  final _firstNameSubject = BehaviorSubject<String>();
  final _lastNameSubject = BehaviorSubject<String>();
  final _mobileNumberSubject = BehaviorSubject<String>();
  final _emgContectNumberSubject = BehaviorSubject<String>();
  final _addressSubject = BehaviorSubject<String>();
  final _pinCodeSubject = BehaviorSubject<String>();

  final _profileImg = BehaviorSubject<String>();
  final _pictedImage = BehaviorSubject<XFile>();

  Stream<String> get profileImg => _profileImg.stream;

  Stream<XFile> get pictedImage => _pictedImage.stream;

  Future<void> getProfileDetails() async {
    final String userId = await userRepositories.hasUserId();
    try {
      dynamic jsonResponse =
          await profileRepositories.fetchUserDetailsApi(userId);
      final UserDetails userDetails = jsonResponse;
      final splitted = userDetails.userName?.split(' ');

      _profileImg.sink.add(userDetails.profileUpload!);
      firstName = TextEditingController(text: splitted?[0] ?? '');
      lastName = TextEditingController(text: splitted?[1] ?? '');
      mobileNumber =
          TextEditingController(text: userDetails.personalMobileNumber ?? '');
      emgContectNumber =
          TextEditingController(text: userDetails.emergencyContactNumber ?? '');
      address = TextEditingController(text: userDetails.address ?? '');
      pinCode =
          TextEditingController(text: userDetails.pinCode.toString() ?? '');

      _firstNameSubject.sink.add(splitted?[0] ?? '');
      _lastNameSubject.sink.add(splitted?[1] ?? '');
      _mobileNumberSubject.sink.add(userDetails.personalMobileNumber ?? '');
      _emgContectNumberSubject.sink
          .add(userDetails.emergencyContactNumber ?? '');
      _addressSubject.sink.add(userDetails.address ?? '');
      _pinCodeSubject.sink.add(userDetails.pinCode.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onChangedValue(String label) {
    switch (label) {
      case 'First Name':
        firstName.addListener(() {
          _firstNameSubject.add(firstName.text);
          debugPrint(_firstNameSubject.valueOrNull.toString());
        });
        break;
      case 'Last Name':
        lastName.addListener(() {
          _lastNameSubject.add(lastName.text);
          debugPrint(_lastNameSubject.valueOrNull.toString());
        });
        break;
      case 'Mobile Number':
        mobileNumber.addListener(() {
          _mobileNumberSubject.add(mobileNumber.text);
          debugPrint(_mobileNumberSubject.valueOrNull.toString());
        });
        break;
      case 'Emergency Mobile Number':
        emgContectNumber.addListener(() {
          _emgContectNumberSubject.add(emgContectNumber.text);
          debugPrint(_emgContectNumberSubject.valueOrNull.toString());
        });
        break;
      case 'Address':
        address.addListener(() {
          _addressSubject.add(address.text);
          debugPrint(_pinCodeSubject.valueOrNull.toString());
        });
        break;
      case 'Pin Code':
        pinCode.addListener(() {
          _pinCodeSubject.add(pinCode.text);
          debugPrint(_pinCodeSubject.valueOrNull.toString());
        });
        break;
      default:
    }
  }

  void openGamera() async {
    final pictedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        maxHeight: 500,
        maxWidth: 500);
    _pictedImage.sink.add(pictedFile!);
  }

  void openGallery() async {
    final pictedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxHeight: 500,
        maxWidth: 500);

    _pictedImage.sink.add(pictedFile!);
  }

  Future<void> uploadProfileDetails(BuildContext _) async {
    final String userId = await userRepositories.hasUserId();
    final profileUpdateCubit =
        BlocProvider.of<ProfileUpdateFormCubit>(_, listen: false);
    Map data = {
      'id': userId,
      'first_name': _firstNameSubject.valueOrNull,
      'last_name': _lastNameSubject.valueOrNull,
      'personal_mobile_number': _mobileNumberSubject.valueOrNull,
      'emergency_contact_number': _emgContectNumberSubject.valueOrNull,
      'pin_code': int.parse(_pinCodeSubject.valueOrNull.toString()),
      'address': _addressSubject.valueOrNull,
    };

    debugPrint(_pictedImage.valueOrNull?.path ?? _profileImg.value);
    Map<String, String> userImage = {'id': userId};

    profileUpdateCubit.uploadUserDetails(
        data, userImage, _pictedImage.valueOrNull);
  }
}
