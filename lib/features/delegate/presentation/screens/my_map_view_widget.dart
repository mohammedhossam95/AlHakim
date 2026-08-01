// ignore_for_file: use_super_parameters, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const String _placesApiKey = 'AIzaSyCrPBIVbCvB3xIUG3SFNu9PGCpwV5cOdc8';

class _PlacePrediction {
  final String description;
  final String placeId;
  final String mainText;
  final String secondaryText;

  _PlacePrediction({
    required this.description,
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });
}

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
  String _selectedAddress = '';

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<_PlacePrediction> _suggestions = [];
  Timer? _debounce;
  bool _isSearching = false;
  bool _isResolvingTap = false;
  String? _searchErrorMessage;

  // Tracks whether the suggestions/status panel should be visible at
  // all. This is what actually controls the container underneath the
  // search field — separate from just "is there text in the field" —
  // so we can hide it deterministically after picking a suggestion,
  // clearing the field, or tapping the map.
  bool _showSuggestionsPanel = false;

  @override
  void initState() {
    super.initState();
    _addMarker(widget.location, updateAddress: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------
  // Reverse geocoding: coordinates -> human readable address
  // ---------------------------------------------------------------------
  Future<String> _getAddressFromLatLng(LatLng coords) async {
    if (_placesApiKey.isEmpty) return 'Selected Location';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${coords.latitude},${coords.longitude}&key=$_placesApiKey&language=ar';
    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return data['results'][0]['formatted_address'];
      } else {
        log(
          'Geocoding API error: ${data['status']} - ${data['error_message'] ?? ''}',
        );
      }
    } catch (e) {
      log('Geocoding error: $e');
    }
    return 'Selected Location';
  }

  // ---------------------------------------------------------------------
  // Places Autocomplete search
  // ---------------------------------------------------------------------
  void _onSearchChanged(String input) {
    _debounce?.cancel();
    if (input.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
        _searchErrorMessage = null;
        _showSuggestionsPanel = false;
      });
      return;
    }
    setState(() {
      _isSearching = true;
      _showSuggestionsPanel = true;
    });
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _getSuggestions(input);
    });
  }

  Future<void> _getSuggestions(String input) async {
    if (input.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
        _showSuggestionsPanel = false;
      });
      return;
    }

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&key=$_placesApiKey&components=country:eg&language=ar';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final predictions = data['predictions'] as List;
        setState(() {
          _suggestions = predictions.map((p) {
            final structured = p['structured_formatting'];
            return _PlacePrediction(
              description: p['description'] as String,
              placeId: p['place_id'] as String,
              mainText: structured != null
                  ? (structured['main_text'] as String? ??
                        p['description'] as String)
                  : p['description'] as String,
              secondaryText: structured != null
                  ? (structured['secondary_text'] as String? ?? '')
                  : '',
            );
          }).toList();
          _searchErrorMessage = null;
          _showSuggestionsPanel = true;
        });
      } else if (data['status'] == 'ZERO_RESULTS') {
        setState(() {
          _suggestions = [];
          _searchErrorMessage = null;
          _showSuggestionsPanel = true; // show the "no results" state
        });
      } else {
        // This is very likely why "search isn't working": the request
        // came back with an error status (e.g. REQUEST_DENIED because
        // the key lacks Places API access or has bad restrictions,
        // INVALID_REQUEST, OVER_QUERY_LIMIT, ...). We now surface it
        // instead of silently doing nothing.
        log(
          'Places Autocomplete error: ${data['status']} - ${data['error_message'] ?? ''}',
        );
        setState(() {
          _suggestions = [];
          _searchErrorMessage = _friendlyErrorFor(data['status'] as String?);
          _showSuggestionsPanel = true;
        });
      }
    } catch (e) {
      log('Autocomplete request failed: $e');
      setState(() {
        _suggestions = [];
        _searchErrorMessage = 'noInternetConnection'.tr;
        _showSuggestionsPanel = true;
      });
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  String _friendlyErrorFor(String? status) {
    switch (status) {
      case 'REQUEST_DENIED':
        return 'searchUnavailable'.tr;
      case 'OVER_QUERY_LIMIT':
        return 'searchQuotaExceeded'.tr;
      default:
        return 'searchFailed'.tr;
    }
  }

  Future<void> _selectPlace(_PlacePrediction prediction) async {
    setState(() {
      // Fill the field with the FULL selected description, not
      // whatever partial text the user had typed.
      _searchController.text = prediction.description;
      _suggestions = [];
      _isSearching = true;
      // Hide the suggestions/status container immediately on pick.
      _showSuggestionsPanel = false;
    });
    _searchFocusNode.unfocus();

    final detailUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=${prediction.placeId}&key=$_placesApiKey&language=ar';

    try {
      final response = await http.get(Uri.parse(detailUrl));
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final lat = data['result']['geometry']['location']['lat'];
        final lng = data['result']['geometry']['location']['lng'];
        final pos = LatLng(lat, lng);
        _addMarker(
          pos,
          address: prediction.description,
          fromSearchSelection: true,
        );
        _moveCamera(pos);
      } else {
        log(
          'Place details error: ${data['status']} - ${data['error_message'] ?? ''}',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_friendlyErrorFor(data['status'] as String?)),
            ),
          );
        }
      }
    } catch (e) {
      log('Place details request failed: $e');
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  // ---------------------------------------------------------------------
  // Marker / camera helpers
  // ---------------------------------------------------------------------

  Future<void> _addMarker(
    LatLng pos, {
    String? address,
    bool updateAddress = false,
    bool fromSearchSelection = false,
  }) async {
    final markerId = MarkerId('marker_$_markerIdCounter');
    final marker = Marker(markerId: markerId, position: pos, draggable: false);

    setState(() {
      _markers.clear(); // Only one marker
      _markers[markerId] = marker;
      _selectedLocation = pos;
    });

    if (address != null) {
      setState(() {
        _selectedAddress = address;
        // Search field is only ever auto-filled when the address came
        // from picking a search suggestion — never from a map tap or
        // the initial location.
        if (fromSearchSelection) {
          _searchController.text = address;
        }
      });
    } else if (updateAddress) {
      final resolved = await _getAddressFromLatLng(pos);
      if (!mounted) return;
      setState(() {
        _selectedAddress = resolved;
      });
    }

    widget.onLocationChanged(pos);
  }

  Future<void> _moveCamera(LatLng pos) async {
    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(pos, 20.0));
  }

  void _onMapTapped(LatLng pos) async {
    setState(() {
      _suggestions = [];
      _isResolvingTap = true;
      _showSuggestionsPanel = false; // hide panel when interacting with map
    });
    final address = await _getAddressFromLatLng(pos);
    if (!mounted) return;
    _addMarker(pos, address: address);
    _moveCamera(pos);
    setState(() => _isResolvingTap = false);
  }

  // ---------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(
        title: Text(
          'select_location'.tr,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colors.backGround,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
                  child: _buildSearchField(),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildMap(),
                  ),
                ),
                _buildSelectedAddressBar(),
                Gaps.vGap12,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: MyDefaultButton(
                    height: 52.h,
                    borderRadius: 14.r,
                    btnText: 'save',
                    onPressed: () {
                      if (_selectedLocation != null) {
                        Navigator.pop(context, {
                          'location': _selectedLocation,
                          'address': _selectedAddress,
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content: Text(
                              'selectPosition'.tr,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Gaps.vGap20,
              ],
            ),
            // Suggestions dropdown floats above the map instead of
            // pushing layout around. Controlled purely by
            // _showSuggestionsPanel so it never lingers after a pick,
            // a clear, or a map tap.
            if (_showSuggestionsPanel)
              Positioned(
                top: 62.h,
                left: 16.w,
                right: 16.w,
                child: _buildSuggestionsPanel(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Material(
      elevation: 3,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(16.r),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: TextStyle(fontSize: 15.sp),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'searchForPlace'.tr,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15.sp),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colors.main,
            size: 24.sp,
          ),
          suffixIcon: _isSearching
              ? Padding(
                  padding: EdgeInsets.all(14.r),
                  child: SizedBox(
                    width: 18.w,
                    height: 18.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.main,
                    ),
                  ),
                )
              : (_searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.grey.shade500,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _suggestions = [];
                            _searchErrorMessage = null;
                            _showSuggestionsPanel = false;
                          });
                        },
                      )
                    : null),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: colors.main.withValues(alpha: .7),
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        onChanged: (val) {
          setState(() {}); // refresh suffix icon state
          _onSearchChanged(val);
        },
      ),
    );
  }

  Widget _buildSuggestionsPanel() {
    return Material(
      elevation: 6,
      shadowColor: Colors.black38,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        constraints: BoxConstraints(maxHeight: 280.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: _searchErrorMessage != null
            ? _buildInfoRow(
                icon: Icons.error_outline_rounded,
                iconColor: Colors.redAccent,
                text: _searchErrorMessage!,
              )
            : (_suggestions.isEmpty
                  ? _buildInfoRow(
                      icon: Icons.location_off_outlined,
                      iconColor: Colors.grey,
                      text: 'noResultsFound'.tr,
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        indent: 56.w,
                        color: Colors.grey.shade200,
                      ),
                      itemBuilder: (context, index) {
                        final s = _suggestions[index];
                        return InkWell(
                          onTap: () => _selectPlace(s),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: colors.main.withValues(alpha: 0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    color: colors.main,
                                    size: 18.sp,
                                  ),
                                ),
                                Gaps.hGap12,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s.mainText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      if (s.secondaryText.isNotEmpty) ...[
                                        SizedBox(height: 2.h),
                                        Text(
                                          s.secondaryText,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20.sp),
          Gaps.hGap10,
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.sp, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
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
            zoomControlsEnabled: false,
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: colors.main.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        if (_isResolvingTap)
          Positioned(
            top: 12.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 14.w,
                      height: 14.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    Gaps.hGap8,
                    Text(
                      'gettingAddress'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSelectedAddressBar() {
    if (_selectedAddress.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colors.main.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colors.main.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.place_rounded, color: colors.main, size: 18.sp),
            Gaps.hGap10,
            Expanded(
              child: Text(
                _selectedAddress,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
