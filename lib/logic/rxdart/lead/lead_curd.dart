import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/models/lead_edit_model.dart';
import '../../../data/repositories/lead_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../../cubit/lead/lead_crud/lead_crud_cubit.dart';

class LeadEditBloc {
  final leadRepositories = LeadRepositories();
  final userRepositories = UserRepositories();
  late TextEditingController fullNameEditText = TextEditingController();
  late TextEditingController mobileNumberEditText = TextEditingController();
  late TextEditingController phoneNumberEditText = TextEditingController();
  late TextEditingController emailIdEditText = TextEditingController();
  late TextEditingController alternateEmailIdEditText = TextEditingController();
  late TextEditingController ageEditText = TextEditingController();
  late TextEditingController pinCodeEditText = TextEditingController();
  late TextEditingController addressEditText = TextEditingController();

  final _fullNameEditText = BehaviorSubject<String>();
  final _mobileNumberEditText = BehaviorSubject<String>();
  final _phoneNumberEditText = BehaviorSubject<String>();
  final _emailIdEditText = BehaviorSubject<String>();
  final _alternateEmailIdEditText = BehaviorSubject<String>();
  final _ageEditText = BehaviorSubject<String>();
  final _addressEditText = BehaviorSubject<String>();
  final _pinCodeEditText = BehaviorSubject<String>();

  final _leadStageList = BehaviorSubject<List<CommonObj>>.seeded([]);
  final _leadSubStageList = BehaviorSubject<List<CommonObj>>.seeded([]);
  final _leadSourceList = BehaviorSubject<List<CommonObj>>.seeded([]);
  final _leadSubSourceList = BehaviorSubject<List<CommonObj>>.seeded([]);
  final _campaignsList = BehaviorSubject<List<CommonObj>>.seeded([]);
  final _productCategoryList = BehaviorSubject<List<CommonObj>>.seeded([]);
  final _productList = BehaviorSubject<List<CommonObj>>.seeded([]);
  final _adNameList = BehaviorSubject<List<CommonObj>>.seeded([]);
  final _mediumList = BehaviorSubject<List<CommonObj>>.seeded([]);
  final _countryList = BehaviorSubject<List<CommonObj>>.seeded([]);
  final _stateList = BehaviorSubject<List<CommonObj>>.seeded([]);
  final _cityList = BehaviorSubject<List<CommonObj>>.seeded([]);

  final _leadStageListInit = BehaviorSubject<CommonObj>();
  final _leadSubStageListInit = BehaviorSubject<CommonObj>();
  final _leadSourceListInit = BehaviorSubject<CommonObj>();
  final _leadSubSourceListInit = BehaviorSubject<CommonObj>();
  final _campaignsListInit = BehaviorSubject<CommonObj>();
  final _productCategoryListInit = BehaviorSubject<CommonObj>();
  final _productListInit = BehaviorSubject<CommonObj>();
  final _adNameListInit = BehaviorSubject<CommonObj>();
  final _mediumListInit = BehaviorSubject<CommonObj>();
  final _countryListInit = BehaviorSubject<CommonObj>();
  final _stateListInit = BehaviorSubject<CommonObj>();
  final _cityListInit = BehaviorSubject<CommonObj>();

  Stream<List<CommonObj>> get leadStageList => _leadStageList.stream;

  Stream<List<CommonObj>> get leadSubStageList => _leadSubStageList.stream;

  Stream<List<CommonObj>> get leadSourceList => _leadSourceList.stream;

  Stream<List<CommonObj>> get leadSubSourceList => _leadSubSourceList.stream;

  Stream<List<CommonObj>> get campaignsList => _campaignsList.stream;

  Stream<List<CommonObj>> get productCategoryList =>
      _productCategoryList.stream;

  Stream<List<CommonObj>> get productList => _productList.stream;

  Stream<List<CommonObj>> get adNameList => _adNameList.stream;

  Stream<List<CommonObj>> get mediumList => _mediumList.stream;

  Stream<List<CommonObj>> get countryList => _countryList.stream;

  Stream<List<CommonObj>> get stateList => _stateList.stream;

  Stream<List<CommonObj>> get cityList => _cityList.stream;

  ValueStream<CommonObj> get leadStageListInit => _leadStageListInit.stream;

  ValueStream<CommonObj> get leadSubStageListInit =>
      _leadSubStageListInit.stream;

  ValueStream<CommonObj> get leadSourceListInit => _leadSourceListInit.stream;

  ValueStream<CommonObj> get leadSubSourceListInit =>
      _leadSubSourceListInit.stream;

  ValueStream<CommonObj> get campaignsListInit => _campaignsListInit.stream;

  ValueStream<CommonObj> get productCategoryListInit =>
      _productCategoryListInit.stream;

  ValueStream<CommonObj> get productListInit => _productListInit.stream;

  ValueStream<CommonObj> get adNameListInit => _adNameListInit.stream;

  ValueStream<CommonObj> get mediumListInit => _mediumListInit.stream;

  ValueStream<CommonObj> get countryListInit => _countryListInit.stream;

  ValueStream<CommonObj> get stateListInit => _stateListInit.stream;

  ValueStream<CommonObj> get cityListInit => _cityListInit.stream;

  Future<void> fetchOptions(int leadId) async {
    dynamic jsonResponse = await leadRepositories.fetchleadEditsApi(leadId);
    LeadEditModel leadEdit = LeadEditModel.fromJson(jsonResponse);
    LeadDetail leadDetail = leadEdit.leadDetail!;
    // setValueToController(leadEdit.leadDetail!);
    fullNameEditText = TextEditingController(text: leadDetail.leadName!);
    mobileNumberEditText =
        TextEditingController(text: leadDetail.mobileNumber ?? "");
    phoneNumberEditText =
        TextEditingController(text: leadDetail.alterMobileNumber ?? "");
    emailIdEditText = TextEditingController(text: leadDetail.emailId ?? "");
    alternateEmailIdEditText =
        TextEditingController(text: leadDetail.alterEmailId ?? "");
    ageEditText = TextEditingController(text: leadDetail.age.toString());
    pinCodeEditText = TextEditingController(text: leadDetail.pincode ?? "");
    addressEditText = TextEditingController(text: leadDetail.address ?? "");

    _fullNameEditText.sink.add(leadDetail.leadName ?? "");
    _mobileNumberEditText.sink.add(leadDetail.mobileNumber ?? "");
    _phoneNumberEditText.sink.add(leadDetail.alterMobileNumber ?? "");
    _emailIdEditText.sink.add(leadDetail.emailId ?? "");
    _alternateEmailIdEditText.sink.add(leadDetail.alterEmailId ?? "");
    _ageEditText.sink.add(leadDetail.age.toString());
    _addressEditText.sink.add(leadDetail.address ?? "");
    _pinCodeEditText.sink.add(leadDetail.pincode ?? "");
    // lead Stage List
    _leadStageList.value = leadEdit.leadStages!;
    for (int i = 0; i <= _leadStageList.value.length; i++) {
      if (_leadStageList.value[i].id == leadDetail.leadStageId) {
        _leadStageListInit.sink.add(_leadStageList.value[i]);
        break;
      } else {
        _leadStageListInit.sink.add(_leadStageList.value.first);
      }
    }

    // lead Sub Stage List
    _leadSubStageList.add(leadEdit.leadSubStages!);
    for (int i = 0; i <= _leadSubStageList.value.length; i++) {
      if (_leadSubStageList.value[i].id == leadDetail.leadSubStageId) {
        _leadSubStageListInit.sink.add(_leadSubStageList.value[i]);
        break;
      } else {
        _leadSubStageListInit.sink.add(_leadSubStageList.value.first);
      }
    }

    // lead Surce List
    _leadSourceList.sink.add(leadEdit.leadSources!);
    debugPrint('SourceList : ${leadDetail.sourceId}');
    for (int i = 0; i < _leadSourceList.value.length; i++) {
      if (_leadSourceList.value[i].id == leadDetail.sourceId) {
        _leadSourceListInit.sink.add(_leadSourceList.value[i]);
        break;
      } else {
        _leadSourceListInit.sink.add(_leadSourceList.value.first);
      }
    }

    // lead Sub Surce List
    _leadSubSourceList.sink.add(leadEdit.leadSubSources!);
    debugPrint('SubSourceList : ${leadDetail.subSourceId}');
    for (int i = 0; i < _leadSubSourceList.value.length; i++) {
      if (_leadSubSourceList.value[i].id == leadDetail.subSourceId) {
        _leadSubSourceListInit.sink.add(_leadSubSourceList.value[i]);
        break;
      } else {
        _leadSubSourceListInit.sink.add(_leadSubSourceList.value.first);
      }
    }

    // lead Campaigns List
    _campaignsList.sink.add(leadEdit.campaigns!);
    debugPrint('CampaignList : ${leadDetail.campaignId}');
    for (int i = 0; i < _campaignsList.value.length; i++) {
      if (_campaignsList.value[i].id == leadDetail.campaignId) {
        _campaignsListInit.sink.add(_campaignsList.value[i]);
        break;
      } else {
        _campaignsListInit.sink.add(_campaignsList.value.first);
      }
    }

    // lead Product Category List
    _productCategoryList.sink.add(leadEdit.productsCategoryList!);
    debugPrint('ProductCategoryList : ${leadDetail.productCategoryId}');
    for (int i = 0; i < _productCategoryList.value.length; i++) {
      if (_productCategoryList.value[i].id == leadDetail.productCategoryId) {
        _productCategoryListInit.sink.add(_productCategoryList.value[i]);
        break;
      } else {
        _productCategoryListInit.sink.add(_productCategoryList.value.first);
      }
    }

    // lead Product List
    _productList.sink.add(leadEdit.productsList!);
    debugPrint('ProductList : ${leadDetail.productId}');
    for (int i = 0; i < _productList.value.length; i++) {
      if (_productList.value[i].id == leadDetail.productId) {
        _productListInit.sink.add(_productList.value[i]);
        break;
      } else {
        _productListInit.sink.add(_productList.value.first);
      }
    }

    // lead AdName List
    _adNameList.sink.add(leadEdit.adNameList!);
    debugPrint('AdNameList : ${leadDetail.adNameId}');
    for (int i = 0; i < _adNameList.value.length; i++) {
      if (_adNameList.value[i].id == leadDetail.adNameId) {
        _adNameListInit.sink.add(_adNameList.value[i]);
        break;
      } else {
        _adNameListInit.sink.add(_adNameList.value.first);
      }
    }

    // lead Medium List
    _mediumList.sink.add(leadEdit.mediumLists!);
    debugPrint('MediumList : ${leadDetail.mediumId}');
    for (int i = 0; i < _mediumList.value.length; i++) {
      if (_mediumList.value[i].id == leadDetail.mediumId) {
        _mediumListInit.sink.add(_mediumList.value[i]);
        break;
      } else {
        _mediumListInit.sink.add(_mediumList.value.first);
      }
    }

    // lead Country List
    _countryList.sink.add(leadEdit.countries!);
    debugPrint('CuntryList : ${leadDetail.countryId}');
    for (int i = 0; i < _countryList.value.length; i++) {
      if (_countryList.value[i].id == leadDetail.countryId) {
        _countryListInit.sink.add(_countryList.value[i]);
        break;
      } else {
        _countryListInit.sink.add(_countryList.value.first);
      }
    }

    // lead State List
    _stateList.sink.add(leadEdit.states!);
    debugPrint('StateList : ${leadDetail.stateId}');
    for (int i = 0; i < _stateList.value.length; i++) {
      if (_stateList.value[i].id == leadDetail.stateId) {
        _stateListInit.sink.add(_stateList.value[i]);
        break;
      } else {
        _stateListInit.sink.add(_stateList.value.first);
      }
    }

    // lead City List
    _cityList.sink.add(leadEdit.cities!);
    debugPrint('CityList : ${leadDetail.cityId}');
    for (int i = 0; i < _cityList.value.length; i++) {
      if (_cityList.value[i].id == leadDetail.cityId) {
        _cityListInit.sink.add(_cityList.value[i]);
        break;
      } else {
        _cityListInit.sink.add(_cityList.value.first);
      }
    }
  }

  void setValueToController(LeadDetail lead) {
    fullNameEditText = TextEditingController(text: lead.leadName ?? "");
    mobileNumberEditText = TextEditingController(text: lead.mobileNumber ?? "");
    phoneNumberEditText =
        TextEditingController(text: lead.alterMobileNumber ?? "");
    emailIdEditText = TextEditingController(text: lead.emailId ?? "");
    alternateEmailIdEditText =
        TextEditingController(text: lead.alterEmailId ?? "");
    ageEditText = TextEditingController(text: lead.age.toString());
    pinCodeEditText = TextEditingController(text: lead.pincode ?? "");
    addressEditText = TextEditingController(text: lead.address ?? "");

    _fullNameEditText.sink.add(lead.leadName ?? "");
    _mobileNumberEditText.sink.add(lead.mobileNumber ?? "");
    _phoneNumberEditText.sink.add(lead.alterMobileNumber ?? "");
    _emailIdEditText.sink.add(lead.emailId ?? "");
    _alternateEmailIdEditText.sink.add(lead.alterEmailId ?? "");
    _ageEditText.sink.add(lead.age.toString());
    _addressEditText.sink.add(lead.address ?? "");
    _pinCodeEditText.sink.add(lead.pincode ?? "");
  }

  void onChangedValue(String label) {
    switch (label) {
      case 'First Name':
        fullNameEditText.addListener(() {
          _fullNameEditText.add(fullNameEditText.text);
          debugPrint(_fullNameEditText.valueOrNull.toString());
        });
        break;
      case 'Mobile Number':
        mobileNumberEditText.addListener(() {
          _mobileNumberEditText.add(mobileNumberEditText.text);
          debugPrint(_mobileNumberEditText.valueOrNull.toString());
        });
        break;
      case 'Phone Number':
        phoneNumberEditText.addListener(() {
          _phoneNumberEditText.add(phoneNumberEditText.text);
          debugPrint(_phoneNumberEditText.valueOrNull.toString());
        });
        break;
      case 'Email Id':
        emailIdEditText.addListener(() {
          _emailIdEditText.add(emailIdEditText.text);
          debugPrint(_emailIdEditText.valueOrNull.toString());
        });
        break;
      case 'Alternate Email Id':
        alternateEmailIdEditText.addListener(() {
          _alternateEmailIdEditText.add(alternateEmailIdEditText.text);
          debugPrint(_alternateEmailIdEditText.valueOrNull.toString());
        });
        break;
      case 'Age':
        ageEditText.addListener(() {
          _ageEditText.add(ageEditText.text);
          debugPrint(_ageEditText.valueOrNull.toString());
        });
        break;
      case 'Address':
        addressEditText.addListener(() {
          _addressEditText.add(addressEditText.text);
          debugPrint(_addressEditText.valueOrNull.toString());
        });
        break;
      case 'Pin Code':
        pinCodeEditText.addListener(() {
          _pinCodeEditText.add(pinCodeEditText.text);
          debugPrint(_pinCodeEditText.valueOrNull.toString());
        });
        break;
      default:
    }
  }

  void leadStage(value) {
    _leadStageListInit.value.id = value;
    _leadSubStageListInit.value = CommonObj();
    _leadSubStageList.sink.add([]);
    updateSubStages(_leadStageListInit.value.id);
  }

  void updateSubStages(int stagesId) async {
    dynamic jsonResponse = await leadRepositories.fetchSubStagesApi(stagesId);
    LeadStageBasedLeadSubStage updateleadSubStage =
        LeadStageBasedLeadSubStage.fromJson(jsonResponse);
    _leadSubStageList.sink.add(updateleadSubStage.leadSubStageList!);
    if (_leadSubStageList.value.isNotEmpty) {
      _leadSubStageListInit.sink.add(_leadSubStageList.value.first);
    } else {
      _leadSubStageListInit.sink.add(CommonObj());
    }
  }

  void leadSubStage(value) {
    _leadSubStageListInit.value.id = value;
  }

  void leadSource(newValue) {
    _leadSourceListInit.value.id = newValue;
  }

  void leadSubSource(newValue) {
    _leadSubSourceListInit.value.id = newValue;
  }

  void leadCampaigns(newValue) {
    _campaignsListInit.value.id = newValue;
  }

  void leadProductCategory(newValue) {
    _productCategoryListInit.value.id = newValue;
    _productListInit.value = CommonObj();
    _productList.sink.add([]);
    updateProduct(_productCategoryListInit.value.id!);
  }

  void updateProduct(int productCategoryId) async {
    dynamic jsonResponse =
        await leadRepositories.fetchProductApi(productCategoryId);
    ProductsCategoryBasedProducts products =
        ProductsCategoryBasedProducts.fromJson(jsonResponse);
    // lead Product List
    if (products.productList != null) {
      _productList.sink.add(products.productList!);
      _productListInit.sink.add(_productList.value.first);
    }
  }

  void leadProduct(newValue) {
    _productListInit.value.id = newValue;
  }

  void leadAdName(newValue) {
    _adNameListInit.value.id = newValue;
  }

  void leadMedium(newValue) {
    _mediumListInit.value.id = newValue;
  }

  void leadCountry(newValue) {
    _countryListInit.value.id = newValue;
    _stateListInit.value = CommonObj();
    _stateList.sink.add([]);
    updateState(_countryListInit.value.id!);
  }

  void updateState(int countryId) async {
    dynamic jsonResponse = await leadRepositories.fetchStateApi(countryId);
    CountryBasedState states = CountryBasedState.fromJson(jsonResponse);
    // lead State List
    if (states.stateLists != null) {
      _stateList.sink.add(states.stateLists!);
      _stateListInit.sink.add(_stateList.value.first);
    }
  }

  void leadState(newValue) {
    _stateListInit.value.id = newValue;
    _cityListInit.sink.add(CommonObj());
    _cityList.sink.add([]);
    updateCity(_stateListInit.value.id!);
  }

  void updateCity(int stateId) async {
    dynamic jsonResponse = await leadRepositories.fetchCityApi(stateId);
    StateBasedCity cities = StateBasedCity.fromJson(jsonResponse);
    // lead City List
    if (cities.citiesLists != null) {
      _cityList.sink.add(cities.citiesLists!);
      _cityListInit.sink.add(_cityList.value.first);
    }
  }

  void leadCity(newValue) {
    _cityListInit.value.id = newValue;
  }

  Future<void> uploadLeadUpdateDetails(BuildContext _, int leadId) async {
    final userId = await userRepositories.hasUserId();
    final leadCrudCubit = BlocProvider.of<LeadCrudCubit>(_, listen: false);

    Map data = {
      'updated_by': userId,
      'lead_id': leadId,
      'lead_name': _fullNameEditText.valueOrNull,
      'mobile_number': _mobileNumberEditText.valueOrNull,
      'alter_mobile_number': _phoneNumberEditText.valueOrNull,
      'email_id': _emailIdEditText.valueOrNull,
      'alter_email_id': _alternateEmailIdEditText.valueOrNull,
      'age': int.parse(_ageEditText.valueOrNull!),
      'medium_id': mediumListInit.valueOrNull!.id,
      'source_id': leadSourceListInit.valueOrNull!.id,
      'sub_source_id': leadSubSourceListInit.valueOrNull!.id,
      'lead_stage_id': leadStageListInit.valueOrNull!.id,
      'lead_sub_stage_id': leadSubStageListInit.valueOrNull!.id,
      'campaign_id': campaignsListInit.valueOrNull!.id,
      // 'lead_owner': leadDetails.leadOwner,
      'ad_name_id': adNameListInit.valueOrNull!.id,
      'product_category_id': productCategoryListInit.valueOrNull!.id,
      'product_id': productListInit.valueOrNull!.id,
      'country_id': countryListInit.valueOrNull!.id,
      'state_id': stateListInit.valueOrNull!.id,
      'city_id': cityListInit.valueOrNull!.id,
      'pincode': _addressEditText.valueOrNull,
      'address': _pinCodeEditText.valueOrNull,
    };

    debugPrint(data.toString());
    leadCrudCubit.uploadLeadEditDetails(data);
  }

  void dispose() {
    _leadStageList.close();
    _leadStageListInit.close();
    _leadSubStageList.close();
    _leadSubStageListInit.close();
  }
}
