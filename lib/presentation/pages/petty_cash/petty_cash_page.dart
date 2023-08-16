import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vingreen_active_plus/presentation/pages/petty_cash/petty_cash_add_page.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/pettycash_model.dart';
import '../../../data/validation/validations.dart';
import '../../../logic/bloc/petty_cash/petty_cash_bloc.dart';
import '../../../logic/rxdart/petty_cash/petty_cash_bloc.dart';
import '../../components/app_loader.dart';
import 'petty_cash_detail_page.dart';

class PettyCashPage extends StatefulWidget {
  static const String id = 'petty_cash_page';

  const PettyCashPage({Key? key}) : super(key: key);

  @override
  State<PettyCashPage> createState() => _PettyCashPageState();
}

class _PettyCashPageState extends State<PettyCashPage> {
  final PettyCashRxBloc pettyCashRxBloc = PettyCashRxBloc();
  late PettyCashBloc pettyCashBloc;

  @override
  void initState() {
    super.initState();
    pettyCashBloc = BlocProvider.of<PettyCashBloc>(context);
    pettyCashBloc.add(PettyCashStatus());
  }

  Future<void> refresh(BuildContext context) async {
    BlocProvider.of<PettyCashBloc>(context, listen: false)
        .add(PettyCashStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: BlocBuilder<PettyCashBloc, PettyCashState>(
        builder: (context, state) {
          if (state is PettyCashLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is PettyCashFailure) {}
          if (state is PettyCashLoaded) {
            return state.expenseList.isEmpty
                ? Container()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: state.expenseList.length,
                    itemBuilder: (_, index) =>
                        pettyCashListView(context, state.expenseList[index]),
                  );
          }
          return Container();
        },
      ),
    );
  }

  appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appColor,
      elevation: 0,
      leading: IconButton(
          onPressed: (() => Navigator.pop(context)),
          icon: const Icon(Icons.arrow_back_rounded)),
      title: Text('Petty Cash',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppColor.secondaryColor)),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: (() => Navigator.pushNamed(context, PettyCashAddPage.id)
              .whenComplete(() => refresh(context))),
          icon: SvgPicture.asset(AppSvg.add,
              width: 18, color: AppColor.secondaryColor),
        ),
      ],
    );
  }

  pettyCashListView(BuildContext context, ExpenseList data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: InkWell(
        onTap: (() => Navigator.pushNamed(context, PettyCashDetailPage.id,
            arguments: PettyCashDetailPage(expense: data))),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFFFFFFF),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0800366D),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.userId ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.pettycashDate ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColor.grayColor),
                  ),
                ],
              ),
              const Spacer(),
              SvgPicture.asset(AppSvg.indianRupee,
                  width: 8, color: AppColor.warningColor),
              const SizedBox(width: 4),
              Text(
                data.amount.toString(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500, color: AppColor.warningColor),
              ),
              const SizedBox(width: 24),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      letterSpacing: 1,
                                      color: AppColor.grayColor),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: pettyCashRxBloc.message,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              enableSuggestions: true,
                              obscureText: false,
                              enableInteractiveSelection: true,
                              decoration: textInputDecoration('Description'),
                              onChanged: (val) {
                                pettyCashRxBloc.onChangedValue();
                              },
                              validator: (String? valid) {
                                return Validations().validateString(
                                    pettyCashRxBloc.message.text);
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              pettyCashRxBloc.deletePettyCash(
                                  context, data.pettycashId!);
                              pettyCashRxBloc.message.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  ).whenComplete(() => refresh(context));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColor.focusColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'delete',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColor.focusColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  textInputDecoration(String? label) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.focusColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.errorColor),
      ),
      hintText: label,
      hintStyle:
          const TextStyle(fontFamily: 'Roboto', fontSize: 14, letterSpacing: 1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }
}
