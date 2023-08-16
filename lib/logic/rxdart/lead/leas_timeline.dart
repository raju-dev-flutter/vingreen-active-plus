import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/lead_edit_model.dart';
import '../../../data/repositories/lead_repositories.dart';
import '../../../data/repositories/user_repositories.dart';

class LeadTimelineBloc {
  final leadRepositories = LeadRepositories();
  final userRepositories = UserRepositories();

  late TextEditingController description = TextEditingController();

  final _description = BehaviorSubject<String>();

  final _leadStageList = BehaviorSubject<List<CommonObj>>.seeded([]);
  final _leadSubStageList = BehaviorSubject<List<CommonObj>>.seeded([]);

  final _leadCommunicationMediumList =
      BehaviorSubject<List<CommonObj>>.seeded([]);
  final _leadCommunicationMediumTypeList =
      BehaviorSubject<List<CommonObj>>.seeded([]);

  final _leadStageListInit = BehaviorSubject<CommonObj>();
  final _leadSubStageListInit = BehaviorSubject<CommonObj>();
  final _leadCommunicationMediumListInit = BehaviorSubject<CommonObj>();
  final _leadCommunicationMediumTypeListInit = BehaviorSubject<CommonObj>();

  Stream<List<CommonObj>> get leadStageList => _leadStageList.stream;

  Stream<List<CommonObj>> get leadSubStageList => _leadSubStageList.stream;

  Stream<List<CommonObj>> get leadCommunicationMediumList =>
      _leadCommunicationMediumList.stream;

  Stream<List<CommonObj>> get leadCommunicationMediumTypeList =>
      _leadCommunicationMediumTypeList.stream;

  ValueStream<CommonObj> get leadStageListInit => _leadStageListInit.stream;

  ValueStream<CommonObj> get leadSubStageListInit =>
      _leadSubStageListInit.stream;

  ValueStream<CommonObj> get leadCommunicationMediumListInit =>
      _leadCommunicationMediumListInit.stream;

  ValueStream<CommonObj> get leadCommunicationMediumTypeListInit =>
      _leadCommunicationMediumTypeListInit.stream;

  Future<void> fetchLeadData(String leadId) async {
    dynamic jsonResponse = await leadRepositories.fetchleadEditsApi(leadId);
    LeadEditModel leadEdit = LeadEditModel.fromJson(jsonResponse);
    LeadDetail leadDetail = leadEdit.leadDetail!;

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
  }

  void performAction(
      {required String communicationMedium, required String mobileNo}) {
    if (communicationMedium != "") {
      if (communicationMedium == "SMS") {
        makeASms(mobileNo);
      } else if (communicationMedium == "WhatsApp") {
        makeAWhatsAppMsg(mobileNo);
      } else if (communicationMedium == "Phone Call") {
        makeAPhoneCall(mobileNo);
      }
    }
  }

  void makeASms(String mobileNo) async {
    final Uri url = Uri(scheme: 'sms', path: mobileNo);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void makeAWhatsAppMsg(String mobileNo) async {
    var url = "whatsapp://send?phone=+91$mobileNo&text=hi";
    // var url = "https://wa.me/+91$mobileNo";
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void makeAPhoneCall(String mobileNo) async {
    final Uri launchUri = Uri(scheme: 'tel', path: mobileNo);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  void onChangedValue() {
    description.addListener(() {
      _description.add(description.text);
    });
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

  void fetchCommunicationMediumApi() async {
    dynamic jsonResponse = await leadRepositories.fetchCommunicationMediumApi();

    CommunicationMedium communicationMedium =
        CommunicationMedium.fromJson(jsonResponse);
    _leadCommunicationMediumList.sink
        .add(communicationMedium.communicationMediums!);

    if (_leadCommunicationMediumList.value.isNotEmpty) {
      _leadCommunicationMediumListInit.sink
          .add(_leadCommunicationMediumList.value.first);
    } else {
      _leadCommunicationMediumListInit.sink.add(CommonObj());
    }
  }

  void leadCommunicationmedium(newValue) {
    _leadCommunicationMediumListInit.value = newValue;
  }

  void fetchCommunicationmediumType() async {
    dynamic jsonResponse =
        await leadRepositories.fetchCommunicationMediumTypeApi();

    CommunicationType communicationType =
        CommunicationType.fromJson(jsonResponse);

    _leadCommunicationMediumTypeList.sink
        .add(communicationType.communicationTypes!);
    if (_leadCommunicationMediumTypeList.value.isNotEmpty) {
      _leadCommunicationMediumTypeListInit.sink
          .add(_leadCommunicationMediumTypeList.value.first);
    } else {
      _leadCommunicationMediumTypeListInit.sink.add(CommonObj());
    }
  }

  void leadCommunicationmediumType(newValue) {
    _leadCommunicationMediumListInit.value = newValue;
  }

  Future<void> uploadLeadTimelineDetails(
      BuildContext context, String leadId) async {
    final userId = await userRepositories.hasUserId();
    Map body = {
      'created_by': userId,
      'lead_id': leadId,
      'timeline_for': 'lead',
      'lead_stage_id': leadStageListInit.valueOrNull!.id ?? 1,
      'lead_sub_stage_id': leadSubStageListInit.valueOrNull!.id ?? 1,
      'communication_medium_id':
          leadCommunicationMediumListInit.valueOrNull!.id ?? 1,
      'communication_medium_type_id':
          leadCommunicationMediumTypeListInit.valueOrNull!.id ?? 1,
      'description': _description.valueOrNull,
    };

    debugPrint(body.toString());
  }
}
