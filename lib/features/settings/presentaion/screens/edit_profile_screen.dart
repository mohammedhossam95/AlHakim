import 'dart:io';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/validator.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/app_snack_bar.dart';
import 'package:alhakim/core/widgets/back_button.dart';
import 'package:alhakim/core/widgets/country_code_widget.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/error_view_widget.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:alhakim/features/auth/presentation/cubit/delete_user_account/delete_user_account_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/settings/presentaion/cubit/get_user_profile_cubit/get_user_profile_cubit.dart';
import 'package:alhakim/features/settings/presentaion/cubit/update_user_profile_cubit/update_user_profile_cubit.dart';
import 'package:alhakim/features/settings/presentaion/cubit/user_cached_cubit/user_cubit.dart';
import 'package:alhakim/features/settings/presentaion/widgets/edit_profile_shimer.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController,
      _whatsappController,
      _emailController,
      _bioController;

  late final FocusNode _nameFocus, _whatsappFocus, _emailFocus, _bioFocus;

  late Country _selectedWhatsappCountry;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _avatarUrl;
  late UserEntity userEntity;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with empty strings
    _nameController = TextEditingController(text: '');

    _whatsappController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _bioController = TextEditingController(text: '');

    _nameFocus = FocusNode();

    _whatsappFocus = FocusNode();
    _emailFocus = FocusNode();
    _bioFocus = FocusNode();

    _selectedWhatsappCountry = CountryParser.parsePhoneCode('966');

    // Trigger profile fetch after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GetUserProfileCubit>().getUserProfile(
          AuthParams(isMyProfile: true),
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();

    _whatsappController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _nameFocus.dispose();

    _whatsappFocus.dispose();
    _emailFocus.dispose();
    _bioFocus.dispose();
    super.dispose();
  }

  void _updateControllers(UserEntity user) {
    userEntity = user;
    _nameController.text = user.name ?? '';
    _emailController.text = user.email ?? '';
    _whatsappController.text = user.whatsapp ?? '';
    _bioController.text = user.bio ?? '';
    String countryCode = Constants().getCountryCode(user.whatsapp ?? '');
    _selectedWhatsappCountry =
        CountryParser.tryParsePhoneCode(countryCode) ??
        Constants.saudiCountryPicker;
    _avatarUrl = user.photo ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<SessionCubit>().state.status;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<GetUserProfileCubit, GetUserProfileState>(
          listener: (context, state) {
            if (state is GetUserProfileLoaded) {
              final user = state.response.data as UserEntity?;
              if (user != null) {
                if (mounted) {
                  setState(() {
                    _updateControllers(user);
                  });
                }
              }
            }
          },
          builder: (context, state) {
            if (state is GetUserProfileIsLoading) {
              return const EditProfileShimmer();
            }

            if (state is GetUserProfileError) {
              return ErrorView(
                message: state.message.toString(),
                onRetry: () => context
                    .read<GetUserProfileCubit>()
                    .getUserProfile(AuthParams(isMyProfile: true)),
              );
            }

            // final user = state is GetUserProfileLoaded
            //     ? state.response.data as UserEntity?
            //     : null;

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(child: _buildHeader()),
                    Gaps.vGap30,
                    Center(child: FadeInUp(child: _buildAvatar(_avatarUrl))),
                    Gaps.vGap30,
                    _buildFieldLabel('full_name'.tr),
                    MyTextFormField(
                      backgroundColor: colors.main.withValues(alpha: 0.1),
                      controller: _nameController,
                      focusNode: _nameFocus,
                      hintText: 'name'.tr,
                      validatorType: ValidatorType.standard,
                    ),
                    Gaps.vGap16,
                    _buildFieldLabel('whatsapp'.tr),

                    ElasticInLeft(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CountryCodeWidget(
                            country: _selectedWhatsappCountry,
                            updateValue: (country) {
                              setState(() {
                                _selectedWhatsappCountry = country;
                              });
                            },
                          ),
                          Gaps.hGap8,
                          // جزء حقل إدخال الرقم
                          Expanded(
                            flex: 5,
                            child: MyTextFormField(
                              backgroundColor: colors.main.withValues(
                                alpha: 0.1,
                              ),
                              controller: _whatsappController,
                              focusNode: _whatsappFocus,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              validatorType: ValidatorType.phone,
                              hintText: 'enter_phone'.tr,
                              labelText: 'enter_phone'.tr,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.vGap16,
                    _buildFieldLabel('email'.tr),
                    MyTextFormField(
                      backgroundColor: colors.main.withValues(alpha: 0.1),
                      controller: _emailController,
                      focusNode: _emailFocus,
                      hintText: 'email'.tr,
                      validatorType: ValidatorType.email,
                    ),
                    Gaps.vGap16,
                    _buildFieldLabel('bio'.tr),
                    MyTextFormField(
                      backgroundColor: colors.main.withValues(alpha: 0.1),
                      controller: _bioController,
                      focusNode: _bioFocus,
                      hintText: 'bio'.tr,
                      maxLines: 3,
                    ),
                    Gaps.vGap30,
                    FadeInUp(child: _buildSaveButton()),
                    Gaps.vGap20,
                    _buildDeleteAccountButton(status),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(label, style: TextStyles.bold14(color: colors.textColor)),
  );

  Widget _buildAvatar(String? avatarImage) {
    return Stack(
      children: [
        _imageFile != null
            ? SizedBox(
                height: 100.h,
                width: 100.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: Image.file(
                    _imageFile!,
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : DiffImage(
                image: avatarImage,
                userName: avatarImage,
                height: 100.h,
                width: 100.w,
                radius: 50.r,
                padding: EdgeInsets.all(4.r),
                hasBorder: true,
                isCircle: true,
              ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () async {
              final XFile? pickedFile = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedFile != null && mounted) {
                setState(() => _imageFile = File(pickedFile.path));
              }
            },
            child: CircleAvatar(
              radius: 15.r,
              backgroundColor: colors.main,
              child: Icon(Icons.camera_alt, size: 16.r, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() => Row(
    children: [
      const CustomBackButton(),
      Gaps.hGap12,
      Text('editMyProfile'.tr, style: TextStyles.bold15()),
    ],
  );

  Widget _buildSaveButton() =>
      BlocConsumer<UpdateUserProfileCubit, UpdateUserProfileState>(
        listener: (context, state) {
          if (state is UpdateUserProfileLoaded) {
            showAppSnackBar(
              context: context,
              message: state.response.message ?? '',
              type: ToastType.success,
            );
            context.read<UserCubit>().updateUser(state.response.data);
            Navigator.pop(context);
          }
          if (state is UpdateUserProfileError) {
            showAppSnackBar(
              context: context,
              message: state.message,
              type: ToastType.success,
            );
          }
        },
        builder: (context, state) => state is UpdateUserProfileIsLoading
            ? const LoadingView()
            : MyDefaultButton(
                btnText: 'update',
                onPressed: _handleUpdateProfile,
              ),
      );

  Widget _buildDeleteAccountButton(SessionStatus status) {
    if (status != SessionStatus.authenticated) return const SizedBox.shrink();
    return BlocConsumer<DeleteUserAccountCubit, DeleteUserAccountState>(
      listener: (context, state) {
        if (state is DeleteUserAccountLoaded ||
            state is DeleteUserAccountError) {
          Constants.showSnakToast(
            context: context,
            message: state is DeleteUserAccountLoaded
                ? state.response.message.toString()
                : (state as DeleteUserAccountError).message,
            type: state is DeleteUserAccountLoaded ? 1 : 3,
          );
          if (state is DeleteUserAccountLoaded) {
            context.go(Routes.loginScreenRoute);
          }
        }
      },
      builder: (context, state) => state is DeleteUserAccountLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: InkWell(
                  onTap: () => Constants.showDeleteAccountDialog(
                    context,
                    onOkPressed: () {
                      Navigator.pop(context);
                      context
                          .read<DeleteUserAccountCubit>()
                          .deleteUserAccount();
                    },
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 40.0.h),
                    child: Text(
                      'delete_account'.tr,
                      style: TextStyles.bold14(color: colors.errorColor),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void _handleUpdateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? whatsappNum = await Constants.phoneParsing(
          phone: _whatsappController.text,
          countryCode: _selectedWhatsappCountry.countryCode,
          withCode: true,
        );
        if (!mounted) return;
        if (whatsappNum == null) {
          Constants.showSnakToast(
            context: context,
            message: 'invalidPhoneText'.tr,
            type: ToastType.error,
          );
          return;
        }
        BlocProvider.of<UpdateUserProfileCubit>(context).updateUserProfile(
          AuthParams(
            name: _nameController.text,
            email: _emailController.text,
            bio: _bioController.text,
            phone: userEntity.phone,
            countryCode: userEntity.countryCode,
            whatsapp: whatsappNum,
            imageUrl: _imageFile?.path,
          ),
        );
      } catch (e) {
        Constants.showSnakToast(
          context: context,
          message: e.toString(),
          type: ToastType.error,
        );
      }
    }
  }
}
