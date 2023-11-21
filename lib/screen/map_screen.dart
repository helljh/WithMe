import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  NaverMapController? mapController;
  Location location = Location();
  double zoomLevel = 17;

  bool? serviceEnabled;
  PermissionStatus? permissionGranted;
  LocationData? locationData;

  NMarker? currentLocationMarker;

  final marker = NMarker(
      id: 'test',
      position: const NLatLng(37.506932467450326, 127.05578661133796));

  String address = "서울 성북구 서경로 79 명성맨션";
  Future<Map<String, dynamic>> getCoordinatesFromAddress(String address) async {
    const String clientId = '38k3gvz9d4'; // 발급받은 Client ID
    const String clientSecret =
        'vI48LFzg12g7qgNoy8pyS3b5MU5Ka5pyPvGkb0eW'; // 발급받은 Client Secret

    final response = await http.get(
      Uri.parse(
          'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$address'),
      headers: {
        "X-NCP-APIGW-API-KEY-ID": clientId,
        "X-NCP-APIGW-API-KEY": clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['addresses'].isNotEmpty) {
        final addr = jsonResponse['addresses'][0];
        final latitude = addr['y'];
        final longitude = addr['x'];
        print('$latitude, $longitude');
        return {
          "latitude": addr['y'],
          "longitude": addr['x'],
        };
      } else {
        return {};
      }
    } else {
      throw Exception('Failed to load coordinates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkPermission(),
      builder: (context, snapshot) {
        if (!snapshot.hasData &&
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data != '허가') {
          return Center(
            child: Text(
              snapshot.data.toString(),
            ),
          );
        } else {
          getCoordinatesFromAddress(address);
          return NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                  target:
                      NLatLng(locationData!.latitude!, locationData!.latitude!),
                  zoom: zoomLevel),
              locationButtonEnable: true,
              indoorEnable: true,
            ),
            onMapReady: (controller) {
              mapControllerCompleter.complete(controller);
              mapController = controller;
              mapController!
                  .setLocationTrackingMode(NLocationTrackingMode.follow);
              final marker1 = NMarker(
                  isForceShowIcon: true,
                  icon: const NOverlayImage.fromAssetImage(
                      'assets/image/marker.png'),
                  iconTintColor: Colors.green.shade200,
                  id: 'thaesarang',
                  size: const Size(30, 30),
                  position: const NLatLng(37.6103188, 127.0144771));
              final marker2 = NMarker(
                  isForceShowIcon: true,
                  icon: const NOverlayImage.fromAssetImage(
                      'assets/image/marker.png'),
                  iconTintColor: Colors.orange.shade200,
                  id: 'grandmaroom',
                  size: const Size(30, 30),
                  position: const NLatLng(37.6104740, 127.0143403));
              final marker3 = NMarker(
                  isForceShowIcon: true,
                  icon: const NOverlayImage.fromAssetImage(
                      'assets/image/marker.png'),
                  iconTintColor: Colors.orange.shade200,
                  id: 'raurel',
                  size: const Size(30, 30),
                  position: const NLatLng(37.6150457, 127.0133575));
              final marker4 = NMarker(
                  isForceShowIcon: true,
                  icon: const NOverlayImage.fromAssetImage(
                      'assets/image/marker.png'),
                  iconTintColor: Colors.green.shade200,
                  id: 'hwayummaratang',
                  size: const Size(30, 30),
                  position: const NLatLng(37.6104549, 127.0147741));
              final marker5 = NMarker(
                  isForceShowIcon: true,
                  icon: const NOverlayImage.fromAssetImage(
                      'assets/image/marker.png'),
                  iconTintColor: Colors.blue.shade200,
                  id: 'rushpc',
                  size: const Size(30, 30),
                  position: const NLatLng(37.6103093, 127.0145073));

              controller
                  .addOverlayAll({marker1, marker2, marker3, marker4, marker});
            },
          );
        }
      },
    );
  }

  Widget mapMarker() {
    return const FaIcon(FontAwesomeIcons.pencil);
  }

  Widget _zoomControls() {
    return Column(
      children: [
        FloatingActionButton(
          mini: true,
          child: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              zoomLevel = zoomLevel + 1;
              print("현재 줌 $zoomLevel");
            });
            // 줌 인
          },
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          mini: true,
          child: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              zoomLevel = zoomLevel - 1;
              print("현재 줌 $zoomLevel");
            });
            // 줌 아웃
          },
        ),
      ],
    );
  }

  // void _changeZoomLevel(bool zoomIn) {
  //   setState(() {
  //     zoomLevel = zoomIn ? zoomLevel + 1 : zoomLevel - 1;
  //     //mapController.;
  //   });
  // }

  Future<String> checkPermission() async {
    var serviceEnabled = await location.serviceEnabled(); // 위치 서비스 활성화 여부 확인

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return '위치 서비스를 활성화해주세요.';
      }
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == LocationPermission.denied) {
      // 위치 권한 거절됨
      // 위치 권한 요청하기
      permissionGranted = await location.requestPermission();

      return '위치 권한을 허가해주세요.';
    }

    // 위치 권한 거절됨(앱에서 재요청 불가)
    if (permissionGranted == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해주세요.';
    }

    locationData = await location.getLocation();
    if (locationData!.latitude != null && locationData!.longitude != null) {
      currentLocationMarker = NMarker(
        id: "current_location",
        position: NLatLng(locationData!.latitude!, locationData!.longitude!),
      );
    }

    // 위 모든 조건이 통과되면 위치 권한 허가 완료
    return '허가';
  }
}
