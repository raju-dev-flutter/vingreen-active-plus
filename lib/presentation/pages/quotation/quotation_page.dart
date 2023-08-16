import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vingreen_active_plus/data/models/quotation_model.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../logic/bloc/quotation/quotation_bloc.dart';
import '../../components/app_loader.dart';
import 'quotation_add_page.dart';
import 'quotation_edit_page.dart';

class QuotationPage extends StatefulWidget {
  static const String id = 'quotation_page';

  const QuotationPage({Key? key}) : super(key: key);

  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  late QuotationBloc quotationBloc;

  @override
  void initState() {
    super.initState();
    quotationBloc = BlocProvider.of<QuotationBloc>(context);
    quotationBloc.add(QuotationStatus());
  }

  Future<void> refresh(BuildContext context) async {
    BlocProvider.of<QuotationBloc>(context, listen: false)
        .add(QuotationStatus());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: BlocBuilder<QuotationBloc, QuotationState>(
        builder: (context, state) {
          if (state is QuotationLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is QuotationFailure) {}
          if (state is QuotationLoaded) {
            return state.quotationList.isEmpty
                ? Container()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: state.quotationList.length,
                    itemBuilder: (_, index) =>
                        quotationListView(context, state.quotationList[index]),
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
      title: Text('Quotation',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppColor.secondaryColor)),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: (() => Navigator.pushNamed(context, QuotationAddPage.id)
              .whenComplete(() => refresh(context))),
          icon: SvgPicture.asset(AppSvg.add,
              width: 18, color: AppColor.secondaryColor),
        ),
      ],
    );
  }

  quotationListView(BuildContext context, QuotationList data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: InkWell(
        // onTap: (() => Navigator.pushNamed(context, PettyCashDetailPage.id,
        //     arguments: PettyCashDetailPage(expense: data))),
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
                    data.clientName ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.dateIssue ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColor.grayColor),
                  ),
                ],
              ),
              const Spacer(),
              SvgPicture.asset(AppSvg.indianRupee,
                  width: 8, color: AppColor.focusColor),
              const SizedBox(width: 4),
              Text(
                data.grandTotal ?? '',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500, color: AppColor.focusColor),
              ),
              const SizedBox(width: 24),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, QuotationEditPage.id,
                          arguments:
                              QuotationEditPage(quotationId: data.quotationId!))
                      .whenComplete(() => refresh(context));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColor.focusColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Edit',
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
    ;
  }
}
