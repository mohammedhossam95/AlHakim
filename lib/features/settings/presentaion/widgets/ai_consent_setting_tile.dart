import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/svg_manager.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/home/presentation/cubit/ai_consent_cubit/ai_consent_cubit.dart';
import 'package:alhakim/features/home/presentation/cubit/ai_consent_cubit/ai_consent_state.dart';
import 'package:alhakim/features/home/presentation/widgets/ai_consent_bottom_sheet.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AiConsentSettingTile extends StatelessWidget {
  const AiConsentSettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiConsentCubit, AiConsentState>(
      listenWhen: (previous, current) => current is AiConsentError,
      listener: (context, state) {
        if (state is AiConsentError) {
          Constants.showSnakToast(
            context: context,
            type: 3,
            message: state.message,
          );
        }
      },
      buildWhen: (previous, current) =>
          current is AiConsentGranted || current is AiConsentNotGranted,
      builder: (context, state) {
        final granted = state is AiConsentGranted;
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              SvgPicture.asset(
                SvgAssets.autoAwesome,
                colorFilter: ColorFilter.mode(colors.main, BlendMode.srcIn),
                width: 24.w,
                height: 24.h,
              ),
              Gaps.hGap12,
              Expanded(
                child: Text('agent_title'.tr, style: TextStyles.regular14()),
              ),
              Switch(
                value: granted,
                activeTrackColor: colors.main,
                onChanged: (value) => _onChanged(context, granted, value),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onChanged(
    BuildContext context,
    bool currentlyGranted,
    bool requested,
  ) async {
    if (requested == currentlyGranted) return;

    if (!requested) {
      final confirmed = await Constants.showConfirmDialog(
        context: context,
        title: 'agent_title'.tr,
        content: 'ai_consent_revoke_message'.tr,
      );
      if (confirmed == true && context.mounted) {
        await context.read<AiConsentCubit>().revoke();
      }
      return;
    }

    await showAiConsentBottomSheet(context: context);
  }
}
