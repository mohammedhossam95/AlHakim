// import 'dart:async';

// import 'package:alhakim/config/routes/app_routes.dart';
// import 'package:alhakim/core/utils/values/strings.dart';
// import 'package:alhakim/features/auth/presentation/widgets/auth_app_bar.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '/config/locale/app_localizations.dart';
// import '/core/utils/values/text_styles.dart';
// import '/core/widgets/gaps.dart';
// import '/core/widgets/my_default_button.dart';
// import '/core/widgets/tags_text_form_field.dart';
// import '/injection_container.dart';
// import '../../../../core/utils/validator.dart';

// class SecondStepRegisterScreen extends StatefulWidget {
//   const SecondStepRegisterScreen({super.key});

//   @override
//   State<SecondStepRegisterScreen> createState() =>
//       _SecondStepRegisterScreenState();
// }

// class _SecondStepRegisterScreenState extends State<SecondStepRegisterScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey();
//   final TextEditingController addressController = TextEditingController();
//   final FocusNode addressFocus = FocusNode();

//   final TextEditingController governorateController = TextEditingController();
//   final FocusNode governorateFocus = FocusNode();

//   final List<String> governoratesList = ['Cairo', 'DC'];

//   final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
//   int _markerIdCounter = 0;
//   final Completer<GoogleMapController> _mapController = Completer();
//   LatLng position = const LatLng(30.044398, 31.235715);
//   final ScrollController scrollController = ScrollController();

//   void _onMapCreated(GoogleMapController controller) async {
//     _mapController.complete(controller);

//     MarkerId markerId = MarkerId(_markerIdVal());

//     Marker marker = Marker(
//       markerId: markerId,
//       position: position,
//       draggable: false,
//     );
//     setState(() {
//       _markers[markerId] = marker;
//     });

//     Future.delayed(const Duration(seconds: 1), () async {
//       GoogleMapController controller = await _mapController.future;
//       controller.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: position, zoom: 15.0),
//         ),
//       );
//     });
//   }

//   Future<void> _requestPermissionAndGetLocation() async {
//     PermissionStatus permission = await Permission.locationWhenInUse.request();

//     if (permission == PermissionStatus.granted) {
//       Position position = await Geolocator.getCurrentPosition(
//         // ignore: deprecated_member_use
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       setState(() {
//         this.position = LatLng(position.latitude, position.longitude);
//         //_addMarker(this.position);
//       });

//       GoogleMapController controller = await _mapController.future;
//       controller.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: this.position, zoom: 15.0),
//         ),
//       );
//     } else if (permission == PermissionStatus.denied) {
//       _showPermissionDeniedDialog();
//     } else if (permission == PermissionStatus.permanentlyDenied) {
//       _showPermissionDeniedPermanentlyDialog();
//     }
//   }

//   void _showPermissionDeniedDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Location Permission Denied'),
//           content: const Text(
//             'Location permission is required to pick the current location. Please allow location access.',
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 context.pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showPermissionDeniedPermanentlyDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Location Permission Permanently Denied'),
//           content: const Text(
//             'Location permission has been permanently denied. Please go to settings to enable it.',
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Open Settings'),
//               onPressed: () {
//                 openAppSettings();
//                 context.pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 context.pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String _markerIdVal({bool increment = false}) {
//     String val = 'marker_id_$_markerIdCounter';
//     if (increment) _markerIdCounter++;
//     return val;
//   }

//   @override
//   initState() {
//     super.initState();
//     _requestPermissionAndGetLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => unFocus(),
//       child: Scaffold(
//         body: Form(
//           key: _formKey,
//           child: SafeArea(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Gaps.vGap10,
//                     AuthAppBar(showBackButton: true),
//                     Gaps.vGap30,
//                     Text('create_account'.tr, style: TextStyles.semiBold24()),
//                     Text(
//                       'enter_data_to_register'.tr,
//                       style: TextStyles.semiBold14(
//                         color: colors.lightTextColor,
//                       ),
//                     ),
//                     Gaps.vGap20,
//                     DropdownButtonFormField(
//                       focusNode: governorateFocus,
//                       hint: Text(
//                         'governorate'.tr,
//                         style: TextStyles.medium12(
//                           color: colors.lightTextColor,
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null) {
//                           return Strings.errorFieldRequired;
//                         }
//                         return null;
//                       },
//                       decoration: InputDecoration(
//                         filled: true,
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                           borderSide: BorderSide(
//                             color: colors.textColor.withValues(alpha: .2),
//                             width: 1.0,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                           borderSide: BorderSide(
//                             color: colors.main,
//                             width: 1.0,
//                           ),
//                         ),
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                           borderSide: BorderSide(
//                             color: colors.errorColor,
//                             width: 1.0,
//                           ),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(12.r)),
//                           borderSide: BorderSide(
//                             color: colors.errorColor,
//                             width: 1.0,
//                           ),
//                         ),

//                         errorMaxLines: 2,
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 16.w,
//                           vertical: 18.h,
//                         ),
//                         labelStyle: TextStyles.medium14(
//                           color: colors.textColor,
//                         ),
//                         errorStyle: TextStyles.regular12(color: Colors.red),
//                         hintStyle: TextStyles.medium14(color: Colors.grey),
//                       ),
//                       isExpanded: true,
//                       items: governoratesList
//                           .map(
//                             (category) => DropdownMenuItem(
//                               value: category,
//                               child: Padding(
//                                 padding: EdgeInsets.only(right: 12.r),
//                                 child: Text(
//                                   category,
//                                   style: TextStyles.medium14(),
//                                 ),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (d) {},
//                     ),
//                     Gaps.vGap10,
//                     AppTextFormField(
//                       borderColor: colors.textColor.withValues(alpha: .2),
//                       backgroundColor: Color(0xffd0d0d0).withValues(alpha: .2),
//                       controller: addressController,
//                       focusNode: addressFocus,
//                       keyboardType: TextInputType.text,
//                       textInputAction: TextInputAction.done,
//                       isPhone: false,
//                       validatorType: ValidatorType.standard,
//                       hintText: 'detailed_address'.tr,
//                     ),
//                     Gaps.vGap20,
//                     SizedBox(
//                       height: 300,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(14.r),
//                         child: GoogleMap(
//                           gestureRecognizers:
//                               <Factory<OneSequenceGestureRecognizer>>{
//                                 Factory<OneSequenceGestureRecognizer>(
//                                   () => EagerGestureRecognizer(),
//                                 ),
//                               },
//                           markers: Set<Marker>.of(_markers.values),
//                           onMapCreated: _onMapCreated,
//                           initialCameraPosition: CameraPosition(
//                             target: position,
//                             zoom: 15.0,
//                           ),
//                           myLocationEnabled: true,
//                           onCameraIdle: () {},
//                           onCameraMove: (CameraPosition position) {
//                             if (_markers.isNotEmpty) {
//                               MarkerId markerId = MarkerId(_markerIdVal());
//                               Marker? marker = _markers[markerId];
//                               Marker? updatedMarker = marker?.copyWith(
//                                 positionParam: position.target,
//                               );

//                               setState(() {
//                                 _markers[markerId] = updatedMarker!;
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                     ),
//                     Gaps.vGap20,
//                     MyDefaultButton(
//                       color: colors.main,
//                       borderColor: colors.main,
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           _formKey.currentState!.save();
//                           context.go(Routes.mainPageRoute);
//                         }
//                       },
//                       btnText: 'next',
//                     ),
//                     Gaps.vGap20,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void unFocus() {
//     governorateFocus.unfocus();
//     addressFocus.unfocus();
//   }
// }
