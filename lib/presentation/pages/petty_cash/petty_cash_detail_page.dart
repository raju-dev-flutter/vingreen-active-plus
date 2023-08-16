import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/pettycash_model.dart';

class PettyCashDetailPage extends StatefulWidget {
  final ExpenseList expense;
  static const String id = 'pettycash_detail_page';

  const PettyCashDetailPage({Key? key, required this.expense})
      : super(key: key);

  @override
  State<PettyCashDetailPage> createState() => _PettyCashDetailPageState();
}

class _PettyCashDetailPageState extends State<PettyCashDetailPage> {
  final GlobalKey gKey = GlobalKey();

  Uint8List? imageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RepaintBoundary(
              key: gKey,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(width: .5, color: AppColor.focusColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.expense.amount.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.expense.amount.toString() == 'null'
                          ? ''
                          : NumberToWord().convert('en-in',
                              int.parse(widget.expense.amount.toString())),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'To',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.expense.userId ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.expense.particulars ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'From Your',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vingreen Tech',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.expense.pettycashDate == null
                          ? ''
                          : "Paid at: ${widget.expense.pettycashDate}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.expense.pettycashId == null
                          ? ''
                          : "Order id: ${widget.expense.pettycashId}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFFFFFFF),
                border: Border.all(width: .5, color: AppColor.focusColor),
              ),
              child: Row(
                children: [
                  Text(
                    'View Payment Receipt',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  SvgPicture.asset(AppSvg.arrowFrd, color: AppColor.grayColor)
                ],
              ),
            )
          ],
        ),
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
      title: Text('Petty Cash Details',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppColor.secondaryColor)),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () async {
            RenderRepaintBoundary boundary = gKey.currentContext!
                .findRenderObject() as RenderRepaintBoundary;
            ui.Image image = await boundary.toImage(pixelRatio: 3);
            ByteData? byte =
                await image.toByteData(format: ui.ImageByteFormat.png);

            setState(() {
              imageData = byte!.buffer.asUint8List();
            });

            final directory = await getApplicationDocumentsDirectory();
            final imagePath = await File(
                    '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png')
                .create();
            await imagePath.writeAsBytes(imageData!);

            debugPrint("=======: ${imagePath.toString()}");
            await Share.shareXFiles([XFile(imagePath.path)],
                text: 'Great picture');
          },
          child: Text(
            'share',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: AppColor.secondaryColor),
          ),
        ),
      ],
    );
  }
}
