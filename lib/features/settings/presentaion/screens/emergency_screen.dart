import 'dart:async';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/shimmer/hospital_emergency_shimmer.dart';
import 'package:alhakim/features/settings/domain/entity/hospital_emergency_entity.dart';
import 'package:alhakim/features/settings/presentaion/cubit/get_hospital_emergency_cubit/get_hospital_emergency_cubit.dart';
import 'package:alhakim/features/settings/presentaion/widgets/custom_app_bar.dart';
import 'package:alhakim/features/settings/presentaion/widgets/hospital_emergency_card.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmergencyScreen extends StatefulWidget {
  final bool isInTabBar;
  final int? categoryId;
  final String? categoryName;

  const EmergencyScreen({
    super.key,
    this.isInTabBar = false,
    this.categoryId,
    this.categoryName,
  });

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  Completer<void>? _refreshCompleter;
  StreamSubscription<GetHospitalEmergencyState>? _refreshSubscription;

  @override
  void initState() {
    super.initState();
    _fetchHospitals();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _refreshSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  String? _normalizedHospitalName([String? value]) {
    final q = (value ?? _searchController.text).trim();
    return q.isEmpty ? null : q;
  }

  bool get _hasActiveSearch => _normalizedHospitalName() != null;

  void _fetchHospitals({String? hospitalName}) {
    context.read<GetHospitalEmergencyCubit>().getHospitalEmergencyNumbers(
      categoryId: widget.categoryId,
      hospitalName: _normalizedHospitalName(hospitalName),
    );
  }

  void _onSearchChanged(String? value) {
    setState(() {});
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _fetchHospitals(hospitalName: value);
    });
  }

  void _onSearchSubmitted(String value) {
    _debounce?.cancel();
    _fetchHospitals(hospitalName: value);
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() {});
    _fetchHospitals();
  }

  Future<void> _onRefresh() {
    _refreshSubscription?.cancel();
    _refreshCompleter = Completer<void>();

    _refreshSubscription = context
        .read<GetHospitalEmergencyCubit>()
        .stream
        .listen((state) {
          if (state is GetHospitalEmergencySuccess ||
              state is GetHospitalEmergencyError) {
            if (!(_refreshCompleter?.isCompleted ?? true)) {
              _refreshCompleter?.complete();
            }
            _refreshSubscription?.cancel();
            _refreshSubscription = null;
          }
        });

    _fetchHospitals();
    return _refreshCompleter!.future;
  }

  Widget _buildRefreshableMessage({required Widget child}) {
    return RefreshIndicator(
      color: colors.main,
      onRefresh: _onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: constraints.maxHeight,
              child: Center(child: child),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: CustomAppBar(
                title: widget.categoryName ?? 'emergency'.tr,
                isInTabBar: widget.isInTabBar,
              ),
            ),
            Gaps.vGap8,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: colors.main.withValues(alpha: .1),
                      blurRadius: 10.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: MyTextFormField(
                  controller: _searchController,
                  backgroundColor: colors.whiteColor,
                  hintText: 'searchForPlace'.tr,
                  prefixIcon: Icon(Icons.search, color: colors.main),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: _clearSearch,
                          icon: Icon(
                            Icons.close_rounded,
                            color: colors.lightTextColor,
                          ),
                        )
                      : null,
                  textInputAction: TextInputAction.search,
                  onChanged: _onSearchChanged,
                  onSubmit: _onSearchSubmitted,
                ),
              ),
            ),
            Gaps.vGap20,
            Expanded(
              child:
                  BlocBuilder<
                    GetHospitalEmergencyCubit,
                    GetHospitalEmergencyState
                  >(
                    builder: (context, state) {
                      if (state is GetHospitalEmergencyLoading ||
                          state is GetHospitalEmergencyInitial) {
                        return const HospitalEmergencyShimmer();
                      }

                      if (state is GetHospitalEmergencyError) {
                        return _buildRefreshableMessage(
                          child: ErrorText(
                            width: 300.w,
                            text: state.message,
                            onRetry: () => _fetchHospitals(),
                          ),
                        );
                      }

                      final items = state is GetHospitalEmergencySuccess
                          ? (state.response.data ?? [])
                                .whereType<HospitalEmergencyEntity>()
                                .toList()
                          : <HospitalEmergencyEntity>[];

                      if (items.isEmpty) {
                        return _buildRefreshableMessage(
                          child: Text(
                            (_hasActiveSearch
                                    ? 'no_search_results'
                                    : 'no_hospitals_found')
                                .tr,
                            style: TextStyles.medium16(
                              color: colors.lightTextColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: colors.main,
                        onRefresh: _onRefresh,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                          itemCount: items.length,
                          separatorBuilder: (_, _) => Gaps.vGap16,
                          itemBuilder: (context, index) {
                            return HospitalEmergencyCard(item: items[index]);
                          },
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
