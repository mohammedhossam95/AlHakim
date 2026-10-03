import 'dart:developer';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/params/rate_appointment_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/appointments/domain/entities/appointment_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RateAppointmentScreen extends StatefulWidget {
  final AppointmentEntity appointment;

  const RateAppointmentScreen({super.key, required this.appointment});

  @override
  State<RateAppointmentScreen> createState() => _RateAppointmentScreenState();
}

enum _RatingCategory { doctor, secretary, clinic, app }

class _RateAppointmentScreenState extends State<RateAppointmentScreen> {
  final _notesController = TextEditingController();

  /// 0 means not rated yet.
  final Map<_RatingCategory, int> _ratings = {
    for (final category in _RatingCategory.values) category: 0,
  };

  bool get _allRated => _ratings.values.every((rating) => rating > 0);

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _categoryTitle(_RatingCategory category) => switch (category) {
    _RatingCategory.doctor => 'rating_doctor'.tr,
    _RatingCategory.secretary => 'rating_secretary'.tr,
    _RatingCategory.clinic => 'rating_clinic'.tr,
    _RatingCategory.app => 'rating_app'.tr,
  };

  String _categorySubtitle(_RatingCategory category) => switch (category) {
    _RatingCategory.doctor => 'rating_doctor_desc'.tr,
    _RatingCategory.secretary => 'rating_secretary_desc'.tr,
    _RatingCategory.clinic => 'rating_clinic_desc'.tr,
    _RatingCategory.app => 'rating_app_desc'.tr,
  };

  void _submit() {
    final appointmentId = widget.appointment.id;
    if (appointmentId == null) return;

    if (!_allRated) {
      Constants.showSnakToast(
        context: context,
        type: 2,
        message: 'rate_all_categories'.tr,
      );
      return;
    }

    final params = RateAppointmentParams(
      appointmentId: appointmentId,
      doctorRating: _ratings[_RatingCategory.doctor]!,
      secretaryRating: _ratings[_RatingCategory.secretary]!,
      clinicRating: _ratings[_RatingCategory.clinic]!,
      appRating: _ratings[_RatingCategory.app]!,
      notes: _notesController.text,
    );

    // TODO: send `params` to the rating endpoint once the backend is ready
    // (cubit -> usecase -> repository -> datasource, like the other
    // appointment requests), then show success and pop.
    log('RateAppointmentParams: ${params.toJson()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(title: Text('rate_appointment'.tr)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DoctorSummaryCard(appointment: widget.appointment),
            Gaps.vGap24,
            Text('rate_your_experience'.tr, style: TextStyles.semiBold18()),
            Gaps.vGap12,
            for (final category in _RatingCategory.values) ...[
              _RatingCard(
                title: _categoryTitle(category),
                subtitle: _categorySubtitle(category),
                rating: _ratings[category]!,
                onChanged: (value) {
                  setState(() => _ratings[category] = value);
                },
              ),
              Gaps.vGap12,
            ],
            Gaps.vGap12,
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'your_notes'.tr,
                    style: TextStyles.semiBold16(),
                  ),
                  TextSpan(
                    text: ' (${'optional'.tr})',
                    style: TextStyles.medium12(color: colors.lightTextColor),
                  ),
                ],
              ),
            ),
            Gaps.vGap10,
            MyTextFormField(
              controller: _notesController,
              hintText: 'rating_notes_hint'.tr,
              maxLines: 4,
              minLines: 4,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              backgroundColor: colors.whiteColor,
            ),
            Gaps.vGap24,
            MyDefaultButton(
              btnText: 'submit_rating',
              borderRadius: 30,
              onPressed: _submit,
            ),
            Gaps.vGap20,
          ],
        ),
      ),
    );
  }
}

class _DoctorSummaryCard extends StatelessWidget {
  final AppointmentEntity appointment;

  const _DoctorSummaryCard({required this.appointment});

  String get _doctorName {
    final name = appointment.doctor?.name;
    final ar = name?.ar?.trim() ?? '';
    final en = name?.en?.trim() ?? '';
    if (appLocalizations.isArLocale) return ar.isNotEmpty ? ar : en;
    return en.isNotEmpty ? en : ar;
  }

  String get _subtitle {
    final specialty = appointment.doctor?.specialty?.name?.trim() ?? '';
    final date = DateTime.tryParse(appointment.appointmentDate ?? '');
    final formattedDate = date == null
        ? ''
        : DateFormat(
            'EEEE d MMMM yyyy',
            appLocalizations.locale?.languageCode,
          ).format(date);
    return [specialty, formattedDate].where((e) => e.isNotEmpty).join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          DiffImage(
            image: appointment.doctor?.profileImage ?? '',
            userName: _doctorName,
            width: 56.r,
            height: 56.r,
            isCircle: true,
          ),
          Gaps.hGap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_doctorName, style: TextStyles.semiBold16()),
                Gaps.vGap8,
                Text(
                  _subtitle,
                  style: TextStyles.medium12(color: colors.lightTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int rating;
  final ValueChanged<int> onChanged;

  const _RatingCard({
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.semiBold16()),
                Gaps.vGap4,
                Text(
                  subtitle,
                  style: TextStyles.medium12(color: colors.lightTextColor),
                ),
              ],
            ),
          ),
          Gaps.hGap8,
          _StarRating(rating: rating, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// Five tappable stars; in RTL the first star is on the right.
class _StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;

  const _StarRating({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final value = index + 1;
        final filled = value <= rating;
        return InkResponse(
          onTap: () => onChanged(value),
          radius: 20.r,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Icon(
              Icons.star_rounded,
              size: 28.r,
              color: filled
                  ? colors.review
                  : colors.lightTextColor.withValues(alpha: 0.3),
            ),
          ),
        );
      }),
    );
  }
}
