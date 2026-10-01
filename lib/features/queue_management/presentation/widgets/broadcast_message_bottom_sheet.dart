import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/broadcast_message_cubit/broadcast_message_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Lets the doctor or secretary send a message to the patients following
/// this doctor's queue (delays, the doctor running late, etc.).
class BroadcastMessageBottomSheet extends StatefulWidget {
  final String doctorId;

  const BroadcastMessageBottomSheet({super.key, required this.doctorId});

  static Future<void> show(BuildContext context, {required String doctorId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => ServiceLocator.instance<BroadcastMessageCubit>(),
        child: BroadcastMessageBottomSheet(doctorId: doctorId),
      ),
    );
  }

  @override
  State<BroadcastMessageBottomSheet> createState() =>
      _BroadcastMessageBottomSheetState();
}

class _BroadcastMessageBottomSheetState
    extends State<BroadcastMessageBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _send() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    context.read<BroadcastMessageCubit>().broadcastMessage(
      doctorId: widget.doctorId,
      message: _messageController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BroadcastMessageCubit, BroadcastMessageState>(
      listener: (context, state) {
        if (state is BroadcastMessageSuccess) {
          Constants.showSnakToast(
            context: context,
            type: 1,
            message: state.response.message ?? 'patients_message_sent'.tr,
          );
          Navigator.pop(context);
        } else if (state is BroadcastMessageError) {
          Constants.showSnakToast(
            context: context,
            type: 3,
            message: state.message,
          );
        }
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
                    'patients_message_title'.tr,
                    style: TextStyles.semiBold18(),
                  ),
                  Gaps.vGap4,
                  Text(
                    'patients_message_desc'.tr,
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
                  BlocBuilder<BroadcastMessageCubit, BroadcastMessageState>(
                    builder: (context, state) {
                      return state is BroadcastMessageLoading
                          ? const LoadingView()
                          : MyDefaultButton(
                              btnText: 'send',
                              borderRadius: 30,
                              onPressed: _send,
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
