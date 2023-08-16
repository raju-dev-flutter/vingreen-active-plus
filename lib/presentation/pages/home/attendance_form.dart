import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vingreen_active_plus/presentation/components/app_loader.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/validation/validations.dart';
import '../../../logic/bloc/home/attendance/attendance_bloc.dart';

class AttendanceFormModel extends StatefulWidget {
  final String title;

  const AttendanceFormModel({Key? key, required this.title}) : super(key: key);

  @override
  State<AttendanceFormModel> createState() => _AttendanceFormModelState();
}

class _AttendanceFormModelState extends State<AttendanceFormModel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _askLocationPermission();
  }

  Future<void> _askLocationPermission() async {
    if (await Permission.location
        .request()
        .isDenied) {
      await Permission.location.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCheckItsPunchOut = widget.title == "Check Out";
    return BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is PunchSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "${widget.title} Successfully",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ));
            Navigator.pop(context);
          }
          if (state is PunchFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
            Navigator.pop(context);
          }
        }, builder: (context, state) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFA5A7B1),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0x60D8D8D8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.title,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: AppColor.grayColor,
                ),
                // fontSize: AppSize.SM
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                SvgPicture.asset(AppSvg.taskCalender, width: 16),
                const SizedBox(width: 6),
                Text(
                  DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: AppColor.grayColor,
                  ),
                ),
                const Spacer(),
                SvgPicture.asset(AppSvg.taskTimer, width: 18),
                const SizedBox(width: 6),
                Text(
                  DateFormat.jm().format(DateTime.now()),
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: AppColor.grayColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Description *",
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                  color: AppColor.grayColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              minLines: 5,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              enableInteractiveSelection: true,
              enableSuggestions: true,
              autofocus: true,
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
              validator: (String? argm) {
                return Validations()
                    .validateString(_descriptionController.text);
              },
            ),
            const SizedBox(height: 16),
            state is PunchButtonLoading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [showCirclerLoading(context, 40)],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CancelButton(onPressed: () => Navigator.pop(context)),
                const SizedBox(width: 10),
                isCheckItsPunchOut
                    ? CheckOutButton(onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<AttendanceBloc>(context,
                        listen: false)
                        .add(PunchOutButtonPressed(
                      description: _descriptionController.text,
                    ));
                  }
                })
                    : CheckInButton(onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<AttendanceBloc>(context,
                        listen: false)
                        .add(PunchinButtonPressed(
                      description: _descriptionController.text,
                    ));
                  }
                }),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class CheckInButton extends StatelessWidget {
  final Function() onPressed;

  const CheckInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 106,
        height: 40,
        decoration: buttonBoxDecoration(const Color(0xFFD8ED6F),
            const Color(0xFF6ABB75), const Color(0x4BA6D672)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Check In',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.secondaryColor,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(AppSvg.checkIn,
                height: 14, color: AppColor.secondaryColor),
          ],
        ),
      ),
    );
  }
}

class CheckOutButton extends StatelessWidget {
  final Function() onPressed;

  const CheckOutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 100,
        height: 40,
        decoration: buttonBoxDecoration(const Color(0xFFFFD27E),
            const Color(0xFFFF6969), const Color(0x4BFF6969)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Check Out',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.secondaryColor,
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(AppSvg.checkOut,
                height: 14, color: AppColor.secondaryColor),
          ],
        ),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  final Function() onPressed;

  const CancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 100,
        height: 40,
        alignment: Alignment.center,
        decoration: buttonBoxDecoration(const Color(0xA3BDC3C7),
            const Color(0xA3727A9A), const Color(0x2F727A9A)),
        child: Text(
          'Cancel',
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.secondaryColor,
          ),
        ),
      ),
    );
  }
}

class UpdateButton extends StatelessWidget {
  final Function() onPressed;

  const UpdateButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 106,
        height: 40,
        alignment: Alignment.center,
        decoration: buttonBoxDecoration(const Color(0xA3BDC3C7),
            const Color(0xA3727A9A), const Color(0x2F727A9A)),
        child: Text(
          'Updated',
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.secondaryColor,
          ),
        ),
      ),
    );
  }
}

buttonBoxDecoration(Color gradientFrt, Color gradientSed, Color shadow) {
  return BoxDecoration(
    gradient: LinearGradient(
        colors: [gradientFrt, gradientSed],
        begin: Alignment.topLeft,
        end: Alignment.topRight,
        transform: const GradientRotation(20)),
    borderRadius: BorderRadius.circular(4),
    boxShadow: [
      BoxShadow(
        color: shadow,
        offset: const Offset(0, 3),
        blurRadius: 6,
      )
    ],
  );
}
