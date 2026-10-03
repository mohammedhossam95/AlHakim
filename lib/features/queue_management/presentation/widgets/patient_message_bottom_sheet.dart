import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/patient_message_cubit/patient_message_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Lets the doctor or secretary write a message to their patients, either as
/// a push notification or as a notice on the queue tracking page.
class PatientMessageBottomSheet extends StatefulWidget {
  final String doctorId;
  final PatientMessageType type;

  const PatientMessageBottomSheet({
    super.key,
    required this.doctorId,
    required this.type,
  });

  static Future<void> show(
    BuildContext context, {
    required String doctorId,
    required PatientMessageType type,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => ServiceLocator.instance<PatientMessageCubit>(),
        child: PatientMessageBottomSheet(doctorId: doctorId, type: type),
      ),
    );
  }

  @override
  State<PatientMessageBottomSheet> createState() =>
      _PatientMessageBottomSheetState();
}

class _PatientMessageBottomSheetState extends State<PatientMessageBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  bool get _isBroadcast => widget.type == PatientMessageType.broadcast;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _send() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    context.read<PatientMessageCubit>().send(
      type: widget.type,
      doctorId: widget.doctorId,
      message: _messageController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientMessageCubit, PatientMessageState>(
      listener: (context, state) {
        if (state is PatientMessageSuccess) {
          Constants.showSnakToast(
            context: context,
            type: 1,
            message:
                state.response.message ??
                (_isBroadcast
                        ? 'broadcast_message_sent'
                        : 'patients_message_sent')
                    .tr,
          );
          Navigator.pop(context);
        }
        // Errors are shown inside the sheet: a SnackBar would appear on the
        // page behind it, hidden by the modal barrier.
      },
      child: Padding(
        // Keep the sheet above the keyboard.
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colors.backGround,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          child: SafeArea(
            top: false,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: colors.lightTextColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  Gaps.vGap16,
                  Text(
                    (_isBroadcast
                            ? 'broadcast_message_title'
                            : 'patients_message_title')
                        .tr,
                    style: TextStyles.semiBold18(),
                  ),
                  Gaps.vGap4,
                  Text(
                    (_isBroadcast
                            ? 'broadcast_message_desc'
                            : 'patients_message_desc')
                        .tr,
                    style: TextStyles.medium12(color: colors.lightTextColor),
                  ),
                  Gaps.vGap16,
                  MyTextFormField(
                    controller: _messageController,
                    hintText: 'patients_message_hint'.tr,
                    maxLines: 4,
                    minLines: 3,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    backgroundColor: colors.whiteColor,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'required'.tr;
                      }
                      return null;
                    },
                  ),
                  Gaps.vGap20,
                  BlocBuilder<PatientMessageCubit, PatientMessageState>(
                    builder: (context, state) {
                      if (state is PatientMessageLoading) {
                        return const LoadingView();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (state is PatientMessageError) ...[
                            _SendErrorBox(
                              message: state.message.isNotEmpty
                                  ? state.message
                                  : 'error_occurred'.tr,
                            ),
                            Gaps.vGap12,
                          ],
                          MyDefaultButton(
                            btnText: state is PatientMessageError
                                ? 'retry'
                                : 'send',
                            borderRadius: 30,
                            onPressed: _send,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Makes it clear the message was NOT sent, so the user knows to retry.
class _SendErrorBox extends StatelessWidget {
  final String message;

  const _SendErrorBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.errorColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.errorColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: colors.errorColor, size: 20.r),
          Gaps.hGap8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'message_not_sent'.tr,
                  style: TextStyles.semiBold14(color: colors.errorColor),
                ),
                Gaps.vGap4,
                Text(
                  message,
                  style: TextStyles.medium12(color: colors.textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
