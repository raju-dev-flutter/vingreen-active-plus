import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/repositories/petty_cash_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../../cubit/petty_cash/petty_cash_crud_cubit.dart';

class PettyCashRxBloc {
  final userRepositories = UserRepositories();
  final pettyCashRepositories = PettyCashRepositories();

  late TextEditingController message = TextEditingController();

  // final _deleteId = BehaviorSubject<int>();
  final _deleteMessage = BehaviorSubject<String>.seeded('');

  // ValueStream<int> get deleteId => _deleteId.stream;

  ValueStream<String> get deleteMessage => _deleteMessage.stream;

  void onChangedValue() {
    message.addListener(() {
      _deleteMessage.add(message.text);
      debugPrint(_deleteMessage.valueOrNull.toString());
    });
  }

  Future<void> deletePettyCash(BuildContext _, dynamic pettyCashId) async {
    final userId = await userRepositories.hasUserId();
    final pettyCash = BlocProvider.of<PettyCashCrudCubit>(_, listen: false);

    Map map = {
      'user_id': userId,
      'pettycash_id': pettyCashId,
      'deleted_reason': _deleteMessage.valueOrNull,
    };

    pettyCash.submitPettyCashDelete(map);
  }
}
