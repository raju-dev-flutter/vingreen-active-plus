import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/proforma_invoice_model.dart';
import '../../../logic/bloc/proforma_invoice/proforma_invoice_bloc.dart';
import '../../components/app_loader.dart';
import 'proforma_invoice_add_page.dart';
import 'proforma_invoice_edit_page.dart';

class ProformaInvoicePage extends StatefulWidget {
  static const String id = 'proforma_invoice_page';

  const ProformaInvoicePage({Key? key}) : super(key: key);

  @override
  State<ProformaInvoicePage> createState() => _ProformaInvoicePageState();
}

class _ProformaInvoicePageState extends State<ProformaInvoicePage> {
  late ProformaInvoiceBloc proformaInvoiceBloc;

  @override
  void initState() {
    super.initState();
    proformaInvoiceBloc = BlocProvider.of<ProformaInvoiceBloc>(context);
    proformaInvoiceBloc.add(ProformaInvoiceStatus());
  }

  Future<void> refresh(BuildContext context) async {
    BlocProvider.of<ProformaInvoiceBloc>(context, listen: false)
        .add(ProformaInvoiceStatus());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: BlocBuilder<ProformaInvoiceBloc, ProformaInvoiceState>(
        builder: (context, state) {
          if (state is ProformaInvoiceLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is ProformaInvoiceFailure) {}
          if (state is ProformaInvoiceLoaded) {
            final invoice = state.proformaInvoiceList;
            return invoice.isEmpty
                ? Container()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: invoice.length,
                    itemBuilder: (_, position) {
                      return invoiceListView(context, invoice[position]);
                    });
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
      title: Text('Proforma Invoice',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppColor.secondaryColor)),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, ProformaInvoiceAddPage.id)
                .then((value) => refresh(context));
          },
          icon: SvgPicture.asset(AppSvg.add,
              width: 18, color: AppColor.secondaryColor),
        ),
      ],
    );
  }

  invoiceListView(BuildContext context, ProformaInvoiceList invoice) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: InkWell(
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
                    invoice.clientName ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    invoice.dateIssue ?? '',
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
                invoice.grandTotal ?? '',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500, color: AppColor.focusColor),
              ),
              const SizedBox(width: 24),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, ProformaInvoiceEditPage.id,
                          arguments: ProformaInvoiceEditPage(
                              proformaInvoiceId: invoice.proformaInvoiceId!))
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
  }
}
