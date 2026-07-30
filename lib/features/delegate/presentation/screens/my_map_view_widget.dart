// ignore_for_file: use_super_parameters

import 'dart:async';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef LocationCallback = void Function(LatLng position);

class MyMapView extends StatefulWidget {
  final LatLng location;
  final LocationCallback onLocationChanged;

  const MyMapView({
    Key? key,
    required this.location,
    required this.onLocationChanged,
  }) : super(key: key);

  @override
  State<MyMapView> createState() => _MyMapViewState();
}

class _MyMapViewState extends State<MyMapView> {
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  final Completer<GoogleMapController> _mapController = Completer();
  final int _markerIdCounter = 0;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _addMarker(widget.location);
  }

  void _addMarker(LatLng pos) {
    final markerId = MarkerId('marker_$_markerIdCounter');
    final marker = Marker(markerId: markerId, position: pos, draggable: false);
    setState(() {
      _markers.clear(); // Only one marker
      _markers[markerId] = marker;
      _selectedLocation = pos;
    });

    widget.onLocationChanged(pos);
  }

  Future<void> _moveCamera(LatLng pos) async {
    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(pos, 20.0));
  }

  void _onMapTapped(LatLng pos) {
    _addMarker(pos);
    _moveCamera(pos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('select_location'.tr)),
      body: Container(
        height: double.infinity,
        color: colors.backGround,
        child: Column(
          children: [
            Expanded(
              child: Container(
                //margin: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: colors.main),
                ),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.location,
                    zoom: 15,
                  ),
                  markers: Set<Marker>.of(_markers.values),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                  onTap: _onMapTapped,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ),
            Gaps.vGap30,
            MyDefaultButton(
              height: 50.h,
              borderRadius: 12.r,
              btnText: 'save',
              onPressed: () {
                if (_selectedLocation != null) {
                  Navigator.pop(
                    context,
                    _selectedLocation,
                  ); // <-- return the selected location
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a location')),
                  );
                }
              },
            ),
            Gaps.vGap30,
          ],
        ),
      ),
    );
  }
}
